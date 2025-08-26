import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/pages/create_task_hive.dart';
import 'package:todolist/pages/todo_page_hive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(CategoryAdapter());
  Hive.registerAdapter(TaskAdapter());

  await Hive.openBox<Task>('tasksBox');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoPageHive(),
      routes: {
        // '/createtask': (context) => CreateTask(
        //   onAddTask: (task) {
        //     // callback sẽ được TodoPage truyền khi pushNamed
        //   },
        // ),
        '/createtaskhive': (context) => CreateTaskHive(),
      },
    );
  }
}
