import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/Services/Common/auth_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/constants.dart';

//stream for getting admin email
StreamController<String> adminEmailStream = StreamController<String>();
void disposeAdminEmailStream() {
  adminEmailStream.close();
}

class AdminFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//***************Surveyor-Methods***********//

  Future<Response> saveNewSurveyor(Surveyor surveyor) async {
    //saving the surveyor details first
    CollectionReference surveyorCollection = instance!.collection('Surveyor');
    String message = "";
    bool isSuccessful = false;
    try {
      await surveyorCollection
          .doc()
          .set(surveyor.toMap())
          .whenComplete(() async {
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
    return Response(isSuccessful: isSuccessful, message: message);
  }

  Future<Response> updateSurveyor(Surveyor surveyor) async {
    //updating the surveyor details first
    CollectionReference surveyorCollection = instance!.collection('Surveyor');
    String message = "";
    bool isSuccessful = false;
    try {
      String id = await getDocId(
          rootDocName: "Surveyor",
          uniqueField: 'email',
          uniqueFieldValue: surveyor.email);
      surveyorCollection.doc(id).update(surveyor.toMap());
      message = "Updated Successfully";
      isSuccessful = true;
      return Response(isSuccessful: isSuccessful, message: message);
    } on FirebaseException catch (e) {
      isSuccessful = false;
      message = e.message.toString();
      return Response(isSuccessful: isSuccessful, message: message);
    }
  }

  Future<Response> deleteSurveyor(Surveyor surveyor) async {
    //updating the surveyor details first

    String message = "";
    bool isSuccessful = false;
    String email = surveyor.email;
    try {
      final QuerySnapshot searchedUserId = await instance!
          .collection('Surveyor')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      DocumentSnapshot document = searchedUserId.docs.first;
      final userDocId = document.id;

      print("deleteSurveyor info::: $userDocId");
      CollectionReference surveyorCollection = instance!.collection('Surveyor');
      surveyorCollection.doc(userDocId).delete();

      message = "Delete Successfully";
      isSuccessful = true;
      return Response(isSuccessful: isSuccessful, message: message);
    } on FirebaseException catch (e) {
      isSuccessful = false;
      message = e.message.toString();
      return Response(isSuccessful: isSuccessful, message: message);
    }
  }

  Future<Response> createSurveyorAccount(Surveyor surveyor) async {
    //creating the surveyor account with random password
    try {
      // await firebaseAuth.createUserWithEmailAndPassword(
      //     email: surveyor.email, password: DEF_SEC_FB);
      Response res = await FirebaseAuthService(firebaseAuth)
          .signUp(email: surveyor.email, password: DEF_SEC_FB);
      if (res.isSuccessful) {
        return Response(isSuccessful: true, message: 'Created Successfully');
      } else {
        return Response(isSuccessful: false, message: '${res.message}');
      }
    } on FirebaseAuthException catch (e) {
      print("in forebase auth exp ${e.code}");
      return Response(isSuccessful: false, message: e.message.toString());
    } catch (e) {
      print("in normal exp");
      return Response(isSuccessful: false, message: e.toString());
    }
  }

  Future<List<Surveyor>> getSurveyors() async {
    List<Surveyor> _surveyors = [];
    CollectionReference surveyorCollection = instance!.collection('Surveyor');
    var allSurveyorsSnapshots = await surveyorCollection.get();

    // for(var surveyor in allSurveyorsSnapshots.docs){
    //   _surveyors.add(Surveyor.fromMap(surveyor.data() as Map<String,dynamic>));
    // }

    _surveyors.addAll(allSurveyorsSnapshots.docs.map((surveyor) =>
        Surveyor.fromMap(surveyor.data() as Map<String, dynamic>)));

    // print(_surveyors);
    // allSurveyorsSnapshots.docs.forEach((element) {
    //   element.data();
    //   print(element.data().toString());
    // });

    return _surveyors;
  }

  //***************Disease-Methods***********//

  Future<Response> saveNewDiseases(Disease disease) async {
    //saving the surveyor details first
    CollectionReference surveyorCollection = instance!.collection('Diseases');
    String message = "";
    bool isSuccessful = false;
    try {
      await surveyorCollection
          .doc(disease.id)
          .set(disease.toMap())
          .whenComplete(() async {
        isSuccessful = true;
        message = "Added New Disease";
      }).onError((error, stackTrace) {
        isSuccessful = false;
        message = error.toString();
      });
    } catch (e) {
      isSuccessful = false;
      message = e.toString();
    }
    return Response(isSuccessful: isSuccessful, message: message);
  }

  Future<List<Disease>> getAllDiseases() async {
    List<Disease> _diseaseList = [];
    QuerySnapshot querySnapshot = await collectionDisease.get();
    _diseaseList.addAll(querySnapshot.docs.map(
        (disease) => Disease.fromMap(disease.data() as Map<String, dynamic>)));
    print("_diseaseList: $_diseaseList");
    return _diseaseList;
  }

  Future<Response> updateDisease({required Disease disease}) async {
    String message = "";
    bool isSuccessful = false;
    print(disease.toMap());
    try {
      await collectionDisease
          .doc(disease.id)
          .update(disease.toMap())
          .then((value) {
        return value;
      }).whenComplete(() {
        isSuccessful = true;
        message = "successfully update...";
      }).onError((error, stackTrace) {
        isSuccessful = false;
        message = "$error";
      });
    } catch (e) {
      isSuccessful = false;
      message = "$e";
    }
    return Response(isSuccessful: isSuccessful, message: message);
  }

  Future<Response> deleteDisease({required Disease disease}) async {
    String message = "";
    bool isSuccessful = false;
    try {
      String id = disease.id;
      await collectionDisease.doc(id).delete();
      message = "Delete Successfully";
      isSuccessful = true;
      return Response(isSuccessful: isSuccessful, message: message);
    } on FirebaseException catch (e) {
      isSuccessful = false;
      message = e.message.toString();
      return Response(isSuccessful: isSuccessful, message: message);
    }
  }

  //***************Patient-Methods***********//

  Future<List<Patient>> getPatients() async {
    List<Patient> _patients = [];
    CollectionReference patientCollection = instance!.collection('Patient');
    var allSurveyorsSnapshots = await patientCollection
        .orderBy('date', descending: true)
        .limit(10)
        .get();
    _patients.addAll(allSurveyorsSnapshots.docs.map((surveyor) =>
        Patient.fromMap(surveyor.data() as Map<String, dynamic>)));
    return _patients;
  }

  Future<List<Patient>> getPatientsByKeys({
    required String key,
    required String value,
  }) async {
    List<Patient> _patients = [];
    var allSurveyorsSnapshots =
        await collectionPatient.where("$key", isEqualTo: value).get();
    _patients.addAll(allSurveyorsSnapshots.docs.map((surveyor) =>
        Patient.fromMap(surveyor.data() as Map<String, dynamic>)));
    return _patients;
  }

  Future<Response> updatePatient(Patient patient) async {
    //updating the surveyor details first
    CollectionReference surveyorCollection = instance!.collection('Patient');
    String message = "";
    bool isSuccessful = false;
    try {
      String id = patient.id;
      surveyorCollection.doc(id).update(patient.toMap());
      message = "Updated Successfully";
      isSuccessful = true;
      return Response(isSuccessful: isSuccessful, message: message);
    } on FirebaseException catch (e) {
      isSuccessful = false;
      message = e.message.toString();
      return Response(isSuccessful: isSuccessful, message: message);
    }
  }

  Future<Response> deletePatient(Patient patient) async {
    //updating the surveyor details first
    CollectionReference surveyorCollection = instance!.collection('Patient');
    String message = "";
    bool isSuccessful = false;
    try {
      String id = patient.id;
      surveyorCollection.doc(id).delete();
      message = "Delete Successfully";
      isSuccessful = true;
      return Response(isSuccessful: isSuccessful, message: message);
    } on FirebaseException catch (e) {
      isSuccessful = false;
      message = e.message.toString();
      return Response(isSuccessful: isSuccessful, message: message);
    }
  }

  //***************General-Methods***********//

  Future<String> getAdminEmail() async {
    String email = "";
    CollectionReference categories = instance!.collection('Users');
    DocumentSnapshot snapshot = await categories.doc('Admin').get();
    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (data.containsKey("Email")) {
        email = data['Email'].toString();
      }
    }
    return email;
  }

  Future<String> getDocId({
    required String rootDocName,
    required String uniqueField,
    required String uniqueFieldValue,
  }) async {
    var data = await instance!
        .collection(rootDocName)
        .where(uniqueField, isEqualTo: uniqueFieldValue)
        .get();

    return data.docs[0].id;
  }

  Future<bool> checkExist(String path, String docID) async {
    bool exist = false;
    try {
      await instance!.doc("$path/$docID").get().then((doc) {
        exist = doc.exists;
      });
      return exist;
    } catch (e) {
      return false;
    }
  }

  //****************************** Dashboard Count Methods ******************************//

  Future<int> getCount({required String collectionName}) async {
    var count = 0;
    final QuerySnapshot qSnap = await FirebaseFirestore.instance
        .collection(collectionName) //your collectionref
        .get();
    count = qSnap.docs.length;
    return count;
  }

  Future<int> getCountByGender({
    required String key,
    required String value,
  }) async {
    List<Patient> _patients = [];
    var allSurveyorsSnapshots =
        await collectionPatient.where("$key", isEqualTo: value).get();
    _patients.addAll(allSurveyorsSnapshots.docs.map((surveyor) =>
        Patient.fromMap(surveyor.data() as Map<String, dynamic>)));
    return _patients.length;
  }
}
