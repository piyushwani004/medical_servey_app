import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';

import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/functions.dart';

import 'DropDownWidget.dart';
import 'MultiSelect_Dialog.dart';
import 'common.dart';
import 'loading.dart';

class PatientEditDialog extends StatefulWidget {
  final Patient patient;

  PatientEditDialog({Key? key, required this.patient}) : super(key: key);

  @override
  _PatientEditDialogState createState() => _PatientEditDialogState();
}

class _PatientEditDialogState extends State<PatientEditDialog> {
  final _formKey = GlobalKey<FormState>();
  AdminFirebaseService _firebaseService = AdminFirebaseService();

  var width, height;
  String _selectedDate = formatDate(DateTime.now().toString());
  bool _switchValue = false;

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

  Future<Response> onPressedSubmit() async {
    Response response;
    print("selectedValues::::::--- $selectedValues");
    if (_formKey.currentState!.validate() &&
        selectedValues != null &&
        selectedValues!.isNotEmpty) {
      print(widget.patient.toString() + "\npatient that is selected 61");
      print('$patientForm' + 'Patient form before');
      print('in if of form valid 62');
      patientForm['id'] = widget.patient.id;
      print(widget.patient.id);
      patientForm['date'] = _selectedDate;
      print(_selectedDate);
      patientForm['surveyorUID'] = widget.patient.surveyorUID;
      print(_selectedDate);
      patientForm['age'] = ageDropDown!.selectedItem!;
      patientForm['gender'] = genderDropDown!.selectedItem!;
      patientForm['profession'] = professionDropDown!.selectedItem!;
      patientForm['village'] = widget.patient.village;
      _formKey.currentState!.save();
      print('$patientForm' + 'Patient form after');

      print('in if of form saved 69');
      Patient patientData = Patient(
        id: patientForm['id'].toString(),
        firstName: patientForm['firstName']!,
        middleName: patientForm['middleName']!,
        lastName: patientForm['lastName'].toString(),
        profession: patientForm['profession'].toString(),
        email: patientForm['email'].toString(),
        mobileNumber: patientForm['mobileNumber'].toString(),
        address: patientForm['address'].toString(),
        gender: patientForm['gender'].toString(),
        date: patientForm['date'].toString(),
        diseases: selectedValues!.toList(),
        surveyorUID: patientForm['surveyorUID'].toString(),
        age: int.parse(patientForm['age'].toString()),
        village: patientForm['village'].toString(),
      );
      print('in if of form patient assigned');

      print("patientData $patientData");
      response = await _firebaseService.updatePatient(patientData);
      print('in if of form after fetching from firebase 95');
      if (response.isSuccessful) {
        await Common.showAlert(
            context: context,
            title: 'Patient Update',
            content: response.message,
            isError: false);
        _formKey.currentState!.reset();
        return response;
      } else {
        await Common.showAlert(
            context: context,
            title: 'Failed in Update Patient',
            content: response.message,
            isError: true);
        return response;
      }
    } else {
      await Common.showAlert(
          context: context,
          title: 'Invalid Operation',
          content: 'Please select Disease',
          isError: true);
      return response = Response(
          isSuccessful: false, message: 'Some fields have invalid values.');
    }
  }

  @override
  void initState() {
    ageDropDown = DropDownButtonWidget(
      items: ages.map((age) => age.toString()).toList(),
      selectedItem: widget.patient.age.toString(),
      name: 'Age',
    );
    genderDropDown = DropDownButtonWidget(
      items: genders,
      name: 'Gender',
      selectedItem: widget.patient.gender,
    );
    professionDropDown = DropDownButtonWidget(
      items: profession,
      name: 'Profession',
      selectedItem: widget.patient.profession,
    );
    getAllDisease();
    selectedValues = widget.patient.diseases.toSet();
    super.initState();
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
          initialSelectedValues: widget.patient.diseases.toSet(),
        );
      },
    ));

    print("selectedValues" + selectedValues.toString());
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return AlertDialog(
      scrollable: true,
      title: Text('Edit Patient'),
      content: body(),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Response res = await onPressedSubmit();
            print(res.isSuccessful);
            if (res.isSuccessful) {
              Navigator.pop(context);
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
  }

  Widget body() {
    final fullName = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      initialValue:
          "${widget.patient.firstName} ${widget.patient.middleName} ${widget.patient.lastName}",
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
      initialValue: widget.patient.email,
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
      initialValue: widget.patient.address,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (address) {
        patientForm["address"] = address!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Address"),
    );
    final mobileNo = TextFormField(
      initialValue: widget.patient.mobileNumber,
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
        patientForm["diseases"] = othDisease!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Disease"),
    );

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
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
            ],
          ),
        ));
  }
}
