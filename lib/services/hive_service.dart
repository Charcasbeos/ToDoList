import 'package:hive/hive.dart';
import '../models/task.dart';

class HiveService {
  static const String taskBoxName = 'tasksBox';
  late Box<Task> _taskBox;

  // Khởi tạo HiveService và mở box
  Future<void> init() async {
    _taskBox = Hive.box<Task>(taskBoxName);
  }

  // Lấy tất cả task
  List<Task> getAllTasks() {
    return _taskBox.values.toList();
  }

  // Thêm task mới
  Future<void> addTask(Task task) async {
    await _taskBox.add(task);
  }

  // Update task tại index
  Future<void> updateTask(int index, Task task) async {
    await _taskBox.putAt(index, task);
  }

  // Xóa task tại index
  Future<void> deleteTask(int index) async {
    await _taskBox.deleteAt(index);
  }

  // Xóa tất cả task
  Future<void> clearTasks() async {
    await _taskBox.clear();
  }

  // Lấy task theo index
  Task? getTask(int index) {
    if (index < 0 || index >= _taskBox.length) return null;
    return _taskBox.getAt(index);
  }

  // Tổng số task
  int get taskCount => _taskBox.length;
  // Tổng số taskIsCompleted
  int taskIsCompletedCount(bool isCompleted) {
    return _taskBox.values
        .where((task) => task.isCompleted == isCompleted)
        .length;
  }
}
