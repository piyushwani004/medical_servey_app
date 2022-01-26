//provider code

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  /// Changed to idTokenChanges as it updates depending on more cases.
  Stream<User?> get authStateChanges => _firebaseAuth.idTokenChanges();

  /// This won't pop routes so you could do something like
  /// Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  /// after you called this method if you want to pop all routes.
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return 'SignIn';
    } on FirebaseAuthException catch (e) {
      print("ERROR :::"+e.code);
      return e.code;
    }
  }

  /// There are a lot of different ways on how you can do exception handling.
  /// This is to make it as easy as possible but a better way would be to
  /// use your own custom class that would take the exception and return better
  /// error messages. That way you can throw, return or whatever you prefer with that instead.
  Future<String?> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return "Signed up";
    } on FirebaseAuthException catch (e) {
      return e.message;
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