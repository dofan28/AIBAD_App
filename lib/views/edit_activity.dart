import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/views/components/activity_tile.dart';
import 'package:final_project/views/model/activity_model.dart';
import 'package:final_project/views/utility/activity.lists.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditActivity extends StatelessWidget {
  EditActivity({super.key});
  final ValueNotifier<String?> selectedActivity = ValueNotifier<String?>(null);
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
          'Aktivitas',
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
          selectedActivity.value = user?['activity'] ?? '';

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
                    key: Key('txtEditActivity'),
                    "Aktivitas Anda digunakan untuk mempersonalisasi konten Anda.",
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
                    fit: FlexFit.tight,
                    child: ValueListenableBuilder<String?>(
                      valueListenable: selectedActivity,
                      builder: (context, activity, child) {
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: activities.length,
                          itemBuilder: (context, index) {
                            Activity activity = activities[index];
                            return GestureDetector(
                              onTap: () {
                                selectedActivity.value = activity.name;
                                formKey.currentState!.validate();
                              },
                              child: ActivityTile(
                                name: activity.name,
                                icon: activity.icon,
                                isSelected:
                                    selectedActivity.value == activity.name,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  FormField<String>(
                    validator: (value) {
                      if (selectedActivity.value == null) {
                        return 'Aktivitas harus diisi';
                      }
                      if (!activities
                          .map((a) => a.name)
                          .contains(selectedActivity.value)) {
                        return 'Aktivitas tidak valid';
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
                  ValueListenableBuilder<String?>(
                    valueListenable: selectedActivity,
                    builder: (context, activity, child) {
                      return Visibility(
                        visible: activity != user?['activity'],
                        child: ElevatedButton(
                          key: const Key('btnSaveChangesActivity'),
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
                                fieldName: 'activity',
                                newValue: selectedActivity.value,
                              )
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    key: Key('snackBarEditActivitySuccess'),
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
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
