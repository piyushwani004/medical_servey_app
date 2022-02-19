import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/Services/Surveyor/village_select_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../models/common/villageData.dart';
import '../../utils/image_utils.dart';

class AddPatientForm extends StatefulWidget {
  const AddPatientForm({Key? key}) : super(key: key);

  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final formKeyNewSurveyorForm = GlobalKey<FormState>();
  SurveyorFirebaseService _firebaseService = SurveyorFirebaseService();
  VillageSelectService _villageSelectService = VillageSelectService();
  final _multiKey = GlobalKey<DropdownSearchState<String>>();

  var width, height;
  String _selectedDate = formatDate(DateTime.now().toString());
  bool _switchValue = false;
  User? user;

  Map<String, dynamic> patientForm = {};
  List<VillageData> villageData = [];
  List<Disease> _diseaseData = [];
  List<String> _diseaseList = [];
  List<int> ages = generateN2MList(15, 100);
  String? selectedVillage;
  Surveyor? _surveyor;

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? professionDropDown;

  var genders = [
    'Male',
    'Female',
    'Intersex',
  ];

  var profession = [
    'No formal education',
    'Primary education',
    'Secondary education or high school',
    'GED',
    'Vocational qualification',
    'Diploma',
    'Bachelors degree',
    'Masters degree',
    'Doctorate or higher',
  ];

  fetchSelectedVillage() async {
    User? user = await _firebaseService.getCurrentUser();
    _surveyor = await _firebaseService.getSurveyorDetails();
    selectedVillage = await _villageSelectService.getSelectedVillageString(
        passedUID: user!.uid);
    print("selectedVillage: $selectedVillage");
    print("_surveyor!.taluka: ${_surveyor!.taluka}");
  }

