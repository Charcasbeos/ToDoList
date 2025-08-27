import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todolist/components/task_item.dart';
import 'package:todolist/models/task.dart';
import 'package:todolist/pages/create_task_hive.dart';

class TodoPageHive extends StatelessWidget {
  final Box<Task> tasksBox = Hive.box<Task>("tasksBox");
  TodoPageHive({super.key});
  void onChecked(value, Task? task, int index) {
    if (task != null) {
      task.isCompleted = value;
      task.save(); // Cập nhật vào Hive
    }
    print(index);
  }

  TimeOfDay intToTimeOfDay(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Screen base
            Column(
              children: [
                // Header
                Expanded(
                  flex: 1,
                  child: Stack(
                    children: [
                      // Title
                      Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFF4A3780),
                        ),
                        height: 390,
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
                    ],
                  ),
                ),
                Expanded(flex: 3, child: Container(color: Color(0xfff1f5f9))),
              ],
            ),
            // List of tasks
            Positioned(
              top: 10,
              left: 20,
              right: 20,
              bottom: 0,
              child: Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      children: [
                        // Title
                        Expanded(
                          flex: 3,
                          child: Center(
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
                        ),

                        // List completed
                        Flexible(
                          flex: 6,
                          fit: FlexFit.loose,
                          child: ValueListenableBuilder(
                            valueListenable: tasksBox.listenable(),
                            builder: (context, Box<Task> box, _) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  // Lấy danh sách các task đã hoàn thành
                                  final uncompletedTasks = tasksBox.values
                                      .where((task) => !task.isCompleted)
                                      .toList();

                                  double listHeight = constraints.maxHeight;
                                  // Chia chiều cao cho tối đa 3 item
                                  double itemHeight = listHeight / 3;
                                  // Kiểm tra danh sách rỗng
                                  if (uncompletedTasks.isEmpty) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      height: 73,
                                      child: const Center(
                                        child: Text('No tasks'),
                                      ),
                                    );
                                  }
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          itemHeight * uncompletedTasks.length,
                                      minHeight: 0,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        color: Colors.white,
                                        child: ValueListenableBuilder(
                                          valueListenable: tasksBox
                                              .listenable(),
                                          builder: (context, Box<Task> box, _) {
                                            return ListView.builder(
                                              itemCount:
                                                  uncompletedTasks.length,
                                              itemBuilder: (context, index) {
                                                final task =
                                                    uncompletedTasks[index];
                                                return SizedBox(
                                                  height: itemHeight,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: TaskItem(
                                                          task: task,
                                                          onChecked: (value) =>
                                                              onChecked(
                                                                value,
                                                                task,
                                                                index,
                                                              ),
                                                          onTap: (task) {
                                                            task.isCompleted
                                                                ? ""
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (_) => CreateTaskHive(
                                                                        taskToEdit:
                                                                            task,
                                                                      ),
                                                                    ),
                                                                  );
                                                          },
                                                        ),
                                                      ),
                                                      if (index !=
                                                          uncompletedTasks
                                                                  .length -
                                                              1)
                                                        Divider(
                                                          color:
                                                              Colors.grey[300],
                                                          height: 1,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        // Completed title
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Completed",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // List completed
                        Flexible(
                          flex: 6,
                          fit: FlexFit.loose,
                          child: ValueListenableBuilder(
                            valueListenable: tasksBox.listenable(),
                            builder: (context, Box<Task> box, _) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  // Lấy danh sách các task đã hoàn thành
                                  final completedTasks = tasksBox.values
                                      .where((task) => task.isCompleted)
                                      .toList();

                                  double listHeight = constraints.maxHeight;
                                  // Chia chiều cao cho tối đa 3 item
                                  double itemHeight = listHeight / 3;
                                  if (completedTasks.isEmpty) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      height: 73,
                                      child: const Center(
                                        child: Text('No tasks'),
                                      ),
                                    );
                                  }
                                  return ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight:
                                          itemHeight * completedTasks.length,
                                      minHeight: 0,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        color: Colors.red,
                                        child: ValueListenableBuilder(
                                          valueListenable: tasksBox
                                              .listenable(),
                                          builder: (context, Box<Task> box, _) {
                                            // Kiểm tra danh sách rỗng
                                            if (completedTasks.isEmpty) {
                                              return const Center(
                                                child: Text('No tasks'),
                                              );
                                            }
                                            return ListView.builder(
                                              itemCount: completedTasks.length,
                                              itemBuilder: (context, index) {
                                                final task =
                                                    completedTasks[index];
                                                return SizedBox(
                                                  height: itemHeight,
                                                  child: Column(
                                                    children: [
                                                      Expanded(
                                                        child: TaskItem(
                                                          task: task,
                                                          onChecked: (value) =>
                                                              onChecked(
                                                                value,
                                                                task,
                                                                index,
                                                              ),
                                                          onTap: (task) {
                                                            task.isCompleted
                                                                ? ""
                                                                : Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (_) => CreateTaskHive(
                                                                        taskToEdit:
                                                                            task,
                                                                      ),
                                                                    ),
                                                                  );
                                                          },
                                                        ),
                                                      ),
                                                      if (index !=
                                                          completedTasks
                                                                  .length -
                                                              1)
                                                        Divider(
                                                          color:
                                                              Colors.grey[300],
                                                          height: 1,
                                                        ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Button Add new Task
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CreateTaskHive()),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
