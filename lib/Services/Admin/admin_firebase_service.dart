import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:medical_servey_app/models/Admin/Disease.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/utils/constants.dart';

class AdminFirebaseService {
  FirebaseFirestore? instance = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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
     String id = await getDocId(rootDocName: "Surveyor", uniqueField:'email', uniqueFieldValue: surveyor.email);
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

  Future<Response> createSurveyorAccount(Surveyor surveyor) async {
    //creating the surveyor account with random password
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: surveyor.email, password: DEF_SEC_FB);
      return Response(isSuccessful: true, message: 'Created Successfully');
    } on FirebaseAuthException catch (e) {
      return Response(isSuccessful: false, message: e.message.toString());
    }
  }

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
}
