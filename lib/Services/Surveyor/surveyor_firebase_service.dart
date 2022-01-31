import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/Disease.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/constants.dart';

class SurveyorFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<User?> getCurrentUser() async {
    User? user = firebaseAuth.currentUser;
    return user;
  }

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

  Future<List<Patient>> getAllPatients() async {
    List<Patient> _patientList = [];
    var uid = firebaseAuth.currentUser?.uid.toString();
    QuerySnapshot querySnapshot =
        await collectionPatient.where('surveyorUID', isEqualTo: uid).get();
    _patientList.addAll(querySnapshot.docs.map(
        (patient) => Patient.fromMap(patient.data() as Map<String, dynamic>)));
    print("_patientList: $_patientList");
    return _patientList;
  }

  Future<Response> savePatient({required Patient patient}) async {
    CollectionReference surveyorCollection = instance!.collection('Patient');
    String message = "";
    bool isSuccessful = false;
    try {
      await surveyorCollection
          .doc(patient.id)
          .set(patient.toMap())
          .whenComplete(() async {
        isSuccessful = true;
        message = "Added New Patient";
      }).onError((error, stackTrace) {
        isSuccessful = false;
        message = error.toString();
      });
    } catch (e) {
      isSuccessful = false;
      message = e.toString();
    }
    return Response(isSuccessful: isSuccessful, message: "$message");
  }
}
