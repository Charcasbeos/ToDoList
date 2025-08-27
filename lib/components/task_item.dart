import 'package:flutter/material.dart';
import 'package:todolist/models/task.dart';

class TaskItem extends StatefulWidget {
  final Function(bool?)? onChecked;
  final Function(Task) onTap;
  final Task task;

  const TaskItem({
    super.key,
    required this.task,
    required this.onChecked,
    required this.onTap,
  });

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
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
        return const Color(0xFFDBECF6);
      case Category.goal:
        return const Color(0xFFFEF5D3);
      case Category.event:
        return const Color(0xFFE7E2F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để scale UI
    final screenWidth = MediaQuery.of(context).size.width;
    final scale = screenWidth / 375; // 375 là width chuẩn (iPhone 11)

    return Padding(
      padding: EdgeInsets.only(top: 0 * scale),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12 * scale,
          vertical: 10 * scale,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Phần nội dung (icon + text)
            Expanded(
              child: GestureDetector(
                onTap: () => widget.onTap(widget.task),
                child: Opacity(
                  opacity: widget.task.isCompleted ? 0.5 : 1.0,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: _getColor(widget.task.category),
                        radius: 18,
                        child: Image.asset(
                          _getImage(widget.task.category),
                          color: Colors.black,
                          width: 16 * scale,
                          height: 16 * scale,
                        ),
                      ),
                      SizedBox(width: 12 * scale),
                      Flexible(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.task.title,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration: widget.task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            if (widget.task.timeInMinutes != null)
                              Text(
                                intToTimeOfDay(
                                  widget.task.timeInMinutes!,
                                ).format(context),
                                style: TextStyle(
                                  decoration: widget.task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontSize: 14 * scale,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Checkbox riêng
            Transform.scale(
              scale: scale, // scale checkbox theo màn hình
              child: Checkbox(
                value: widget.task.isCompleted,
                onChanged: widget.onChecked,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
