import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/helpers/user_navigator_helper.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FormInputAge extends StatelessWidget {
  FormInputAge({super.key});
  GlobalKey<FormState> formKey = GlobalKey<
      FormState>(); // Membuat kunci global untuk FormState, digunakan untuk mengelola keadaan form.

  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthDevice = MediaQuery.of(context).size.width;
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
              key: Key('txtAge'),
              "Bagus, Sekarang berapa umurmu? Ini membantu kami untuk lebih memahami kebutuhanmu.",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                  textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: MediaQuery.of(context).size.width * 0.06,
              )),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: TextFormField(
                key: const Key('fieldAge'),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.red.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Masukkan umur',
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
                controller: ageController,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Umur harus diisi';
                  }
                  final n = num.tryParse(value);
                  if (n == null) {
                    return 'Umur harus berupa angka';
                  }
                  if (n < 0 || n > 120) {
                    return 'Umur harus diantara 0 dan 120 tahun';
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
                    await FBFirestoreService.fbFirestoreService
                        .updateUserField(
                            fieldName: 'age', newValue: ageController.text)
                        .then((value) {
                      UserNavigatorHelper.navigateToUserDataPage(context);
                    });
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              key: const Key('btnNextAge'),
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
                  // Check internet connectivity
                  if (!await ConnectivityService.isConnected()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Koneksi internet bermasalah!'),
                      ),
                    );
                    return;
                  }
                  await FBFirestoreService.fbFirestoreService
                      .updateUserField(
                          fieldName: 'age', newValue: ageController.text)
                      .then((value) {
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
