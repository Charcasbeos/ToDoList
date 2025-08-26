// import 'package:flutter/material.dart';
// import 'package:todolist/models/task.dart';

// class CreateTask extends StatefulWidget {
//   final Function(Task) onAddTask;
//   final Task? taskToEdit;
//   CreateTask({super.key, required this.onAddTask, this.taskToEdit});

//   @override
//   State<CreateTask> createState() => _CreateTaskState();
// }

// class _CreateTaskState extends State<CreateTask> {
//   int selectedIndex = -1; // -1 = chưa chọn
//   late Task task;
//   TextEditingController _titleController = TextEditingController();
//   TextEditingController _notesController = TextEditingController();
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;

//   // neu du lieu task duoc gui qua tu todo_page
//   @override
//   void initState() {
//     super.initState();
//     _titleController = TextEditingController(
//       text: widget.taskToEdit?.title ?? '',
//     );
//     _notesController = TextEditingController(
//       text: widget.taskToEdit?.notes ?? '',
//     );
//     selectedDate = widget.taskToEdit?.date;
//     selectedTime = widget.taskToEdit?.time;
//     if (widget.taskToEdit != null) {
//       // set selectedIndex theo category
//       switch (widget.taskToEdit!.category) {
//         case Category.task:
//           selectedIndex = 0;
//           break;
//         case Category.event:
//           selectedIndex = 1;
//           break;
//         case Category.goal:
//           selectedIndex = 2;
//           break;
//       }
//     }
//   }

//   final List<Map<String, dynamic>> buttons = [
//     {"icon": "lib/images/task.png", "color": Color(0xFFDBECF6)},
//     {"icon": "lib/images/event.png", "color": Color(0xFFE7E2F3)},
//     {"icon": "lib/images/trophy.png", "color": Color(0xFFFEF5D3)},
//   ];
//   // Hàm chọn ngày
//   Future<void> _pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null) {
//       setState(() {
//         selectedDate = picked;
//       });
//     }
//   }

//   // Hàm chọn giờ
//   Future<void> _pickTime() async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime ?? TimeOfDay.now(),
//     );

//     if (picked != null) {
//       setState(() {
//         selectedTime = picked;
//       });
//     }
//   }

//   // Save task
//   void saveTask() {
//     if (_titleController.text.isEmpty ||
//         selectedIndex == -1 ||
//         selectedDate == null ||
//         _notesController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Please fill all required fields")),
//       );
//       return;
//     }

//     Category category;
//     switch (selectedIndex) {
//       case 0:
//         category = Category.task;
//         break;
//       case 1:
//         category = Category.event;
//         break;
//       case 2:
//         category = Category.goal;
//         break;
//       default:
//         category = Category.task;
//     }
//     // Chuyển TimeOfDay sang phút
//     int? timeInMinutes;
//     if (selectedTime != null) {
//       timeInMinutes = selectedTime!.hour * 60 + selectedTime!.minute;
//     }
//     Task newTask = Task(
//       title: _titleController.text,
//       category: category,
//       date: selectedDate!,
//       timeInMinutes: timeInMinutes,
//       notes: _notesController.text,
//       isCompleted: false,
//     );
//     // Gọi callback từ TodoPage
//     widget.onAddTask(newTask);

//     // Quay về TodoPage
//     Navigator.pop(context);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(63),
//         child: Stack(
//           children: [
//             Container(
//               color: Color(0xFF4A3780),
//               width: double.infinity,
//               height: 222,
//             ),
//             Positioned(
//               top: -48,
//               left: -230,
//               child: Container(
//                 width: 342,
//                 height: 342,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Color(0xFF5b498b), width: 44),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: -20,
//               left: 250,
//               child: Container(
//                 width: 145,
//                 height: 145,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: Color(0xFF5b498b), width: 35),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 40,
//               left: 10,
//               child: Container(
//                 width: 35,
//                 height: 35,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(50),
//                 ),
//                 child: GestureDetector(
//                   onTap: () => Navigator.pop(context),
//                   child: Center(
//                     child: Icon(
//                       Icons.keyboard_arrow_left_sharp,
//                       color: Color(0xFF5b498b),
//                       size: 20, // tùy chỉnh size
//                     ),
//                   ),
//                 ),
//               ),
//             ),

