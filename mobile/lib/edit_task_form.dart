import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'tasks_list.dart'; // Import para usar la clase Task
import 'api_config.dart';

class EditTaskForm extends StatefulWidget {
  const EditTaskForm({super.key});

  @override
  EditTaskFormState createState() => EditTaskFormState();
}

class EditTaskFormState extends State<EditTaskForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _isCompleted = false;
  
  Task? _task;
  String? _token;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_task == null) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      _token = args['token'] as String;
      _task = args['task'] as Task;
      
      // Inicializar los controladores con los datos existentes
      _titleController.text = _task!.title;
      _descriptionController.text = _task!.description;
      _isCompleted = _task!.isCompleted;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      var url = ApiConfig.createUri('${ApiConfig.tasksEndpoint}/${_task!.id}');
      var response = await http.put(
        url,
        headers: ApiConfig.getHeaders(token: _token),
        body: json.encode({
          'title': _titleController.text.trim(),
          'description': _descriptionController.text.trim(),
          'isCompleted': _isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea actualizada exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Regresa con resultado positivo
      } else {
        _showError('Error al actualizar la tarea (${response.statusCode})');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteTask() async {
    bool? confirmed = await _showDeleteConfirmation();
    if (confirmed != true) return;

    setState(() => _isLoading = true);

    try {
      var url = ApiConfig.createUri('${ApiConfig.tasksEndpoint}/${_task!.id}');
      var response = await http.delete(
        url,
        headers: ApiConfig.getHeaders(token: _token),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tarea eliminada correctamente'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pop(context, true); // Regresa con resultado positivo
      } else {
        _showError('Error al eliminar la tarea (${response.statusCode})');
      }
    } catch (e) {
      _showError('Error de conexión: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<bool?> _showDeleteConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar tarea'),
          content: Text('¿Estás seguro de que deseas eliminar "${_task!.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarea'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _deleteTask,
            icon: const Icon(Icons.delete),
            tooltip: 'Eliminar tarea',
          ),
          TextButton(
            onPressed: _isLoading ? null : _updateTask,
            child: Text(
              'GUARDAR',
              style: TextStyle(
                color: _isLoading ? Colors.white54 : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estado de la tarea
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(
                        _isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                        color: _isCompleted ? Colors.green : Colors.grey,
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estado de la tarea',
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                            Text(
                              _isCompleted ? 'Completada' : 'Pendiente',
                              style: TextStyle(
                                color: _isCompleted ? Colors.green : Colors.orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _isCompleted,
                        onChanged: (value) {
                          setState(() => _isCompleted = value);
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Título de la tarea
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Título de la tarea *',
                  hintText: 'Ej: Completar proyecto Flutter',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'El título es obligatorio';
                  }
                  if (value.trim().length < 3) {
                    return 'El título debe tener al menos 3 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 16),
              
              // Descripción de la tarea
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descripción *',
                  hintText: 'Describe los pasos o detalles de la tarea...',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'La descripción es obligatoria';
                  }
                  if (value.trim().length < 10) {
                    return 'La descripción debe tener al menos 10 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 24),
              
              // Información de la tarea
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.edit_note, color: Colors.amber),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Editando tarea',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                          Text(
                            'ID: ${_task?.id ?? 'N/A'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Spacer(),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isLoading ? null : _deleteTask,
                      icon: const Icon(Icons.delete),
                      label: const Text('ELIMINAR'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'ACTUALIZAR TAREA',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}