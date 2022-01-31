import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/Disease.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/utils/constants.dart';

class SurveyorFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<Surveyor?> getSurveyorDetails() async {
    List<Surveyor> _surveyors = [];
    try {
      var email = firebaseAuth.currentUser?.email.toString();
      CollectionReference collection = instance!.collection('Surveyor');
      var querySnapshots =
          await collection.where('email', isEqualTo: email).get();

      _surveyors.addAll(querySnapshots.docs.map((surveyor) =>
          Surveyor.fromMap(surveyor.data() as Map<String, dynamic>)));
    } catch (e) {
      print(e);
    }

    print(_surveyors.toString());
    return _surveyors.first;
  }

  Future<List<Disease>> getAllDiseases() async {
    List<Disease> _diseaseList = [];
    QuerySnapshot querySnapshot = await collectionDisease.get();
    _diseaseList.addAll(querySnapshot.docs.map(
        (disease) => Disease.fromMap(disease.data() as Map<String, dynamic>)));
    print("SurveyorFirebaseService: $_diseaseList");
    return _diseaseList;
  }
}
