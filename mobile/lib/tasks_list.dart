import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'api_config.dart';

class Task {
  final String id;
  final String title;
  final String description;
  bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Sin título',
      description: json['description'] ?? 'Sin descripción',
      isCompleted: json['isCompleted'] ?? json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
  };
}

class TasksList extends StatefulWidget {
  final String token;

  const TasksList({super.key, required this.token});

  @override
  TasksListState createState() => TasksListState();
}

class TasksListState extends State<TasksList> {
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = true;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      final url = ApiConfig.createUri(ApiConfig.tasksEndpoint);
      print('Loading tasks from: $url');
      
      final response = await http.get(
        url,
        headers: ApiConfig.getHeaders(token: widget.token),
      ).timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        List<dynamic> tasksJson = _parseResponse(responseData);
        
        setState(() {
          _tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
          _filterTasks();
        });
      } else {
        _showError('Error al cargar tareas (${response.statusCode})');
      }
    } catch (e) {
      print('Error loading tasks: $e');
      _showError('Error de conexión: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  List<dynamic> _parseResponse(dynamic responseData) {
    if (responseData is List) return responseData;
    if (responseData is Map) {
      if (responseData['data'] != null) return responseData['data'];
      if (responseData['tasks'] != null) return responseData['tasks'];
      if (responseData['items'] != null) return responseData['items'];
    }
    throw Exception('Formato de respuesta no reconocido');
  }

  void _filterTasks() {
    final query = _searchQuery.toLowerCase();
    setState(() {
      _filteredTasks = _tasks.where((task) {
        return task.title.toLowerCase().contains(query) || 
               task.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _toggleTaskComplete(Task task) async {
    try {
      final url = ApiConfig.createUri('${ApiConfig.tasksEndpoint}/${task.id}');
      var response = await http.put(
        url,
        headers: ApiConfig.getHeaders(token: widget.token),
        body: json.encode({
          'title': task.title,
          'description': task.description,
          'isCompleted': !task.isCompleted,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          task.isCompleted = !task.isCompleted;
          _filterTasks();
        });
        _showSuccess(task.isCompleted ? 'Tarea completada' : 'Tarea pendiente');
      } else {
        _showError('Error al completar tarea: (${response.statusCode})');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    }
  }

  Future<void> _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmar'),
        content: Text('¿Eliminar "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      final url = ApiConfig.createUri('${ApiConfig.tasksEndpoint}/${task.id}');
      final response = await http.delete(
        url,
        headers: ApiConfig.getHeaders(token: widget.token),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        setState(() {
          _tasks.removeWhere((t) => t.id == task.id);
          _filterTasks();
        });
        _showSuccess('Tarea eliminada');
      } else {
        _showError('Error al eliminar (${response.statusCode})');
      }
    } catch (e) {
      _showError('Error: ${e.toString()}');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTasks,
          ),
           IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navigateToCreateTask,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar tareas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          _buildStatsRow(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadTasks,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (ctx, index) => _buildTaskCard(_filteredTasks[index]),
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToCreateTask,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildStatsRow() {
    final completed = _tasks.where((t) => t.isCompleted).length;
    final pending = _tasks.length - completed;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _StatCard(title: 'Total', count: _tasks.length, color: Colors.blue),
          _StatCard(title: 'Pendientes', count: pending, color: Colors.orange),
          _StatCard(title: 'Completadas', count: completed, color: Colors.green),
        ],
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (_) => _toggleTaskComplete(task),
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Text(task.description),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') _navigateToEditTask(task);
            if (value == 'delete') _deleteTask(task);
          },
          itemBuilder: (ctx) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Editar'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Eliminar', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
        onTap: () => _navigateToEditTask(task),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.task : Icons.search_off,
            size: 64,
            color: Colors.grey,
          ),
          Text(
            _searchQuery.isEmpty 
                ? 'No hay tareas registradas'
                : 'No se encontraron resultados',
            style: const TextStyle(fontSize: 18),
          ),
          if (_searchQuery.isEmpty)
            TextButton(
              onPressed: _navigateToCreateTask,
              child: const Text('Crear primera tarea'),
            ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filterTasks();
    });
  }

  void _navigateToCreateTask() async {
    final result = await Navigator.pushNamed(
      context,
      '/create-task',
      arguments: widget.token,
    );
    if (result == true) _loadTasks();
  }

  void _navigateToEditTask(Task task) async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-task',
      arguments: {'token': widget.token, 'task': task},
    );
    if (result == true) _loadTasks();
  }

  void _logout() {
    Navigator.pushReplacementNamed(context, '/');
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _StatCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            title,
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}