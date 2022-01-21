import "package:flutter/material.dart";
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class NewSurveyorForm extends StatefulWidget {
  const NewSurveyorForm({Key? key}) : super(key: key);

  @override
  _NewSurveyorFormState createState() => _NewSurveyorFormState();
}

class _NewSurveyorFormState extends State<NewSurveyorForm> {
  final formKeyNewSurveyorForm = GlobalKey<FormState>();

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? qualificationDropDown;

  // List of items in our dropdown menu
  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  var genders = [
    'M',
    'F',
    'T',
  ];
  var qualifications = [
    'Degree pass',
    'Metric Pass',
    'None',
  ];
  var width, height;
  Map<String, String> surveyorForm = {};

  @override
  void initState() {
    ageDropDown = DropDownButtonWidget(
      items: items,
      name: 'Age',
    );
    genderDropDown = DropDownButtonWidget(
      items: genders,
      name: 'Gender',
    );
    qualificationDropDown = DropDownButtonWidget(
      items: qualifications,
      name: 'Qualification',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: "New Surveyor Form"),
          CustomScrollViewBody(
              bodyWidget: Padding(
            padding: Common.allPadding(mHeight: height),
            child: body(
                surveyorForm: surveyorForm, formKey: formKeyNewSurveyorForm),
          ))
        ],
      ),
    );
  }

  Widget body({required Map<String, String> surveyorForm, required formKey}) {
    final fullName = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (email) {
        List<String> splitEmail = email!.split(" ");
        surveyorForm["firstName"] = splitEmail[0];
        surveyorForm["middleName"] = splitEmail[1];
        surveyorForm["lastName"] = splitEmail[2];
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (email) => emailValidator(email!),
      onSaved: (email) {
        surveyorForm["email"] = email!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );
    final address = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (address) {
        surveyorForm["address"] = address!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Address"),
    );
    final mobileNo = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (mobileNo) => mobileNumberValidator(mobileNo!),
      onSaved: (mobileNo) {
        surveyorForm["mobileNo"] = mobileNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Mobile Number"),
    );
    final aadhaarNo = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      onSaved: (aadhaarNo) {
        surveyorForm["aadhaarNo"] = aadhaarNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Aadhaar Number"),
    );

    final submitBtn = OutlinedButton(onPressed: () {
      if(formKeyNewSurveyorForm.currentState!.validate()){
        formKeyNewSurveyorForm.currentState!.save();
      }
    }, child: Text('Submit'));
    return Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            fullName,
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
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: qualificationDropDown!,
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: address,
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
              child: Text('Date widget'),
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: aadhaarNo,
            ),
            Padding(
              padding: Common.allPadding(mHeight: height),
              child: submitBtn,
            ),
          ],
        ));
  }
}
