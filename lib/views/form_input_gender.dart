import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/controllers/user_controller.dart';
import 'package:final_project/helpers/user_navigator_helper.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/views/components/gender_tile.dart';
import 'package:final_project/views/utility/gender_lists.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FormInputGender extends StatelessWidget {
  FormInputGender({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightDevice = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: heightDevice * 0.2),
            Text(
              key: Key('txtGender'),
              "Sekarang pilih jenis kelaminmu agar kami bisa memberikan pengalaman yang lebih personal",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
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
                            itemCount: genders.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  userController.setGender(genders[index]);
                                  formKey.currentState!.validate();
                                },
                                child: GenderTile(
                                  name: genders[index],
                                  isSelected:
                                      userController.gender == genders[index],
                                ),
                              );
                            },
                          ),
                        ),
                        FormField<String>(
                          validator: (value) {
                            if (userController.gender == null) {
                              return 'Jenis kelamin harus diisi';
                            }
                            if (!genders.contains(userController.gender)) {
                              return 'Jenis kelamin tidak valid';
                            }
                            return null;
                          },
                          builder: (state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (state.hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 6.0),
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
                        Flexible(
                          fit: FlexFit.loose,
                          child: Visibility(
                            visible: userController.gender != null,
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                key: const Key('btnNextGender'),
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
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Koneksi internet bermasalah!'),
                                        ),
                                      );
                                      return;
                                    }
                                    await FBFirestoreService.fbFirestoreService
                                        .updateUserField(
                                            fieldName: 'gender',
                                            newValue: userController.gender)
                                        .then((value) {
                                      UserNavigatorHelper
                                          .navigateToUserDataPage(context);
                                    });
                                  }
                                },
                              ),
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
