import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Common/MenuController.dart';
import 'package:medical_servey_app/pages/Admin/main/components/side_menu.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/MultiSelect_Dialog.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';
import 'package:provider/provider.dart';

class AddPatientForm extends StatefulWidget {
  const AddPatientForm({Key? key}) : super(key: key);

  @override
  _AddPatientFormState createState() => _AddPatientFormState();
}

class _AddPatientFormState extends State<AddPatientForm> {
  final formKeyNewSurveyorForm = GlobalKey<FormState>();
  var width, height;

  Map<String, String> patientForm = {};
  List<String> flavours = [];

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? professionDropDown;
  DropDownButtonWidget? diseasesDropdown;

  var ages = [
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

  var profession = [
    'Degree pass',
    'Metric Pass',
    'None',
  ];

  var diseases = [
    'diseases 1',
    'diseases 2',
    'diseases 3',
    'Other',
  ];

  @override
  void initState() {
    ageDropDown = DropDownButtonWidget(
      items: ages,
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
    diseasesDropdown = DropDownButtonWidget(
      items: diseases,
      name: 'Disease',
    );
    super.initState();
  }

  void _showMultiSelect(BuildContext context) async {
    final items = <MultiSelectDialogItem<int>>[
      MultiSelectDialogItem(1, 'Dog'),
      MultiSelectDialogItem(2, 'Cat'),
      MultiSelectDialogItem(3, 'Mouse'),
    ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          initialSelectedValues: [1, 3].toSet(),
        );
      },
    );

    print(selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: context.read<MenuController>().scaffoldKey,
        drawer: SideMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //We want this side menu only for large screen
              if (Responsive.isDesktop(context))
                Expanded(
                  // default flex = 1
                  // and it takes 1/6 part of the screen
                  child: SideMenu(),
                ),
              Expanded(
                // It takes 5/6 part of the screen
                flex: 5,
                child: CustomScrollView(
                  slivers: [
                    TopSliverAppBar(mHeight: height, text: "New Patient Form"),
                    CustomScrollViewBody(
                        bodyWidget: Padding(
                          padding: Common.allPadding(mHeight: height),
                          child:
                          body(patientForm: patientForm, formKey: formKeyNewSurveyorForm),
                        ))

                  ],
                ),
              ),
            ],
          ),
        ),
      );









    //   Scaffold(
    //   body: CustomScrollView(
    //     slivers: [
    //       TopSliverAppBar(mHeight: height, text: "New Patient Form"),
    //       CustomScrollViewBody(
    //           bodyWidget: Padding(
    //         padding: Common.allPadding(mHeight: height),
    //         child:
    //             body(patientForm: patientForm, formKey: formKeyNewSurveyorForm),
    //       ))
    //     ],
    //   ),
    // );
  }

  Widget body({required Map<String, String> patientForm, required formKey}) {
    final fullName = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (email) {
        List<String> splitFullName = email!.split(" ");
        patientForm["firstName"] = splitFullName[0];
        patientForm["middleName"] = splitFullName[1];
        patientForm["lastName"] = splitFullName[2];
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
        patientForm["mobileNo"] = mobileNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Mobile Number"),
    );
    final otherDisease = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (othDisease) {
        patientForm["Disease"] = othDisease!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Disease"),
    );

    final submitBtn = OutlinedButton(
        onPressed: () {
          if (formKeyNewSurveyorForm.currentState!.validate()) {
            formKeyNewSurveyorForm.currentState!.save();
          }
        },
        child: Text('Submit'));

    final diseaseBtn = ElevatedButton(
        onPressed: () async {
          _showMultiSelect(context);
        },
        child: Text('Other'));

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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: diseasesDropdown!,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: Common.allPadding(mHeight: height),
                    child: diseaseBtn,
                  ),
                )
                //Visibility(visible: false, child: otherDisease)
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
