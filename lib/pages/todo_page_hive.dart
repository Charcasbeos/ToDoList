import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todolist/components/task_item.dart';
import 'package:todolist/main.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/pages/create_task_hive.dart';

class TodoPageHive extends StatelessWidget {
  final Box<Task> tasksBox = Hive.box<Task>("tasksBox");

  TodoPageHive({super.key});
  void onChecked(value, Task? task) {
    if (task != null) {
      task.isCompleted = value;
      task.save(); // Cập nhật vào Hive
    }
  }

  TimeOfDay intToTimeOfDay(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Screen base
          Column(
            children: [
              // Header
              Stack(
                children: [
                  // Title
                  Container(
                    decoration: const BoxDecoration(color: Color(0xFF4A3780)),
                    height: 222,
                    width: 390,
                    child: const Padding(padding: EdgeInsets.only(top: 46)),
                  ),
                  // Circle 1
                  Positioned(
                    top: 78,
                    left: -191,
                    child: Container(
                      width: 342,
                      height: 342,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF5b498b),
                          width: 44,
                        ),
                      ),
                    ),
                  ),
                  // Circle 2
                  Positioned(
                    top: -20,
                    left: 250,
                    child: Container(
                      width: 145,
                      height: 145,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF5b498b),
                          width: 35,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                    child: Text(
                      "My Todo List",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 30,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // Button Add new Task
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  color: const Color(0xFFF1F5F9),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => CreateTaskHive()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A3780),
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Text(
                            "Add New Task",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // List of tasks
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.white,
                child: ValueListenableBuilder(
                  valueListenable: tasksBox.listenable(),
                  builder: (context, Box<Task> box, _) {
                    // Lấy danh sách các task chua hoàn thành
                    final completedTasks = box.values
                        .where((task) => !task.isCompleted)
                        .toList();

                    // Kiểm tra danh sách rỗng
                    if (completedTasks.isEmpty) {
                      return Container(
                        height: 70,
                        child: const Center(child: Text('No tasks')),
                      );
                    }
                    // Tính chiều cao động: mỗi TaskItem 70px, tối đa 210px
                    double dynamicHeight = min(
                      completedTasks.length * 70.0,
                      210.0,
                    );
                    return SizedBox(
                      height: dynamicHeight,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final task = box.getAt(index);
                          if (task == null || task.isCompleted) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              TaskItem(
                                task: task,
                                onChecked: (value) => onChecked(value, task),
                                onTap: (task) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CreateTaskHive(taskToEdit: task),
                                    ),
                                  );
                                },
                              ),
                              if (index != box.length - 1)
                                Divider(color: Colors.grey[300], height: 1),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          // Completed title
          const Positioned(
            top: 320,
            left: 20,
            right: 20,
            child: Text(
              "Completed",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          // List completed
          Positioned(
            top: 350,
            left: 20,
            right: 20,

            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.white,
                child: ValueListenableBuilder(
                  valueListenable: tasksBox.listenable(),
                  builder: (context, Box<Task> box, _) {
                    // Lấy danh sách các task đã hoàn thành
                    final completedTasks = box.values
                        .where((task) => task.isCompleted)
                        .toList();

                    // Kiểm tra danh sách rỗng
                    if (completedTasks.isEmpty) {
                      return Container(
                        height: 70,
                        child: const Center(child: Text('No tasks')),
                      );
                    }
                    // Tính chiều cao động: mỗi TaskItem 70px, tối đa 210px
                    double dynamicHeight = min(
                      completedTasks.length * 70.0,
                      210.0,
                    );
                    return SizedBox(
                      height: dynamicHeight,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          final task = box.getAt(index);
                          if (task == null || !task.isCompleted) {
                            return const SizedBox.shrink();
                          }
                          return Column(
                            children: [
                              TaskItem(
                                task: task,
                                onChecked: (value) => onChecked(value, task),
                                onTap: (task) {
                                  task.isCompleted
                                      ? ""
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => CreateTaskHive(
                                              taskToEdit: task,
                                            ),
                                          ),
                                        );
                                },
                              ),
                              if (index != box.length - 1)
                                Divider(color: Colors.grey[300], height: 1),
                            ],
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
