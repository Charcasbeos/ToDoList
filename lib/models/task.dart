// import 'package:flutter/material.dart';

// enum Category { task, event, goal }

// class Task {
//   final String title;
//   final Category category;
//   final DateTime date;
//   final TimeOfDay? time;
//   final String notes;
//   bool isCompleted;

//   Task({
//     required this.title,
//     required this.category,
//     required this.date,
//     required this.notes,
//     required this.isCompleted,
//     this.time,
//   });
// }
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
enum Category {
  @HiveField(0)
  task,
  @HiveField(1)
  event,
  @HiveField(2)
  goal,
}

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final Category category;

  @HiveField(2)
  final DateTime date;

  @HiveField(3)
  int? timeInMinutes;

  @HiveField(4)
  final String notes;

  @HiveField(5)
  bool isCompleted;

  Task({
    required this.title,
    required this.category,
    required this.date,
    required this.notes,
    this.timeInMinutes,
    this.isCompleted = false,
  });

  // Getter trả về TimeOfDay từ int
  TimeOfDay? get time {
    if (timeInMinutes == null) return null;
    return TimeOfDay(hour: timeInMinutes! ~/ 60, minute: timeInMinutes! % 60);
  }

  // Setter nhận TimeOfDay và chuyển sang int
  set time(TimeOfDay? value) {
    if (value == null) {
      timeInMinutes = null;
    } else {
      timeInMinutes = value.hour * 60 + value.minute;
    }
  }
}
