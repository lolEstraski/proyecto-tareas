import 'package:flutter/material.dart';
import 'package:tasks_app/login_form.dart';
import 'package:tasks_app/register_form.dart';
import 'package:tasks_app/tasks_list.dart';
import 'package:tasks_app/create_task_form.dart';
import 'package:tasks_app/edit_task_form.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Gestor de Tareas';

    return MaterialApp(
      title: appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginForm(),
        '/register': (context) => const RegisterForm(),
        '/tasks': (context) {
          // Extraer el token de los argumentos
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return TasksList(token: token);
        },
        '/create-task': (context) => const CreateTaskForm(),
        '/edit-task': (context) => const EditTaskForm(),
      },
      // Manejo de rutas no encontradas
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Página no encontrada')),
            body: const Center(
              child: Text('La página solicitada no existe.'),
            ),
          ),
        );
      },
    );
  }
}