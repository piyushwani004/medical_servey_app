import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/utils/constants.dart';
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
    return Response(isSuccessful: isSuccessful,message:  message);
  }


  Future<Response> createSurveyorAccount(Surveyor surveyor) async {

    //creating the surveyor account with random password
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: surveyor.email, password: DEF_SEC_FB );
      return Response(isSuccessful: true, message: 'Created Successfully');
    } on FirebaseAuthException catch (e) {
      return Response(isSuccessful: false,message: e.message.toString());
    }
  }


  getAdminDetails(){
    
  }


}
