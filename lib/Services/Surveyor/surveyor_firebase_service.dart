import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';

class SurveyorFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Response? _surveyorResponse;

  Future<Response?> getSurveyorDetails() async {
    Surveyor _surveyor;
    var email = firebaseAuth.currentUser?.email.toString();
    CollectionReference collection = instance!.collection('Surveyor');
    var querySnapshots =
        await collection.where('email', isEqualTo: email).get();
    print(querySnapshots.docs.toString());

    querySnapshots.docs.forEach((element) {
      element.data();
      print(element.toString());
    });

    return _surveyorResponse;
  }


  
}
