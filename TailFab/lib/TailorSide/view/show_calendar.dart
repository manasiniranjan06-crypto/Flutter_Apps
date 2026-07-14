// import 'package:table_calendar/table_calendar.dart';
// import 'package:flutter/material.dart';

// void _showCalendar(BuildContext context) {
//   DateTime today = DateTime.now();

//   showDialog(
//     context: context,
//     builder: (context) => Dialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: StatefulBuilder(
//         builder: (context, setState) {
//           return Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(20),
//               gradient: const LinearGradient(
//                 colors: [Color(0xFF8075FF), Color(0xFF5F4BDB)],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Text(
//                   '📅 Select Delivery Date',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: TableCalendar(
//                     focusedDay: today,
//                     firstDay: DateTime.utc(2020, 1, 1),
//                     lastDay: DateTime.utc(2030, 12, 31),
//                     calendarStyle: const CalendarStyle(
//                       todayDecoration: BoxDecoration(
//                         color: Color(0xFF8075FF),
//                         shape: BoxShape.circle,
//                       ),
//                       selectedDecoration: BoxDecoration(
//                         color: Colors.deepPurple,
//                         shape: BoxShape.circle,
//                       ),
//                     ),
//                     selectedDayPredicate: (day) => isSameDay(day, today),
//                     onDaySelected: (selectedDay, focusedDay) {
//                       setState(() {
//                         today = selectedDay;
//                       });
//                     },
//                   ),
//                 ),
//                 const SizedBox(height: 15),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color(0xFF8075FF),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: Text(
//                           'Selected Date: ${today.day}-${today.month}-${today.year}',
//                         ),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                   },
//                   child: const Text('Confirm Date'),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     ),
//   );
// }