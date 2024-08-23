import 'package:final_project/models/quote_model.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/controllers/quote_controller.dart';
import 'package:final_project/models/quote_item.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double widthDevice = MediaQuery.of(context).size.width;
    double heightDevice = MediaQuery.of(context).size.height;
    double paddingTop = MediaQuery.of(context).padding.top;
    double bodyHeight = heightDevice - paddingTop;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        title: Text(
          'Favorite Kutipan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: widthDevice * 0.05,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FBFirestoreService.fbFirestoreService.fetchAllQuotesByUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching data'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text(
              'Belum ada quote favorite',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ));
          }
          List<Map<String, dynamic>> allQuotes = snapshot.data!;

          // Flatten the list of favorite quotes
          List<Map<String, dynamic>> favoriteQuotes = [];
          for (var quoteMap in allQuotes) {
            String idQuotes = quoteMap['id'];
            List<dynamic> quotes = quoteMap['quotes'];
            for (var quote in quotes) {
              if (quote['isFavorite'] == true) {
                favoriteQuotes.add({
                  'idQuotes': idQuotes,
                  'quote': quote,
                  'quoteIndex': quotes.indexOf(quote) // Simpan indeks kutipan
                });
              }
            }
          }

          if (favoriteQuotes.isEmpty) {
            return Center(
                child: Text(
              'Belum ada quote favorite',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ));
          }

          return ListView.builder(
            itemCount: favoriteQuotes.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> favoriteQuote = favoriteQuotes[index];
              String idQuotes = favoriteQuote['idQuotes'];
              Map<String, dynamic> quote = favoriteQuote['quote'];
              int quoteIndex =
                  favoriteQuote['quoteIndex']; // Dapatkan indeks kutipan

              return Padding(
                padding:
                    EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red.shade100,
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 20, 20, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quote['quote'],
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.05,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await FBFirestoreService.fbFirestoreService
                                    .isFavoriteStatusQuote(
                                  idQuotes: idQuotes, // Menggunakan ID dokumen
                                  quoteIndex:
                                      quoteIndex, // Menggunakan indeks kutipan
                                  newFavoriteStatus: !quote['isFavorite'],
                                );
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: quote['isFavorite']
                                    ? Colors.red
                                    : Colors.black54,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Share.share(quote['quote']);
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
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// StreamBuilder<List<QuoteModel>>(
//         stream: FBFirestoreService.fbFirestoreService.fetchFavoriteQuotes(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error fetching data'));
//           }
//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text(
//                 'No favorite quotes found',
//                 style: TextStyle(color: Colors.white, fontSize: 18),
//               ),
//             );
//           }

//           List<QuoteModel> quotes = snapshot.data!;
//           print(quotes);
//           return ListView.builder(
//             itemCount: quotes.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 color: Colors.black,
//                 // color: Colors.red.shade100,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: quotes[index]
//                       .quotes
//                       .where((item) => item.isFavorite)
//                       .map((item) => Container(
//                         color: Colors.white,
//                         child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   item.quote,
//                                   style: GoogleFonts.playfairDisplay(
//                                     color: Colors.black,
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.normal,
//                                   ),
//                                 ),
//                                 SizedBox(height: 5),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.end,
//                                   children: [
//                                     IconButton(
//                                       onPressed: () {
//                                         // Add functionality to share quote
//                                       },
//                                       icon: Icon(
//                                         Icons.favorite,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                     IconButton(
//                                       onPressed: () {
//                                         // Add functionality to share quote
//                                       },
//                                       icon: Icon(
//                                         Icons.share,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),

//                               ],
//                             ),
//                       ))
//                       .toList(),
//                 ),
//               );
//             },
//           );
//         },
//       ),
