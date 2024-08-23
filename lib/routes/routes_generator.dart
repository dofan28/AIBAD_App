import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/services/user_preferences_service.dart';
import 'package:final_project/views/edit_activity.dart';
import 'package:final_project/views/edit_age.dart';
import 'package:final_project/views/edit_gender.dart';
import 'package:final_project/views/edit_name.dart';
import 'package:final_project/views/favorite.dart';
import 'package:final_project/views/form_input_activity.dart';
import 'package:final_project/views/form_input_age.dart';
import 'package:final_project/views/form_input_gender.dart';
import 'package:final_project/views/form_input_name.dart';
import 'package:final_project/views/homepage.dart';
import 'package:final_project/views/intro.dart';
import 'package:final_project/views/not-found.dart';
import 'package:final_project/views/notification.dart';
import 'package:final_project/views/setting.dart';
import 'package:final_project/views/result_quotes.dart';
import 'package:final_project/views/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.intro:
        return _buildIntroRoute();
      case Routes.inputName:
        return PageTransition(
          child: FormInputName(),
          childCurrent: FormInputName(),
          duration: const Duration(milliseconds: 600),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.inputGender:
        return PageTransition(
          child: FormInputGender(),
          childCurrent: FormInputGender(),
          duration: const Duration(milliseconds: 600),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.inputAge:
        return PageTransition(
          child: FormInputAge(),
          childCurrent: FormInputAge(),
          duration: const Duration(milliseconds: 600),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.inputActivity:
        return PageTransition(
          child: FormInputActivity(),
          childCurrent: FormInputActivity(),
          duration: const Duration(milliseconds: 600),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.resultQuotes:
        return PageTransition(
          child: ResultQuotes(),
          childCurrent: ResultQuotes(),
          duration: const Duration(milliseconds: 600),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.home:
        return PageTransition(
          child: HomePage(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      case Routes.setting:
        return PageTransition(
          child: const Setting(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 500),
          curve: Curves.linear,
        );
      case Routes.editName:
        return PageTransition(
          child: EditName(),
          childCurrent: EditName(),
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.editGender:
        return PageTransition(
          child: EditGender(),
          childCurrent: EditGender(),
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.editAge:
        return PageTransition(
          child: EditAge(),
          childCurrent: EditAge(),
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.editActivity:
        return PageTransition(
          child: EditActivity(),
          childCurrent: EditActivity(),
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.favorite:
        return PageTransition(
          child: Favorite(),
          childCurrent: Favorite(),
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.rightToLeftJoined,
        );
      case Routes.notification:
        return PageTransition(
          child: NotificationPage(),
          childCurrent: NotificationPage(),
          duration: const Duration(milliseconds: 300),
          type: PageTransitionType.rightToLeftJoined,
        );
      default:
        return PageTransition(
          child: NotFound(),
          type: PageTransitionType.fade,
          duration: const Duration(milliseconds: 300),
          curve: Curves.linear,
        );
    }
  }

  static MaterialPageRoute _buildIntroRoute() {
    return MaterialPageRoute(builder: (_) {
      if (UserPreferences.getUserId() != null) {
        return FutureBuilder<Widget>(
          future: _checkUserStatus(),
          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SplashScreen();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data ?? Intro();
            }
          },
        );
      } else {
        return Intro();
      }
    });
  }

  static Future<Widget> _checkUserStatus() async {
    DocumentSnapshot userSnapshot =
        await FBFirestoreService.fbFirestoreService.getUser();

    Stream<List<Map<String, dynamic>>> getAllQuotesStream =
        await FBFirestoreService.fbFirestoreService.fetchAllQuotesByUser();

    List<Map<String, dynamic>> allQuotes = await getAllQuotesStream.first;

    if (userSnapshot.exists) {
      dynamic name = (userSnapshot.data() as Map<String, dynamic>)['name'];
      dynamic gender = (userSnapshot.data() as Map<String, dynamic>)['gender'];
      dynamic age = (userSnapshot.data() as Map<String, dynamic>)['age'];
      dynamic activity =
          (userSnapshot.data() as Map<String, dynamic>)['activity'];

      if (name == null) {
        return FormInputName();
      } else if (gender == null) {
        return FormInputGender();
      } else if (age == null) {
        return FormInputAge();
      } else if (activity == null) {
        return FormInputActivity();
      } else if (name != null &&
          gender != null &&
          age != null &&
          activity != null) {
        if (allQuotes.isNotEmpty) {
          return ResultQuotes();
        } else {
          return HomePage();
        }
      } else {
        return const NotFound();
      }
    } else {
      return const NotFound();
    }
  }
}
