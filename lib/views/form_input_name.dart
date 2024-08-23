import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/helpers/user_navigator_helper.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/services/user_preferences_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInputName extends StatelessWidget {
  FormInputName({super.key});
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double heightDevice = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;
    double bodyHeight = heightDevice - paddingTop;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              key: Key('txtName'),
              "Mari mulai dengan langkah yang pertama, Siapa nama panggilanmu?",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: MediaQuery.of(context).size.width * 0.06,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: formKey,
              child: TextFormField(
                key: const Key('fieldName'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Masukkan nama',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                controller: nameController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama harus diisi';
                  }
                  if (value.length > 18) {
                    return 'Nama maksimal 18 karakter';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Nama hanya boleh huruf';
                  }
                  return null;
                },
                onFieldSubmitted: (value) async {
                  if (formKey.currentState!.validate()) {
                    if (!await ConnectivityService.isConnected()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Koneksi internet bermasalah!'),
                        ),
                      );
                      return;
                    }
                    UserModel userModel = UserModel(
                      name: nameController.text,
                      prefs: [],
                    );
                    await FBFirestoreService.fbFirestoreService
                        .addUser(user: userModel)
                        .then((userId) async {
                      await UserPreferences.saveUserId(userId as String);
                      UserNavigatorHelper.navigateToUserDataPage(context);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('btnNextName'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Berikutnya',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  if (!await ConnectivityService.isConnected()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Koneksi internet bermasalah!'),
                      ),
                    );
                    return;
                  }
                  UserModel userModel = UserModel(
                    name: nameController.text,
                    prefs: [],
                  );
                  await FBFirestoreService.fbFirestoreService
                      .addUser(user: userModel)
                      .then((userId) async {
                    await UserPreferences.saveUserId(userId as String);
                    UserNavigatorHelper.navigateToUserDataPage(context);
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
