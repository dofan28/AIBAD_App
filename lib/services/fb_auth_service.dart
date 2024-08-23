// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:final_project/services/fb_firestore_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:final_project/models/user_model.dart';

// class FBAuthService {
//   late FirebaseFirestore firestore;
//   late FirebaseAuth auth;

//   FBAuthService._init() {
//     firestore = FirebaseFirestore.instance;
//     auth = FirebaseAuth.instance;
//   }

//   static FBAuthService fbAuthService = FBAuthService._init();

//   String collectionName = 'users';

//   GoogleSignIn googleSignIn = GoogleSignIn(
//     scopes: [
//       'email',
//     ],
//   );

//   Future<UserCredential?> registerWithEmailAndPassword(
//       {required String email, required String password}) async {

//     if (email.isEmpty || password.isEmpty) {
//       throw ArgumentError("Email and password must not be empty.");
//     }

//     UserCredential userCredential = await auth.createUserWithEmailAndPassword(
//         email: email, password: password);

//     final userUid = userCredential.user?.uid;
//     if (userUid == null) {
//       throw FirebaseAuthException(
//           code: "uid-not-found", message: "UID not found after registration.");
//     }

//     UserModel userModel = UserModel(
//       id: userUid,
//       prefs: [],
//     );

//     await FBFirestoreService.fbFirestoreService.addUser(user: userModel);
//     return userCredential;
//   }

//   Future<UserCredential> signInWithEmailAndPassword(
//       {required String email, required String password}) async {

//     UserCredential userCredential =
//         await auth.signInWithEmailAndPassword(email: email, password: password);

//     DocumentSnapshot userSnapshot =
//         await FBFirestoreService.fbFirestoreService.getUser();
//     if (userSnapshot.exists) {
//       dynamic name = (userSnapshot.data() as Map<String, dynamic>)['name'];
//       if (name != null) {
//       userCredential.user!.updateDisplayName(name);
//       } else {
//         userCredential.user!.updateDisplayName('Anonymous');
//       }
//     }

//     return userCredential;
//   }
// }
