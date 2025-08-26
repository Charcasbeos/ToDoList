import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';

// ignore: must_be_immutable
class TaskItem extends StatefulWidget {
  Function(bool?)? onChecked;
  Function(Task) onTap;
  Task task;
  TaskItem({
    super.key,
    required this.task,
    required this.onChecked,
    required this.onTap,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  // Chuyen int sang TimeOfDay
  TimeOfDay intToTimeOfDay(int minutes) {
    final int hour = minutes ~/ 60;
    final int minute = minutes % 60;
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _getImage(Category category) {
    switch (category) {
      case Category.task:
        return "lib/images/task.png";
      case Category.goal:
        return "lib/images/trophy.png";
      case Category.event:
        return "lib/images/event.png";
    }
  }

  Color _getColor(Category category) {
    switch (category) {
      case Category.task:
        return Color(0xFFDBECF6);
      case Category.goal:
        return Color(0xFFFEF5D3);
      case Category.event:
        return Color(0xFFE7E2F3);
    }
  }
  // Chuyển TimeOfDay sang phút

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Row con chứa icon + text, mờ khi completed
            Expanded(
              child: GestureDetector(
                onTap: () => widget.onTap(widget.task),
                child: Opacity(
                  opacity: widget.task.isCompleted ? 0.5 : 1.0,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: _getColor(widget.task.category),
                        child: Image.asset(
                          _getImage(widget.task.category),
                          color: Colors.black,
                          width: 16,
                          height: 16,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.task.title,
                            style: TextStyle(
                              decoration: widget.task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (widget.task.time != null)
                            Text(
                              intToTimeOfDay(
                                widget.task.timeInMinutes!,
                              ).format(context),
                              style: TextStyle(
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Checkbox riêng, không bị mờ
            Checkbox(
              value: widget.task.isCompleted,
              onChanged: widget.onChecked,
            ),
          ],
        ),
      ),
    );
  }
}
