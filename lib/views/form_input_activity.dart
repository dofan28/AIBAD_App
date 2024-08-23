import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/controllers/user_controller.dart';
import 'package:final_project/helpers/user_navigator_helper.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/views/components/activity_tile.dart';
import 'package:final_project/views/model/activity_model.dart';
import 'package:final_project/views/utility/activity.lists.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FormInputActivity extends StatelessWidget {
  FormInputActivity({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Text(
              key: Key('txtActivity'),
              "Terakhir, pilih kesibukanmu? Ini akan membantu kami dalam memberikan rekomendasi yang sesuai untukmu.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.06,
              )),
            ),
            Form(
              key: formKey,
              child: Flexible(
                fit: FlexFit.loose,
                child: Consumer<UserController>(
                  builder: (context, userController, child) {
                    return Column(
                      children: [
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              Activity activity = activities[index];
                              return GestureDetector(
                                key: Key('activityTile$index'),
                                onTap: () {
                                  userController.setActivity(activity.name);
                                  formKey.currentState!.validate();
                                },
                                child: ActivityTile(
                                  name: activity.name,
                                  icon: activity.icon,
                                  isSelected:
                                      userController.activity == activity.name,
                                ),
                              );
                            },
                          ),
                        ),
                        FormField<String>(
                          validator: (value) {
                            if (userController.activity == null) {
                              return 'Aktivitas harus diisi';
                            }
                            if (!activities
                                .map((a) => a.name)
                                .contains(userController.activity)) {
                              return 'Aktivitas tidak valid';
                            }
                            return null;
                          },
                          builder: (state) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: Text(
                                      textAlign: TextAlign.start,
                                      state.errorText ?? '',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                        Visibility(
                          visible: userController.activity != null,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              key: const Key('btnNextActivity'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Berikutnya',
                                style: GoogleFonts.plusJakartaSans(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (!await ConnectivityService
                                      .isConnected()) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Koneksi internet bermasalah!'),
                                      ),
                                    );
                                    return;
                                  }
                                  await FBFirestoreService.fbFirestoreService
                                      .updateUserField(
                                          fieldName: 'activity',
                                          newValue: userController.activity!)
                                      .then(
                                    (value) {
                                      UserNavigatorHelper
                                          .navigateToUserDataPage(context);
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
