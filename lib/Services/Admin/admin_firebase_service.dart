import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';

class AdminFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Response> saveNewSurveyor(Surveyor surveyor) async {
    CollectionReference surveyorCollection = instance!.collection('Surveyor');
    String message = "";
    bool isSuccessful = false;
    try {
      await surveyorCollection.doc().set(surveyor.toMap()).whenComplete(() {
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
}