//             Center(
//               child: Text(
//                 widget.taskToEdit != null ? "Edit Task" : "Add New Task",
//                 style: TextStyle(
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: Container(
//         color: Colors.white,
//         padding: EdgeInsets.only(top: 16, left: 16, right: 16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Task title
//             Text("Task title", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             TextField(
//               decoration: InputDecoration(
//                 hintText: "Task title",
//                 // filled: true, // phải bật để dùng fillColor
//                 fillColor: Colors.white, // màu nền
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(5),
//                   borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//                 ),
//                 filled: true,
//                 contentPadding: EdgeInsets.symmetric(
//                   horizontal: 10,
//                   vertical: 2,
//                 ),
//               ),
//               controller: _titleController,
//               style: TextStyle(
//                 color: Colors.black,
//                 fontSize: 12, // màu chữ
//               ),
//             ),
//             // Category
//             const SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text("Category", style: TextStyle(fontWeight: FontWeight.bold)),
//                 SizedBox(width: 20, height: 1),
//                 SizedBox(
//                   width: 180,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: List.generate(buttons.length, (index) {
//                       bool isSelected = selectedIndex == index;
//                       return GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             selectedIndex = index;
//                           });
//                         },
//                         child: AnimatedContainer(
//                           duration: Duration(milliseconds: 200),
//                           width: isSelected ? 50 : 48, // to khi chọn
//                           height: isSelected ? 50 : 48,
//                           decoration: BoxDecoration(
//                             color: buttons[index]["color"],
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isSelected ? Colors.red : Colors.white,
//                               width: 1,
//                             ),
//                           ),

//                           child: Center(
//                             child: Image.asset(
//                               buttons[index]["icon"],
//                               width: 16,
//                               height: 16,
//                               color: Colors.black,
//                             ),
//                           ),
//                         ),
//                       );
//                     }),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//             // Date & time
//             Row(
//               children: [
//                 // Date
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Date",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       TextFormField(
//                         readOnly: true,
//                         onTap: _pickDate,
//                         style: TextStyle(fontSize: 12),
//                         decoration: InputDecoration(
//                           hintText: "Date",
//                           suffixIcon: const Icon(
//                             Icons.calendar_today,
//                             color: Color(0xFF5b498b),
//                           ),

//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: selectedDate != null
//                               ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
//                               : "",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 // Time
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Time",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       TextFormField(
//                         readOnly: true,
//                         onTap: _pickTime,
//                         style: TextStyle(fontSize: 12),
//                         decoration: InputDecoration(
//                           hintText: "Time",
//                           suffixIcon: const Icon(
//                             Icons.access_time,
//                             color: Color(0xFF5b498b),
//                           ),

//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: selectedTime != null
//                               ? "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}"
//                               : "",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Note
//             Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(height: 10),
//             SizedBox(
//               height: 177,
//               child: TextField(
//                 maxLines: null, // cho phép xuống dòng
//                 expands: true, // mở rộng full chiều cao của SizedBox
//                 textAlignVertical: TextAlignVertical.top,
//                 decoration: InputDecoration(
//                   hintText: "Notes",
//                   // filled: true, // phải bật để dùng fillColor
//                   fillColor: Colors.white, // màu nền
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5),
//                     borderSide: BorderSide(
//                       color: Colors.grey.shade300,
//                       width: 1,
//                     ),
//                   ),
//                   filled: true,
//                   isDense: true,
//                   contentPadding: EdgeInsets.symmetric(
//                     horizontal: 10,
//                     vertical: 10,
//                   ),
//                 ),
//                 controller: _notesController,
//                 style: TextStyle(
//                   color: Colors.black,
//                   fontSize: 12, // màu chữ
//                 ),
//               ),
//             ),

//             Container(
//               margin: EdgeInsets.only(top: 10),
//               child: GestureDetector(
//                 onTap: saveTask,
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Container(
//                       width: 250,
//                       padding: EdgeInsets.symmetric(vertical: 16),
//                       decoration: BoxDecoration(
//                         color: Color(0xFF4A3780),
//                         borderRadius: BorderRadius.circular(50),
//                       ),
//                       child: Text(
//                         widget.taskToEdit != null ? "Update" : "Save",
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