  onPressedSubmit() async {
    await fetchSelectedVillage();
    if (formKeyNewSurveyorForm.currentState!.validate()) {
      patientForm['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      patientForm['date'] = _selectedDate;
      patientForm['surveyorUID'] = user!.uid.toString();
      patientForm['age'] = ageDropDown!.selectedItem!;
      patientForm['gender'] = genderDropDown!.selectedItem!;
      patientForm['profession'] = professionDropDown!.selectedItem!;
      patientForm['village'] = selectedVillage;
      patientForm['taluka'] = _surveyor!.taluka;
      patientForm['timestamp'] = Timestamp.fromDate(DateTime.now());
      formKeyNewSurveyorForm.currentState!.save();

      print("patientForm map: $patientForm");
      Patient patient = Patient.fromMap(patientForm);
      print("patientData $patient");

      Response response = await _firebaseService.savePatient(patient: patient);
      if (response.isSuccessful) {
        Common.showAlert(
            context: context,
            title: 'Patient Registration',
            content: response.message,
            isError: false);
        formKeyNewSurveyorForm.currentState!.reset();
      } else {
        Common.showAlert(
            context: context,
            title: 'Failed in Adding Patient',
            content: response.message,
            isError: true);
      }
    }
  }

  @override
  void initState() {
    ageDropDown = DropDownButtonWidget(
      items: ages.map((age) => age.toString()).toList(),
      name: 'Age',
    );
    genderDropDown = DropDownButtonWidget(
      items: genders,
      name: 'Gender',
    );
    professionDropDown = DropDownButtonWidget(
      items: profession,
      name: 'Profession',
    );
    getCurrentUser();
    getAllDisease();
    super.initState();
  }

  getCurrentUser() async {
    user = await _firebaseService.getCurrentUser();
  }

  getAllDisease() async {
    _diseaseData = await _firebaseService.getAllDiseases();
    _diseaseList = _diseaseData.map((e) => e.name).toSet().toList();
    setState(() {});
  }

  String? otherDiseaseValidator(String? value) {
    if (_switchValue && value != null && value.isNotEmpty) {
      value = value.trim();
      return null;
    } else {
      return "Other Disease can't be empty";
    }
  }

  onDiseaseSaved(diseaseSave) {
    print("diseaseSave :: $diseaseSave");
    patientForm['diseases'] = diseaseSave;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: CustomScrollView(
                slivers: [
                  TopSliverAppBar(mHeight: height, text: "New Patient Form"),
                  CustomScrollViewBody(
                      bodyWidget: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: body(
                        patientForm: patientForm,
                        formKey: formKeyNewSurveyorForm),
                  ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget body({required Map<String, dynamic> patientForm, required formKey}) {
    final fullName = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (name) {
        print("in valid full name");
        String fullName = name!.trim();
        // print();
        if (fullName.split(" ").length == 3) {
          return null;
        } else {
          return "*Enter a valid Name";
        }
      },
      onSaved: (name) {
        String fullName = name!.trim();
        List<String> splitName = fullName.split(" ");
        patientForm["firstName"] = splitName[0];
        patientForm["middleName"] = splitName[1];
        patientForm["lastName"] = splitName[2];
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (email) => emailValidator(email!),
      onSaved: (email) {
        patientForm["email"] = email!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );
    final address = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (address) {
        patientForm["address"] = address!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Address"),
    );
    final mobileNo = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (mobileNo) => mobileNumberValidator(mobileNo!),
      onSaved: (mobileNo) {
        patientForm["mobileNumber"] = mobileNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Mobile Number"),
    );
    final otherDiseaseInput = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (othDisease) {
        patientForm["otherDisease"] = othDisease!;
      },
      validator: (otherDisease) {
        return otherDiseaseValidator(otherDisease);
      },
      decoration: Common.textFormFieldInputDecoration(labelText: "Disease"),
    );

    final submitBtn = OutlinedButton(
        onPressed: () {
          onPressedSubmit();
        },
        child: Text('Submit'));

    final diseaseSwitch = CupertinoSwitch(
      value: _switchValue,
      onChanged: (value) {
        setState(() {
          _switchValue = value;
        });
      },
    );

    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.02,
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: fullName,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Padding(
                  padding: Common.allPadding(mHeight: height),
                  child: ageDropDown!,
                )),
                SizedBox(
                  width: width * 0.01,
                ),
                Expanded(
                    child: Padding(
                  padding: Common.allPadding(mHeight: height),
                  child: genderDropDown!,
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: professionDropDown!,
                  ),
                ),
              ],
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: mobileNo,
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: email,
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: address,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                    child: Padding(
                  padding: Common.allPadding(mHeight: height),
                  child: multipleSelectionDropdown(),
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: _switchValue ? 2 : 3,
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: Text("Others"),
                  ),
                ),
                Flexible(
                  flex: _switchValue ? 2 : 3,
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: diseaseSwitch,
                  ),
                ),
                Flexible(
                  flex: 5,
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: Visibility(
                        visible: _switchValue, child: otherDiseaseInput),
                  ),
                )
              ],
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: submitBtn,
            ),
          ],
        ));
  }

  Widget multipleSelectionDropdown() {
    return DropdownSearch<String>.multiSelection(
      key: _multiKey,
      validator: (List<String>? v) {
        return v == null || v.isEmpty ? "required field" : null;
      },
      dropdownBuilder: (context, selectedItems) {
        Widget item(String i) => Container(
              padding: EdgeInsets.only(left: 6, bottom: 3, top: 3, right: 0),
              margin: EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColorLight),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    i,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  MaterialButton(
                    height: 20,
                    shape: const CircleBorder(),
                    focusColor: Colors.red[200],
                    hoverColor: Colors.red[200],
                    padding: EdgeInsets.all(0),
                    minWidth: 34,
                    onPressed: () {
                      _multiKey.currentState?.removeItem(i);
                    },
                    child: Icon(
                      Icons.close_outlined,
                      size: 20,
                    ),
                  )
                ],
              ),
            );
        return Wrap(
          children: selectedItems.map((e) => item(e)).toList(),
        );
      },
      popupCustomMultiSelectionWidget: (context, list) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: () {
                    // How should I unselect all items in the list?
                    _multiKey.currentState?.closeDropDownSearch();
                  },
                  child: const Text('Cancel'),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: OutlinedButton(
                  onPressed: () {
                    // How should I unselect all items in the list?
                    _multiKey.currentState?.popupDeselectAllItems();
                  },
                  child: const Text('None'),
                ),
              ),
            ),
          ],
        );
      },
      dropdownSearchDecoration: Common.textFormFieldInputDecoration(
        labelText: "Select Diseases",
      ),
      mode: Mode.DIALOG,
      showSelectedItems: true,
      // onSaved: (villageSave) => onVllageSaved(villageSave),
      items: _diseaseList,
      showClearButton: true,
      onChanged: (onSaved) {
        onDiseaseSaved(onSaved);
      },
      showSearchBox: true,
      popupSelectionWidget: (cnt, String item, bool isSelected) {
        return isSelected
            ? Icon(
                Icons.check_circle,
                color: Colors.green[500],
              )
            : Container();
      },
    );
  }
}
