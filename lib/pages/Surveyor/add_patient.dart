import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
      floatingActionButton: SpeedDial(
          icon: Icons.person_add,
          backgroundColor: Colors.blueAccent,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.plus_one_rounded),
              label: 'Add',
              backgroundColor: Colors.blue,
              onTap: () {
                onAddForm();
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.exposure_minus_1_rounded),
              label: 'Remove',
              backgroundColor: Colors.blue,
              onTap: () {
                onDelete();
              },
            ),
          ]),
    );
  }

  ///on form Patient deleted
  onDelete() {
    setState(
      () {
        users.removeAt(users.length - 1);
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
          print("index $index");
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
