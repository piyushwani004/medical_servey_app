import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/Disease.dart';
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
  var width, height;
  String _selectedDate = formatDate(DateTime.now().toString());
  Map<String, String> patientForm = {};
  List<Disease> _diseaseList = [];
  SurveyorFirebaseService _firebaseService = SurveyorFirebaseService();

  bool _switchValue = false;

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? professionDropDown;

  List<int> ages = generateN2MList(15, 100);
  var genders = [
    'M',
    'F',
    'T',
  ];

  var profession = [
    'Degree pass',
    'Metric Pass',
    'None',
  ];

  onPressedSubmit() async {
    print("surveyorStart");
    if (formKeyNewSurveyorForm.currentState!.validate()) {
      patientForm['id'] = "1234";
      patientForm['date'] = _selectedDate;
      patientForm['age'] = ageDropDown!.selectedItem!;
      patientForm['gender'] = genderDropDown!.selectedItem!;
      patientForm['profession'] = professionDropDown!.selectedItem!;
      formKeyNewSurveyorForm.currentState!.save();

      Patient surveyor = Patient.fromMap(patientForm);
      print("surveyor $surveyor");
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
    getAllDisease();
    super.initState();
  }

  getAllDisease() async {
    _diseaseList = await _firebaseService.getAllDiseases();
    setState(() {
      print("_diseaseList  $_diseaseList");
    });
  }

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'Disease one'),
      MultiSelectDialogItem(2, 'Disease two'),
      MultiSelectDialogItem(3, 'Disease three'),
    ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [1].toSet(),
        );
      },
    );

    print("selectedValues" + selectedValues.toString());
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
        patientForm["diseases"] = othDisease!;
      },
      // validator: (email) => emailValidator(email!),
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
              width: width,
              height: height * 0.3,
              child: Container(
                margin: EdgeInsets.all(height * 0.01),
                decoration: Common.containerBoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    NEW_SURVEY_PATH,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: Text("Others"),
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: diseaseSwitch,
                  ),
                ),
                Flexible(
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
