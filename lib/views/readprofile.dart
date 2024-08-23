// import 'package:flutter/material.dart';
// import 'package:final_project/routes/routes.dart';

// class readProfile extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text('My profile', style: TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit, color: Colors.white),
//             onPressed: () =>
//                 Navigator.of(context).pushNamed(Routes.editProfile),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             CircleAvatar(
//               radius: 50,
//               backgroundImage: AssetImage('assets/profile_image.png'),
//             ),
//             SizedBox(height: 16),
//             Text(

//               style: TextStyle(fontSize: 24, color: Colors.white),
//             ),
//             SizedBox(height: 16),
//             // ProfileItem(title: 'Gender', ),
//             // ProfileItem(title: 'Age', value: age),
//             // ProfileItem(title: 'Activity', value: activity),
//             // Spacer(),
//             ListTile(
//               title: Text('Change password',
//                   style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle change password
//               },
//             ),
//             ListTile(
//               title: Text('Log out', style: TextStyle(color: Colors.white)),
//               onTap: () {
//                 // Handle log out
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ProfileItem extends StatelessWidget {
//   final String title;
//   final String value;

//   ProfileItem({required this.title, required this.value});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             title,
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//           Text(
//             value,
//             style: TextStyle(color: Colors.white, fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }
// }
