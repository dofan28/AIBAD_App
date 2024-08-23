import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/models/quote_model.dart';
import 'package:final_project/models/user_model.dart';
import 'package:final_project/services/user_preferences_service.dart';

class FBFirestoreService {
  FBFirestoreService._();

  static final FBFirestoreService fbFirestoreService = FBFirestoreService._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String usersCollection = 'users';
  String userMetaDataCollection = 'userMetaData';

  late var userId = UserPreferences.getUserId();

  addUser({required UserModel user}) async {
    DocumentReference docRef = firestore.collection(usersCollection).doc();

    await docRef.set({
      'name': user.name,
      'gender': user.gender,
      'age': user.age,
      'activity': user.activity,
      'preference': user.prefs,
    });

    return docRef.id;
  }

  Future<void> updateUser({required UserModel user}) async {
    DocumentReference docRef =
        firestore.collection(usersCollection).doc(userId);

    await docRef.update({
      'name': user.name,
      'gender': user.gender,
      'age': user.age,
      'activity': user.activity,
      'preference': user.prefs,
    });
  }

  updateUserField(
      {required String fieldName, required dynamic newValue}) async {
    DocumentReference userRef =
        firestore.collection(usersCollection).doc(userId);

    await userRef.update({
      fieldName: newValue,
    });
  }

  Future<void> addQuote({required QuoteModel quote}) async {
    DocumentReference docRef = firestore
        .collection(userMetaDataCollection)
        .doc(userId)
        .collection('quotes')
        .doc();

    await docRef.set({
      'feeling': quote.feeling,
      'quotes': quote.quotes.map((item) => item.toMap()).toList(),
      'timestamp': FieldValue.serverTimestamp(),
      'used':
          false, // Field tambahan untuk menandai apakah quote sudah digunakan
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(usersCollection).doc(userId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getTime() {
    return firestore.collection('schedules').doc(userId).get();
  }

  // Stream<DocumentSnapshot<Map<String, dynamic>>> fetchQuotes(
  //     {required idQuotes}) {
  //   return firestore
  //       .collection(userMetaDataCollection)
  //       .doc(userId)
  //       .collection('quotes')
  //       .doc(idQuotes)
  //       .snapshots();
  // }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fetchLastQuote() {
    return firestore
        .collection(userMetaDataCollection)
        .doc(userId)
        .collection('quotes')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  Future<void> isFavoriteStatusQuote(
      {required String idQuotes,
      required int quoteIndex,
      required bool newFavoriteStatus}) async {
    DocumentReference docRef = await firestore
        .collection(userMetaDataCollection)
        .doc(userId)
        .collection('quotes')
        .doc(idQuotes);

    DocumentSnapshot snapshot = await docRef.get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      List<dynamic> quotes = data['quotes'];

      if (quoteIndex < quotes.length) {
        Map<String, dynamic> quote = quotes[quoteIndex];
        quote['isFavorite'] = newFavoriteStatus;

        quotes[quoteIndex] = quote;

        await docRef.update({'quotes': quotes});
      }
    }
  }

  Stream<List<Map<String, dynamic>>> fetchAllQuotesByUser() {
    return firestore
        .collection(userMetaDataCollection)
        .doc(userId)
        .collection('quotes')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              var data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }
}
