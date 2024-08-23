import 'package:flutter/cupertino.dart';

class UserController with ChangeNotifier {
  String? gender;
  String? activity;

  void setGender(String newGender) {
    gender = newGender;
    notifyListeners();
  }

  void setActivity(String newActivity) {
    activity = newActivity;
    notifyListeners();
  }

  void isSelectedGender({required String value}) {
    gender = value;
    notifyListeners();
  }

  void isSelectedActivity({required String value}) {
    activity = value;
    notifyListeners();
  }

  void initializeGender(String? initialGender) {
    gender = initialGender;
  }

  void initializeActivity(String? initialActivity) {
    activity = initialActivity;
  }
}
