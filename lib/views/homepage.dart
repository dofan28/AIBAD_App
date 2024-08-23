import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/controllers/connectivity_check.dart';
import 'package:final_project/models/quote_item.dart';
import 'package:final_project/models/quote_model.dart';
import 'package:final_project/routes/routes.dart';
import 'package:final_project/services/fb_firestore_service.dart';
import 'package:final_project/services/openai_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_langdetect/flutter_langdetect.dart' as langdetect;

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController feelingInputController = TextEditingController();
  bool _isLoading = false;
  int _currentCharCount = 0;
  String? _userName; // Tambahkan variabel untuk menyimpan nama pengguna

  @override
  void initState() {
    super.initState();
    feelingInputController.addListener(_updateCharCount);
    _loadUserName(); // Panggil method untuk memuat nama pengguna
  }

  Future<void> _loadUserName() async {
    DocumentSnapshot user =
        await FBFirestoreService.fbFirestoreService.getUser();
    setState(() {
      _userName = user['name'];
    });
  }

  @override
  void dispose() {
    feelingInputController.removeListener(_updateCharCount);
    feelingInputController.dispose();
    super.dispose();
  }

  void _updateCharCount() {
    setState(() {
      _currentCharCount = feelingInputController.text.length;
    });
  }

  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'AIBAD',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: MediaQuery.of(context).size.width * 0.05,
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            key: Key('btnSetting'),
            icon: Icon(
              Icons.person,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pushNamed(Routes.setting),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_userName != null)
                Text(
                  key: Key('greetingText'),
                  "Halo $_userName, \nMari bagikan perasaanmu hari ini",
                  style: GoogleFonts.plusJakartaSans(
                      textStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: MediaQuery.of(context).size.width * 0.05,
                  )),
                )
              else
                CircularProgressIndicator(),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    TextFormField(
                      key: const Key('fieldFeeling'),
                      maxLines: 10,
                      controller: feelingInputController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.red.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Masukkan perasaanmu disini...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          textStyle: TextStyle(
                            color: Colors.grey.shade600,
                          ),
                        ),
                        counterText: '$_currentCharCount/500',
                        counterStyle: TextStyle(color: Colors.white),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        errorMaxLines: 4,
                      ),
                      maxLength: 500,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukkan perasaanmu hari ini';
                        }
                        if (value.length > 500) {
                          return 'Masukkan perasaanmu maksimal 500 karakter';
                        }
                        final wordsPattern = RegExp(r'\w+');
                        if (wordsPattern.allMatches(value).length < 2) {
                          return 'Masukkan perasaanmu lebih jelas';
                        }

                        final invalidPattern = RegExp(r'[^a-zA-Z\s]+');
                        if (invalidPattern.hasMatch(value) &&
                            value.length < 20) {
                          return 'Masukkan perasaanmu dengan valid';
                        }

                        try {
                          final language = langdetect.detect(value);
                          print(language);
                          if (language != 'id' && language != 'tl') {
                            return 'Masukkan perasaanmu dalam bahasa Indonesia';
                          }
                        } catch (e) {
                          return 'Gagal mendeteksi bahasa. Coba lagi.';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateColor.resolveWith(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.white;
                      } else if (_isLoading) {
                        return Colors.grey;
                      }
                      return Colors.red;
                    },
                  ),
                  padding: WidgetStateProperty.all<EdgeInsets>(
                    const EdgeInsets.symmetric(vertical: 14),
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  'Kirim',
                  style: GoogleFonts.plusJakartaSans(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                key: const Key('btnSendFeeling'),
                onPressed: _isLoading ? null : _handleSubmit,
              ),
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Check internet connectivity
        if (!await ConnectivityService.isConnected()) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Koneksi internet bermasalah!'),
            ),
          );
          return;
        }
        await OpenAIService.openAIService
            .getQuotes(feeling: feelingInputController.text)
            .then((quotes) async {
          List<QuoteItem> quoteItems = quotes!
              .map((q) => QuoteItem(isFavorite: false, quote: q))
              .toList();
          QuoteModel quote = QuoteModel(
              feeling: feelingInputController.text, quotes: quoteItems);
          await FBFirestoreService.fbFirestoreService.addQuote(quote: quote);
        }).then((_) {
          Navigator.of(context).pushReplacementNamed(Routes.resultQuotes);
        });
      } catch (error) {
        Fluttertoast.showToast(
          msg: "Gagal mengirim, Coba lagi!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
