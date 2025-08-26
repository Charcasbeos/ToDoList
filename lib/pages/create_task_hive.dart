import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todolist/models/task.dart';

class CreateTaskHive extends StatefulWidget {
  final Task? taskToEdit; // nếu có nghĩa là đang chỉnh sửa

  const CreateTaskHive({super.key, this.taskToEdit});

  @override
  State<CreateTaskHive> createState() => _CreateTaskHiveState();
}

class _CreateTaskHiveState extends State<CreateTaskHive> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int? timeInMinutes;
  int selectedIndex = -1;
  final List<Map<String, dynamic>> buttons = [
    {"icon": "lib/images/task.png", "color": Color(0xFFDBECF6)},
    {"icon": "lib/images/event.png", "color": Color(0xFFE7E2F3)},
    {"icon": "lib/images/trophy.png", "color": Color(0xFFFEF5D3)},
  ];

  // Hàm chọn ngày
  Future<void> _pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // Hàm chọn giờ
  Future<void> _pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.taskToEdit != null) {
      _titleController.text = widget.taskToEdit!.title;
      _notesController.text = widget.taskToEdit!.notes;
      selectedDate = widget.taskToEdit!.date;
      if (widget.taskToEdit!.timeInMinutes != null) {
        selectedTime = TimeOfDay(
          hour: widget.taskToEdit!.timeInMinutes! ~/ 60,
          minute: widget.taskToEdit!.timeInMinutes! % 60,
        );
      }
      selectedIndex = Category.values.indexOf(widget.taskToEdit!.category);
    }
  }

  void saveTask() async {
    if (_titleController.text.isEmpty ||
        selectedIndex == -1 ||
        selectedDate == null ||
        _notesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );

      return;
    }
    Category category = Category.values[selectedIndex];

    // // Chuyển TimeOfDay sang phút
    // print("selected " + selectedTime!.hour.toString());

    // if (selectedTime != null) {
    //   timeInMinutes = selectedTime!.hour * 60 + selectedTime!.minute;
    // }
    Task newTask = Task(
      title: _titleController.text,
      category: category,
      date: selectedDate!,
      timeInMinutes: selectedTime != null
          ? selectedTime!.hour * 60 + selectedTime!.minute
          : null,
      notes: _notesController.text,
      isCompleted: widget.taskToEdit?.isCompleted ?? false,
    );
    print("selectedTime " + selectedDate.toString());

    var box = Hive.box<Task>('tasksBox');

    if (widget.taskToEdit != null) {
      // Cập nhật task
      int index = box.values.toList().indexOf(widget.taskToEdit!);
      await box.putAt(index, newTask);
    } else {
      // Thêm mới task
      await box.add(newTask);
    }
    // ignore: use_build_context_synchronously
    Navigator.pop(context); // Quay lại trang trước
  }

  void pickDate() async {
    DateTime now = DateTime.now();
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: now,
      lastDate: DateTime(2100),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  void pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(63),
        child: Stack(
          children: [
            Container(
              color: Color(0xFF4A3780),
              width: double.infinity,
              height: 222,
            ),
            Positioned(
              top: -48,
              left: -230,
              child: Container(
                width: 342,
                height: 342,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF5b498b), width: 44),
                ),
              ),
            ),
            Positioned(
              top: -20,
              left: 250,
              child: Container(
                width: 145,
                height: 145,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xFF5b498b), width: 35),
                ),
              ),
            ),
            Positioned(
              top: 35,
              left: 10,
              child: Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Center(
                    child: Icon(
                      Icons.keyboard_arrow_left_sharp,
                      color: Color(0xFF5b498b),
                      size: 20, // tùy chỉnh size
                    ),
                  ),
                ),
              ),
            ),

            Center(
              child: Text(
                widget.taskToEdit != null ? "Edit Task" : "Add New Task",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task title
            Text("Task title", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: "Task title",
                // filled: true, // phải bật để dùng fillColor
                fillColor: Colors.white, // màu nền
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5),
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                filled: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
              ),
              controller: _titleController,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12, // màu chữ
              ),
            ),
            // Category
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(width: 20, height: 1),
                SizedBox(
                  width: 180,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(buttons.length, (index) {
                      bool isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          width: isSelected ? 50 : 48, // to khi chọn
                          height: isSelected ? 50 : 48,
                          decoration: BoxDecoration(
                            color: buttons[index]["color"],
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? Colors.red : Colors.white,
                              width: 1,
                            ),
                          ),

                          child: Center(
                            child: Image.asset(
                              buttons[index]["icon"],
                              width: 16,
                              height: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Date & time
            Row(
              children: [
                // Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Date",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        onTap: _pickDate,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "Date",
                          suffixIcon: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF5b498b),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        controller: TextEditingController(
                          text: selectedDate != null
                              ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                              : "",
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Time",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        readOnly: true,
                        onTap: _pickTime,
                        style: TextStyle(fontSize: 12),
                        decoration: InputDecoration(
                          hintText: "Time",
                          suffixIcon: const Icon(
                            Icons.access_time,
                            color: Color(0xFF5b498b),
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        controller: TextEditingController(
                          text: selectedTime != null
                              ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
                              : "",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Note
            Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 177,
              child: TextField(
                maxLines: null, // cho phép xuống dòng
                expands: true, // mở rộng full chiều cao của SizedBox
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: "Notes",
                  // filled: true, // phải bật để dùng fillColor
                  fillColor: Colors.white, // màu nền
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                ),
                controller: _notesController,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12, // màu chữ
                ),
              ),
            ),

            // Save or Update button
            Container(
              margin: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: saveTask,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 250,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF4A3780),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        widget.taskToEdit != null ? "Update" : "Save",
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
    );
  }
}
