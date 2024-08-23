import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/views/components/gender_tile.dart';
import 'package:final_project/views/utility/gender_lists.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditGender extends StatelessWidget {
  EditGender({super.key});

  final ValueNotifier<String?> selectedGender = ValueNotifier<String?>(null);
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Identitas Gender',
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 20,
          ),
        ),
      ),
      body: FutureBuilder(
        future: FBFirestoreService.fbFirestoreService.getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Gagal mengambil data'),
            );
          }

          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(
              child: Text(
                'Data pengguna tidak ditemukan',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          var user = snapshot.data?.data();
          selectedGender.value = user?['gender'] ?? '';

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    key: Key('txtEditGender'),
                    "Jenis Kelamin Anda digunakan untuk mempersonalisasi konten Anda.",
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Flexible(
                    child: ValueListenableBuilder<String?>(
                      valueListenable: selectedGender,
                      builder: (context, gender, child) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: genders.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                selectedGender.value = genders[index];
                                formKey.currentState!.validate();
                              },
                              child: GenderTile(
                                name: genders[index],
                                isSelected:
                                    selectedGender.value == genders[index],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  FormField<String>(
                    validator: (value) {
                      if (selectedGender.value == null) {
                        return 'Jenis kelamin harus diisi';
                      }
                      if (selectedGender.value != 'Laki-Laki' &&
                          selectedGender.value != 'Perempuan') {
                        return 'Jenis kelamin tidak valid';
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (state.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
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
                    child: ValueListenableBuilder<String?>(
                      valueListenable: selectedGender,
                      builder: (context, gender, child) {
                        return Visibility(
                          visible: gender != user?['gender'],
                          child: ElevatedButton(
                            key: Key('btnSaveChangesGender'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Simpan Perubahan',
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
                                      content:
                                          Text('Koneksi internet bermasalah!'),
                                    ),
                                  );
                                  return;
                                }
                                await FBFirestoreService.fbFirestoreService
                                    .updateUserField(
                                  fieldName: 'gender',
                                  newValue: selectedGender.value,
                                )
                                    .then((value) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      key: Key('snackBarEditGenderSuccess'),
                                      content:
                                          Text('Perubahan berhasil disimpan'),
                                    ),
                                  );
                                });
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
