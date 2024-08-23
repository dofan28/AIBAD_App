import 'package:final_project/models/user_model.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double heightDevice = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;
    double bodyHeight = heightDevice - paddingTop;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white,
            size: MediaQuery.of(context).size.width * 0.05),
        backgroundColor: Colors.black,
        title: Text(
          key: Key('txtSetting'),
          'Pengaturan',
          style: GoogleFonts.plusJakartaSans(
            textStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
        ),
        leading: IconButton(
          key: Key('btnBack'),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white, size: 20),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.06,
              vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  key: Key('txtPreferensiPengguna'),
                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Text(
                    'Preferensi Penggguna',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        key: Key('btnEditName'),
                        leading: const Icon(
                          FontAwesomeIcons.user,
                          size: 25,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Nama",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.editName);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      ListTile(
                        key: Key('btnEditGender'),
                        leading: const Icon(
                          FontAwesomeIcons.venusMars,
                          size: 25,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Jenis Kelamin",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.editGender);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      ListTile(
                        key: Key('btnEditAge'),
                        leading: const Icon(
                          FontAwesomeIcons.child,
                          size: 30,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Umur",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.editAge);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      ListTile(
                        key: Key('btnEditActivity'),
                        leading: const Icon(
                          FontAwesomeIcons.tasks,
                          size: 25,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Aktivitas",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.editActivity);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.03,
                ),
                Padding(
                  key: Key('txtKutipanSaya'),
                  padding: EdgeInsets.only(left: 8.0, bottom: 8),
                  child: Text(
                    'Kutipan Saya',
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                      ),
                    ),
                  ),
                ),
                Container(
                  // height: 500,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        key: Key('btnFavorite'),
                        leading: const Icon(
                          Icons.favorite_sharp,
                          size: 30,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Kutipan Favorit",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.favorite);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      ListTile(
                        key: Key('btnLastQuote'),
                        leading: const Icon(
                          Icons.format_quote,
                          size: 30,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Kutipan Terakhir",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.resultQuotes);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      const Divider(
                        color: Colors.black,
                        thickness: 1,
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.notification_add,
                          size: 30,
                          color: Colors.white,
                        ),
                        title: Text(
                          key: Key('btnNotification'),
                          "Atur Notifikasi",
                          style: GoogleFonts.plusJakartaSans(
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed(Routes.notification);
                        },
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
