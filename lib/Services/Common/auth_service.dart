//provider code

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:medical_servey_app/models/common/Responce.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<Response> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return Response(isSuccessful: true, message: "Log out Successfully!");
    } on FirebaseAuthException catch (e) {
      return Response(isSuccessful: false, message: '${e.message}');
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<Response> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return Response(isSuccessful: true, message: "Signed In Successfully");
    } on FirebaseAuthException catch (e) {
      // print("ERROR :::" + e.code);
      return Response(isSuccessful: false, message: "${e.code}");
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<Response> signUp(
      {required String email, required String password}) async {
    try {
      FirebaseApp app = await Firebase.initializeApp(
          name: '$email', options: Firebase.app().options);
      print("${app.toString()} app.toString()");
      await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);
      return Response(message: "Signed up", isSuccessful: true);
    } on FirebaseAuthException catch (e) {
      print("in forebase auth exp of sigup${e.code}");
      return Response(isSuccessful: false, message: e.message.toString());
    } catch (e) {
      print("in normal exc of signup ${e.toString()}");
      return Response(isSuccessful: false, message: "${e.toString()}");
    }
  }

  Future<Response> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return Response(
          isSuccessful: true, message: "Successfully sent email to $email");
    } on FirebaseAuthException catch (e) {
      return Response(isSuccessful: false, message: e.message.toString());
    }
  }

  Future<Response> deleteUser() async {
    try {
      User? firebaseUser = _firebaseAuth.currentUser;
      firebaseUser!.delete();
      return Response(isSuccessful: true, message: "Successfully delete user");
    } on FirebaseAuthException catch (e) {
      return Response(isSuccessful: false, message: e.message.toString());
    }
  }

  Stream<Response> checkValidAccount({required String email}) async* {
    try {
      print("checkValidAccount...");
      FirebaseFirestore _instance = FirebaseFirestore.instance;
      CollectionReference surveyorCollection = _instance.collection('Surveyor');
      var collection = surveyorCollection.where("email", isEqualTo: "$email");
      var querySnapshots = await collection.get();
      print("querySnapshots: ${querySnapshots.docs.toString()}");
      if (querySnapshots.size > 0) {
        yield Response(isSuccessful: true, message: "Valid User");
      } else {
        yield Response(isSuccessful: false, message: "Failed");
      }
    } catch (e) {
      yield Response(isSuccessful: false, message: "${e.toString()}");
    }
  }
}


//errors to handle
// static bool getMessageFromErrorCode(errorCode) {
//   switch (errorCode) {
//     case "ERROR_EMAIL_ALREADY_IN_USE":
//     case "account-exists-with-different-credential":
//     case "email-already-in-use":
//       throw Exception("Email already used. Go to login page.");
//     case "ERROR_WRONG_PASSWORD":
//     case "wrong-password":
//       throw Exception("Wrong email/password combination.");
//     case "ERROR_USER_NOT_FOUND":
//     case "user-not-found":
//       throw Exception("No user found with this email.");
//     case "ERROR_USER_DISABLED":
//     case "user-disabled":
//       throw Exception( "User disabled.");
//     case "ERROR_TOO_MANY_REQUESTS":
//     case "operation-not-allowed":
//       throw Exception( "Too many requests to log into this account.");
//     case "ERROR_OPERATION_NOT_ALLOWED":
//       throw Exception( "Server error, please try again later.");
//     case "ERROR_INVALID_EMAIL":
//     case "invalid-email":
//       throw Exception( "Email address is invalid.");
//     case "SignIn":
//       return true;
//   }
//   throw Exception( "$errorCode");
// }