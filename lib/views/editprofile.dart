import 'package:final_project/controllers/user_controller.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileEdit extends StatelessWidget {
  ProfileEdit({super.key});

  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text('Edit profile', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        color: Colors.black,
        child: FutureBuilder(
          future: FBFirestoreService.fbFirestoreService.getUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)));
            }

            if (!snapshot.hasData || snapshot.data?.data() == null) {
              return Center(
                  child: Text('User data not found',
                      style: TextStyle(color: Colors.white)));
            }

            var user = snapshot.data?.data();

            nameController.text = user?['name'] ?? 'NULL';
            String gender = user?['gender'] ?? '';
            ageController.text = user?['age']?.toString() ?? 'NULL';
            String activity = user?['activity'] ?? '';

            // Set default value if null
            if (userController.gender == null) {
              userController.isSelectedGender(value: gender);
            }
            if (userController.activity == null) {
              userController.isSelectedActivity(value: activity);
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Consumer<UserController>(
                  builder: (context, userController, child) {
                return Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      TextFormField(
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: 'Nama',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == 'NULL') {
                            return 'Masukkan nama Anda';
                          }
                          if (value.length > 18) {
                            return 'Nama tidak boleh lebih dari 18 karakter';
                          }
                          if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                            return 'Masukkan huruf saja';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: userController.gender,
                        decoration: InputDecoration(
                          labelText: 'Jenis Kelamin',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        items: <String>['Laki-Laki', 'Perempuan']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          userController.isSelectedGender(value: value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih jenis kelamin';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: ageController,
                        decoration: InputDecoration(
                          labelText: 'Umur',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          hintStyle: TextStyle(color: Colors.white54),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value == 'NULL') {
                            return 'Masukkan umur Anda';
                          }
                          final n = num.tryParse(value);
                          if (n == null) {
                            return '"$value" bukan angka yang valid';
                          }
                          if (n < 0 || n > 120) {
                            return 'Masukkan umur antara 0 dan 120';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: userController.activity,
                        decoration: InputDecoration(
                          labelText: 'Kesibukan',
                          labelStyle:
                              TextStyle(color: Colors.white, fontSize: 18),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white54),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        iconEnabledColor: Colors.white,
                        style: TextStyle(color: Colors.white),
                        items: <String>[
                          'Mahasiswa',
                          'Pekerja',
                          'Pensiunan',
                          'Ibu Rumah Tangga',
                          'Pekerja Lepas',
                          'Pengusaha',
                          'Pengangguran'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(color: Colors.white)),
                          );
                        }).toList(),
                        onChanged: (value) {
                          userController.isSelectedActivity(value: value!);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Pilih kesibukan Anda';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            print('name : ${nameController.text}');
                            print('gender : ${userController.gender}');
                            print('age : ${ageController.text}');
                            print('activity : ${userController.activity}');
                            UserModel userModel = UserModel(
                              name: nameController.text,
                              gender: userController.gender!,
                              age: ageController.text, // Use String if needed
                              activity: userController.activity!,
                            );
                            await FBFirestoreService.fbFirestoreService
                                .updateUser(user: userModel)
                                .then((_) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Profil diperbarui'),
                                ),
                              );
                            });
                          }
                        },
                        child: Text(
                          'Simpan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}
