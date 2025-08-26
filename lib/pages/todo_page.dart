// import 'package:flutter/material.dart';
// import 'package:todolist/components/task_item.dart';
// import 'package:todolist/models/task.dart';

// class TodoPage extends StatefulWidget {
//   const TodoPage({super.key});

//   @override
//   State<TodoPage> createState() => _TodoPageState();
// }

// class _TodoPageState extends State<TodoPage> {
//   //  Todo list default
//   List<Task> listDefault = [
//     Task(
//       title: "Study lesson",
//       category: Category.task,
//       date: DateTime(2025, 8, 25),
//       notes: "Review Flutter",
//       isCompleted: false,
//     ),
//     Task(
//       title: "Run 5km",
//       category: Category.goal,
//       date: DateTime(2025, 8, 22),
//       notes: "Run 5km at Ho Ban Nguyet",
//       isCompleted: true,
//     ),
//     Task(
//       title: "Go to party",
//       category: Category.event,
//       date: DateTime(2025, 9, 30),
//       notes: "Honey's birthday",
//       isCompleted: false,
//     ),
//   ];

//   //checkbox was tapped
//   void checkBoxChanged(bool? value, int index) {
//     setState(() {
//       listDefault[index].isCompleted = !listDefault[index].isCompleted;
//     });
//   }

//   // edit when onTap
//   void onTap(Task task, int index) {
//     setState(() {
//       listDefault[index] = task;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Screen
//           Column(
//             children: [
//               // Header
//               Stack(
//                 children: [
//                   // Title
//                   Container(
//                     decoration: BoxDecoration(color: Color(0xFF4A3780)),
//                     height: 222,
//                     width: 390,
//                     child: Padding(
//                       padding: const EdgeInsets.only(top: 46),
//                       child: Text(
//                         "My Todo List",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w700,
//                           fontSize: 30,
//                           color: Colors.white,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                   //  Circle 1
//                   Positioned(
//                     top: 78,
//                     left: -191,
//                     child: Container(
//                       width: 342,
//                       height: 342,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Color(0xFF5b498b), // viền tím, 50% opacity
//                           width: 44,
//                         ),
//                       ),
//                     ),
//                   ),
//                   //  Circle 2
//                   Positioned(
//                     top: -20,
//                     left: 250,
//                     child: Container(
//                       width: 145,
//                       height: 145,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: Color(0xFF5b498b), // viền tím, 50% opacity
//                           width: 35,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               // Button Add new Task
//               Expanded(
//                 child: Container(
//                   margin: EdgeInsets.only(bottom: 20),
//                   color: Color(0xFFF1F5F9),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context, // phải dùng context của TodoPage
//                         MaterialPageRoute(
//                           builder: (_) => CreateTask(
//                             onAddTask: (Task newTask) {
//                               setState(() {
//                                 listDefault.add(
//                                   newTask,
//                                 ); // sử dụng listDefault member
//                               });
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         Container(
//                           width: 250,
//                           padding: EdgeInsets.symmetric(vertical: 16),
//                           decoration: BoxDecoration(
//                             color: Color(0xFF4A3780),
//                             borderRadius: BorderRadius.circular(50),
//                           ),
//                           child: Text(
//                             "Add New Task",
//                             textAlign: TextAlign.center,
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           // List of tasks
//           Positioned(
//             top: 100,
//             left: 20,
//             right: 20,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 color: Colors.white,
//                 height: 210,
//                 child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: listDefault.length,
//                   itemBuilder: (context, index) {
//                     return !listDefault[index].isCompleted
//                         ? Column(
//                             children: [
//                               TaskItem(
//                                 task: listDefault[index],
//                                 onChecked: (value) =>
//                                     checkBoxChanged(value, index),
//                                 onTap: (task) {
//                                   Navigator.push(
//                                     context, // phải dùng context của TodoPage
//                                     MaterialPageRoute(
//                                       builder: (_) => CreateTask(
//                                         onAddTask: (updatedTask) {
//                                           setState(() {
//                                             listDefault[index] =
//                                                 updatedTask; // cập nhật lại listDefault
//                                           });
//                                         },
//                                         taskToEdit: task,
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                               if (index != listDefault.length - 1)
//                                 Divider(color: Colors.grey[300], height: 1),
//                             ],
//                           )
//                         : SizedBox.shrink(); // không hiển thị
//                   },
//                 ),
//               ),
//             ),
//           ),
//           // Completed title
//           Positioned(
//             top: 320,
//             left: 20,
//             right: 20,
//             child: Text(
//               "Completed",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//           ),
//           // List of completed
//           Positioned(
//             top: 350,
//             left: 20,
//             right: 20,
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(16),
//               child: Container(
//                 color: Colors.white,
//                 height: 210,
//                 child: ListView.builder(
//                   padding: EdgeInsets.zero,
//                   itemCount: listDefault.length,
//                   itemBuilder: (context, index) {
//                     return listDefault[index].isCompleted
//                         ? Column(
//                             children: [
//                               TaskItem(
//                                 onTap: (task) => {},
//                                 task: listDefault[index],
//                                 onChecked: (value) =>
//                                     checkBoxChanged(value, index),
//                               ),
//                               if (index != listDefault.length - 1)
//                                 Divider(color: Colors.grey[300], height: 1),
//                             ],
//                           )
//                         : SizedBox.shrink(); // không hiển thị
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
