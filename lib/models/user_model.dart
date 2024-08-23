import 'dart:developer';

class UserModel {
  String? name;
  String? gender;
  String? age;
  String? activity;
  List prefs = [];

  UserModel({this.name, this.gender, this.age, this.activity, List? prefs});

  UserModel.init() {
    log("Empty user initialized...");
  }

  factory UserModel.fromMap({required Map user}) {
    return UserModel(
      name: user['name'],
      gender: user['gender'],
      age: user['age'],
      activity: user['activity'],
      prefs: user['prefs'],
    );
  }
}
