import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAge extends StatelessWidget {
  EditAge({super.key});

  final formKey = GlobalKey<FormState>();
  final TextEditingController ageController = TextEditingController();
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(true);
  final ValueNotifier<String?> errorMessage = ValueNotifier<String?>(null);

  @override
  Widget build(BuildContext context) {
    fetchUserData();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
          size: MediaQuery.of(context).size.width * 0.05,
        ),
        backgroundColor: Colors.black,
        title: Text(
          'Umur',
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
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
        ),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (context, loading, child) {
          if (loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ValueListenableBuilder<String?>(
            valueListenable: errorMessage,
            builder: (context, error, child) {
              if (error != null) {
                return Center(
                  child: Text(
                    'Error: $error',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      key: const Key('txtEditAge'),
                      "Umur Anda digunakan untuk mempersonalisasi konten Anda.",
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Form(
                      key: formKey,
                      child: TextFormField(
                        key: Key('fieldEditAge'),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.red.shade100,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'Umur',
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
                        textInputAction: TextInputAction.go,
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
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      key: const Key('btnSaveChangesAge'),
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
                          textStyle: const TextStyle(
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
                              const SnackBar(
                                content: Text('Koneksi internet bermasalah!'),
                              ),
                            );
                            return;
                          }
                          await FBFirestoreService.fbFirestoreService
                              .updateUserField(
                            fieldName: 'age',
                            newValue: ageController.text,
                          )
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                key: Key('snackBarEditAgeSuccess'),
                                content: Text('Perubahan berhasil disimpan'),
                              ),
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> fetchUserData() async {
    try {
      var user = await FBFirestoreService.fbFirestoreService.getUser();
      if (user.data() != null) {
        ageController.text = user.data()?['age'] ?? 'NULL';
      } else {
        errorMessage.value = 'Data pengguna tidak ditemukan';
      }
    } catch (error) {
      errorMessage.value = 'Error: $error';
    } finally {
      isLoading.value = false;
    }
  }
}
