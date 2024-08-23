import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:flutter/material.dart';

class UserNavigatorHelper {
  static void navigateToUserDataPage(BuildContext context) async {
    DocumentSnapshot userSnapshot =
        await FBFirestoreService.fbFirestoreService.getUser();
    if (userSnapshot.exists) {
      dynamic name = (userSnapshot.data() as Map<String, dynamic>)['name'];
      dynamic gender = (userSnapshot.data() as Map<String, dynamic>)['gender'];
      dynamic age = (userSnapshot.data() as Map<String, dynamic>)['age'];
      dynamic activity =
          (userSnapshot.data() as Map<String, dynamic>)['activity'];

      if (name == null) {
        Navigator.of(context).pushReplacementNamed(
          Routes.inputName,
        );
      } else if (gender == null) {
        Navigator.of(context).pushReplacementNamed(
          Routes.inputGender,
        );
      } else if (age == null) {
        Navigator.of(context).pushReplacementNamed(
          Routes.inputAge,
        );
      } else if (activity == null) {
        Navigator.of(context).pushReplacementNamed(
          Routes.inputActivity,
        );
      } else if (name != null && gender != null && age != null) {
        Navigator.of(context).pushReplacementNamed(
          Routes.home,
        );
      } else if (name != null && gender != null && age != null) {
        Navigator.of(context).pushReplacementNamed(
          Routes.home,
        );
      }
    }
  }
}
