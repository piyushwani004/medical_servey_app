import "package:flutter/material.dart";
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/form_container.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';
import 'package:provider/provider.dart';

import 'main/components/side_menu.dart';

class NewSurveyorForm extends StatefulWidget {
  const NewSurveyorForm({Key? key}) : super(key: key);

  @override
  _NewSurveyorFormState createState() => _NewSurveyorFormState();
}

class _NewSurveyorFormState extends State<NewSurveyorForm> {
  String selectedDate = DateTime.now().toString();

  final formKeyNewSurveyorForm = GlobalKey<FormState>();

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? qualificationDropDown;
  DropDownButtonWidget? villageToAssign;

  onPressedSubmit() {
    print("surveyorStart");
    if (formKeyNewSurveyorForm.currentState!.validate()) {
      surveyorForm['joiningDate']=selectedDate;
      surveyorForm['age'] = ageDropDown!.selectedItem!;
      surveyorForm['gender'] = genderDropDown!.selectedItem!;
      surveyorForm['profession'] = qualificationDropDown!.selectedItem!;
      surveyorForm['villageToAssign'] = villageToAssign!.selectedItem!;
      formKeyNewSurveyorForm.currentState!.save();

      print("surveyorForm");
      Surveyor surveyor = Surveyor.fromMap(surveyorForm);
      print(surveyor);
    }
  }

  // List of items in our dropdown menu
  var items = [
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  var villages = [
    'Bhusawal',
    'Jalgao',
    'Yavatmal',
    'Pune',
    'Wardha',
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
    villageToAssign = DropDownButtonWidget(
      items: villages,
      name: 'Village To Assign',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: !Responsive.isDesktop(context) ? SideMenu() : null,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // We want this side menu only for large screen
          if (Responsive.isDesktop(context))
            Expanded(
              // default flex = 1
              // and it takes 1/6 part of the screen
              child: SideMenu(),
            ),
          Expanded(
            flex: 5,
            child: CustomScrollView(
              slivers: [
                TopSliverAppBar(mHeight: height, text: "New Surveyor Form"),
                CustomScrollViewBody(
                    bodyWidget: Padding(
                  padding: Common.allPadding(mHeight: height),
                  child: body(
                      surveyorForm: surveyorForm,
                      formKey: formKeyNewSurveyorForm),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body({required Map<String, String> surveyorForm, required formKey}) {
    final fullName = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator:(name){
        print("in valid full name");
        String fullName = name!.trim();
        // print();
        if (fullName.split(" ").length==3) {
          return null;
        } else {
          return "*Enter a valid Name";
        }

      } ,
      onSaved: (name) {
        String fullName = name!.trim();
        List<String> splitName = fullName.split(" ");
        surveyorForm["firstName"] = splitName[0];
        surveyorForm["middleName"] = splitName[1];
        surveyorForm["lastName"] = splitName[2];
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
        surveyorForm["mobileNumber"] = mobileNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Mobile Number"),
    );
    final aadhaarNo = TextFormField(
      keyboardType: TextInputType.number,
      // validator: (aadhaarNo) => aadhaarNumberValidator(aadhaarNo!),
      autofocus: false,
      onSaved: (aadhaarNo) {
        surveyorForm["aadhaarNo"] = aadhaarNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Aadhaar Number"),
    );

    final submitBtn = OutlinedButton(
        onPressed: () {
          onPressedSubmit();
        },
        child: Text('Submit'));
    return FormContainer(
      mHeight: height,
      mWidth: width,
      form: Form(
          key: formKey,
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
                      child: qualificationDropDown!,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                        padding: Common.allPadding(mHeight: height),
                        child: Container(
                          child: TextButton(
                              onPressed: () async {
                                selectedDate = await selectDate(context);
                                setState(() {});
                              },
                              child: Text(selectedDate == (DateTime.now().toString())?'Today':selectedDate)),
                        )),
                  ),
                ],
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
                child: villageToAssign,
              ),
              Padding(
                padding: Common.allPadding(mHeight: height),
                child: email,
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
          )),
    );
  }
}
