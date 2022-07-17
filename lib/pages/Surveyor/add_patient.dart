import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/Services/Surveyor/village_select_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/pages/Surveyor/AddPatients/empty_state.dart';
import 'package:medical_servey_app/pages/Surveyor/AddPatients/form.dart';
import 'package:medical_servey_app/routes/routes.dart';
import 'package:medical_servey_app/widgets/alertdialog.dart';
import 'package:medical_servey_app/widgets/common.dart';

class AddPatientForm extends StatefulWidget {
  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  List<UserForm> users = List.empty(growable: true);
  List<Disease> _diseaseData = [];
  List<String> _diseaseList = [];
  String? selectedVillage;
  Surveyor? _surveyor;
  User? user;
  SurveyorFirebaseService _firebaseService = SurveyorFirebaseService();
  VillageSelectService _villageSelectService = VillageSelectService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Add Patients'),
        actions: <Widget>[
          FlatButton(
            child: Text('Save'),
            textColor: Colors.white,
            onPressed: onSave,
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF30C1FF),
              Color(0xFF2AA7DC),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: users.length <= 0
            ? Center(
                child: EmptyState(
                  title: 'Oops',
                  message: 'Add Patient by tapping add button below',
                ),
              )
            : ListView.builder(
                addAutomaticKeepAlives: true,
                itemCount: users.length,
                itemBuilder: (_, i) => users[i],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: onAddFormValidation,
        foregroundColor: Colors.white,
      ),
    );
  }

  ///on form Patient deleted
  void onDelete(Patient _user) {
    // print("_user::; ${_user.id}");
    // int index = users.indexWhere((element) => element.patient.id == _user.id);
    // print("index id ::: ${users.elementAt(index).patient.id}");
    // print("index::: $index");
    setState(
      () {
        // for (int i = 0; i < users.length; i++) {
        //   if (users[i].patient == _user) {
        //     print("index in IF :: $i");
        //     users.removeAt(i);
        //   }
        // }

        var find = users.firstWhere(
          (it) => it.patient.id == _user.id,
        );
        if (find != null) users.removeAt(users.indexOf(find));

        // users.removeWhere((item) {
        //   if (item.patient.id == _user.id) {
        //     print("OnDelete user ${_user.id}");
        //     print("OnDelete item ${item.patient.id}}");
        //     print("OnDelete inside if");
        //     return true;
        //   }
        //   return false;
        // });
      },
    );
  }

  fetchSelectedVillage() async {
    _surveyor = await _firebaseService.getSurveyorDetails();
    selectedVillage = await _villageSelectService.getSelectedVillageString(
        passedUID: user!.uid);
    print("selectedVillage: $selectedVillage");
    print("_surveyor!.taluka: ${_surveyor!.taluka}");
    setState(() {});
  }

  getCurrentUser() async {
    user = await _firebaseService.getCurrentUser();
    setState(() {});
  }

  getAllDisease() async {
    _diseaseData = await _firebaseService.getAllDiseases();
    _diseaseList = _diseaseData.map((e) => e.name).toSet().toList();
    setState(() {});
  }

  void onAddFormValidation() async {
    if (users.length == 0) {
      onAddForm();
    } else {
      var allValid = true;
      users.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        onAddForm();
      }
    }
  }

  //on add form
  void onAddForm() async {
    if (user == null ||
        selectedVillage == null ||
        _diseaseList.isEmpty ||
        _surveyor == null) {
      await getCurrentUser();
      await fetchSelectedVillage();
      await getAllDisease();
    }
    setState(() {
      var _patient = Patient.empty();
      users.add(UserForm(
        patientId: users.length,
        patient: _patient,
        surveyorID: user!.uid.toString(),
        taluka: _surveyor!.taluka,
        village: selectedVillage.toString(),
        diseaseList: _diseaseList,
        onDelete: (index) {
          print("object $index");
          setState(() {
            users.remove(index);
          });
        },
      ));
    });
  }

  //on save forms
  void onSave() {
    if (users.length > 0) {
      var allValid = true;
      users.forEach((form) => allValid = allValid && form.isValid());
      if (allValid) {
        var patientData = users.map((it) => it.patient).toList();
        print("Save Patients Final... ${patientData.length}");
        _showDialog(context: context, data: patientData);
      }
    }
  }

  _showDialog({required BuildContext context, required List<Patient> data}) {
    VoidCallback continueCallBack = () async {
      for (Patient patient in data) {
        Response response =
            await _firebaseService.savePatient(patient: patient);
        if (!response.isSuccessful) {
          Common.showAlert(
              context: context,
              title: 'Failed in Adding Patient',
              content: response.message,
              isError: true);
          break;
        }
      }
      Navigator.of(context).pop();
      Navigator.pushNamedAndRemoveUntil(
          context, routeHome, (Route<dynamic> route) => false);
    };
    BlurryDialog alert = BlurryDialog("Confirmation",
        "Are you sure you want to upload Patients?", continueCallBack);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
