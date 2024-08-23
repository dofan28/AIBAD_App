import 'package:final_project/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Intro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [Colors.red.shade200, Colors.black]),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Temukan Kutipan \nDari Perasaaanmu!',
              textAlign: TextAlign.start,
              // style: TextStyle(
              //   color: Colors.white,
              //   fontSize: MediaQuery.of(context).size.width * 0.07,
              //   fontWeight: FontWeight.bold,
              // ),
              style: GoogleFonts.outfit(
                textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: MediaQuery.of(context).size.width * 0.09,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ceritakan perasaanmu dan dapatkan kutipan yang tepat mendukung perasaanmu',
              style: GoogleFonts.plusJakartaSans(
                textStyle: TextStyle(
                  color: Colors.white70,
                  fontSize: MediaQuery.of(context).size.width * 0.04,
                ),
              ),
              textAlign: TextAlign.start,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
              child: ElevatedButton(
                key: const Key('btnStart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Mulai Sekarang',
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed(Routes.inputName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
