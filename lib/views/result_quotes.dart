import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';

class ResultQuotes extends StatelessWidget {
  ResultQuotes({Key? key}) : super(key: key);

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthDevice = size.width;

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushNamed(Routes.home);
        return false; // Mencegah default back action
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.of(context).pushNamed(Routes.home),
          backgroundColor: Colors.red,
          label: const Text(
            key: Key('btnAddQuote'),
            'Masukkan Perasaan',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          icon: const Icon(Icons.add_circle, color: Colors.white),
        ),
        key: scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          automaticallyImplyLeading: false,
          title: Text(
            'AIBAD',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: widthDevice * 0.05,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                key: const Key('btnSetting'),
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context).pushNamed(Routes.setting),
            ),
          ],
          centerTitle: false,
          elevation: 2,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [Colors.black87, Colors.red.shade200],
            ),
          ),
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FBFirestoreService.fbFirestoreService.fetchLastQuote(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Gagal mengambil data!'));
              }
              if (!snapshot.hasData || !snapshot.data!.exists) {
                return Center(
                  child: Text(
                    'Kutipan tidak ditemukan. Coba lagi!',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                );
              }
              List quotes = snapshot.data?.data()?['quotes'] ?? [];
              String idQuotes = snapshot.data!.id;
              return Padding(
                padding: EdgeInsets.fromLTRB(15, 10, 15, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      key: Key('txtResultQuotes'),
                      'Hasil Kutipan:',
                      style: GoogleFonts.firaSans(
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: widthDevice * 0.05,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: ListView.builder(
                        key: const Key('listViewQuotes'),
                        itemCount: quotes.length,
                        itemBuilder: (context, index) {
                          return Container(
                            key: Key('containerQuote$index'),
                            margin: EdgeInsets.only(bottom: 15),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.red.shade100,
                            ),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  20, 20, 20, 10),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    key: Key('txtQuote$index'),
                                    quotes[index]['quote'],
                                    style: GoogleFonts.lato(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.05,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        key: const Key('btnFavoriteQuote'),
                                        onPressed: () async {
                                          await FBFirestoreService
                                              .fbFirestoreService
                                              .isFavoriteStatusQuote(
                                            idQuotes: idQuotes,
                                            quoteIndex: index,
                                            newFavoriteStatus: !quotes[index]
                                                ['isFavorite'],
                                          );
                                        },
                                        icon: Icon(
                                          Icons.favorite,
                                          color: quotes[index]['isFavorite']
                                              ? Colors.red
                                              : Colors.black54,
                                        ),
                                      ),
                                      IconButton(
                                        key: const Key('btnShareQuote'),
                                        onPressed: () {
                                          Share.share(quotes[index]['quote']);
                                        },
                                        icon: const Icon(
                                          Icons.share_sharp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
