import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/MultiSelect_Dialog.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class AddPatientForm extends StatefulWidget {
  const AddPatientForm({Key? key}) : super(key: key);

  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final formKeyNewSurveyorForm = GlobalKey<FormState>();
  SurveyorFirebaseService _firebaseService = SurveyorFirebaseService();

  var width, height;
  String _selectedDate = formatDate(DateTime.now().toString());
  bool _switchValue = false;
  User? user;

  Map<String, String> patientForm = {};
  List<Disease> _diseaseList = [];
  List<MultiSelectDialogItem> _items = [];
  List<int> ages = generateN2MList(15, 100);
  Set? selectedValues;

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? professionDropDown;

  var genders = [
    'Male',
    'Female',
    'Intersex',
  ];

  var profession = [
    'Degree pass',
    'Metric Pass',
    'None',
  ];

  onPressedSubmit() async {
    if (formKeyNewSurveyorForm.currentState!.validate() &&
        selectedValues != null &&
        selectedValues!.isNotEmpty) {
      patientForm['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      patientForm['date'] = _selectedDate;
      patientForm['surveyorUID'] = user!.uid.toString();
      patientForm['age'] = ageDropDown!.selectedItem!;
      patientForm['gender'] = genderDropDown!.selectedItem!;
      patientForm['profession'] = professionDropDown!.selectedItem!;
      formKeyNewSurveyorForm.currentState!.save();

      Patient patientData = Patient(
          id: patientForm['id'].toString(),
          firstName: patientForm['firstName'].toString(),
          middleName: patientForm['middleName'].toString(),
          lastName: patientForm['lastName'].toString(),
          profession: patientForm['profession'].toString(),
          email: patientForm['email'].toString(),
          mobileNumber: patientForm['mobileNumber'].toString(),
          address: patientForm['address'].toString(),
          gender: patientForm['gender'].toString(),
          date: patientForm['date'].toString(),
          diseases: selectedValues!.toList(),
          surveyorUID: patientForm['surveyorUID'].toString(),
          otherDisease: patientForm['otherDisease'].toString(),
          age: int.parse(patientForm['age'].toString()));

      print("patientData $patientData");
      Response response =
          await _firebaseService.savePatient(patient: patientData);
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
    } else {
      showSnackBar(context, "select Diseases..");
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
    _diseaseList = await _firebaseService.getAllDiseases();

    setState(() {
      _diseaseList.forEach((element) {
        _items.add(
          MultiSelectDialogItem(int.parse(element.id), element.name),
        );
      });
    });
  }

  void _showMultiSelect(BuildContext context) async {
    selectedValues = (await showDialog<Set>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: _items,
          initialSelectedValues: selectedValues ?? [].toSet(),
        );
      },
    ));

    print("selectedValues" + selectedValues.toString());
  }

  String? otherDiseaseValidator(String? value) {
    if (_switchValue && value != null && value.isNotEmpty) {
      value = value.trim();
      return null;
    } else {
      return "Other Disease can't be empty";
    }
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

  Widget body({required Map<String, String> patientForm, required formKey}) {
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

    final showDiseases = TextButton(
        onPressed: () {
          _showMultiSelect(context);
        },
        child: Text("Show Diseases"));

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
                Flexible(
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: showDiseases,
                  ),
                ),
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
}
