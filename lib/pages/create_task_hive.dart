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
  final _formKey = GlobalKey<FormState>();
  bool checkCategory = true;
  bool isCheckCategory = true;
  bool checkDate = true;
  bool isSelectedDate = true;

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
        checkDate = true;
        isSelectedDate = true;
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
    if (selectedIndex == -1) {
      setState(() {
        isCheckCategory = false;
      });
    }
    if (selectedDate == null) {
      setState(() {
        isSelectedDate = false;
      });
    }
    if (!_formKey.currentState!.validate() ||
        _titleController.text.isEmpty ||
        selectedIndex == -1 ||
        selectedDate == null ||
        _notesController.text.isEmpty) {
      return;
    }

    Category category = Category.values[selectedIndex];

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
    print(isCheckCategory);
    print(checkCategory);
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(83),
        child: SafeArea(
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
                top: 0,
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
                top: 25,
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
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus(); // ẩn bàn phím
        },

        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _formKey,
          child: Container(
            color: Color(0xfff1f5f9),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  flex: 11,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Task title
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Task title",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "Task title",
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  // filled: true, // phải bật để dùng fillColor
                                  fillColor: Colors.white, // màu nền
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ), // bo tròn
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(
                                      color: Colors.grey.shade300,
                                      width: 1,
                                    ),
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
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter some text';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Category
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    "Category",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 7,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: List.generate(buttons.length, (
                                      index,
                                    ) {
                                      bool isSelected = selectedIndex == index;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index;
                                            checkCategory = true;
                                            isCheckCategory = true;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          width: isSelected
                                              ? 50
                                              : 48, // to khi chọn
                                          height: isSelected ? 50 : 48,
                                          decoration: BoxDecoration(
                                            color: buttons[index]["color"],
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? Colors.red
                                                  : Colors.white,
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
                            SizedBox(height: 2),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 1, width: 15),
                                Text(
                                  (checkCategory && isCheckCategory)
                                      ? ""
                                      : "Please choose category",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: const Color.fromARGB(
                                      255,
                                      173,
                                      33,
                                      33,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Date & time
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            // Date
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Date",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: _pickDate,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      hintText: "Date",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                      fillColor: Colors.white, // màu nền
                                      filled: true,
                                      suffixIcon: const Icon(
                                        Icons.calendar_today_outlined,
                                        size: 20,
                                        color: Color(0xFF5b498b),
                                      ),

                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ), // bo tròn
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                    controller: TextEditingController(
                                      text: selectedDate != null
                                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                                          : "",
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 1, width: 15),
                                      Text(
                                        (checkDate && isSelectedDate)
                                            ? ""
                                            : "Please choose date",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: const Color.fromARGB(
                                            255,
                                            173,
                                            33,
                                            33,
                                          ),
                                        ),
                                      ),
                                    ],
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    readOnly: true,
                                    onTap: _pickTime,
                                    style: TextStyle(fontSize: 12),
                                    decoration: InputDecoration(
                                      hintText: "Time",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade400,
                                      ),
                                      suffixIcon: const Icon(
                                        Icons.access_time,
                                        color: Color(0xFF5b498b),
                                      ),
                                      fillColor: Colors.white, // màu nền
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          5,
                                        ), // bo tròn
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(5),
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade300,
                                          width: 1,
                                        ),
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
                      ),
                      // Note
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Notes",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Expanded(
                              child: SizedBox(
                                child: TextFormField(
                                  maxLines: null, // cho phép xuống dòng
                                  expands:
                                      true, // mở rộng full chiều cao của SizedBox
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: InputDecoration(
                                    hintText: "Notes",
                                    hintStyle: TextStyle(
                                      color: Colors.grey.shade400,
                                    ),
                                    // filled: true, // phải bật để dùng fillColor
                                    fillColor: Colors.white, // màu nền
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(
                                        5,
                                      ), // bo tròn
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Save or Update button
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: saveTask,
                      child: Row(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
