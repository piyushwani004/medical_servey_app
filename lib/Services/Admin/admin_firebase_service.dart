import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import '../../utils/functions.dart';

class AdminFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Response> saveNewSurveyor(Surveyor surveyor) async {
    
    //saving the surveyor details first
    CollectionReference surveyorCollection = instance!.collection('Surveyor');
    String message = "";
    bool isSuccessful = false;
    try {
      await surveyorCollection.doc().set(surveyor.toMap()).whenComplete(() async {
        isSuccessful = true;
        message = "Added New Surveyor";


      }).onError((error, stackTrace) {
        isSuccessful = false;
        message = error.toString();
      });
    } catch (e) {
      isSuccessful = false;
      message = e.toString();
    }
    return Response(isSuccessful, message);
  }


  Future<Response> createSurveyorAccount(Surveyor surveyor) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: surveyor.email, password:generateRandomString(6) );
      return Response(true, 'Created Successfully');
    } on FirebaseAuthException catch (e) {
      return Response(false,e.message);
    }
  }


}
