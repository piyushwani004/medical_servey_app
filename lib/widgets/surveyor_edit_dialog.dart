import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/utils/functions.dart';

import 'DropDownWidget.dart';
import 'common.dart';
import 'loading.dart';

class SurveyorEditDialog extends StatefulWidget {
  final Surveyor surveyor;

  SurveyorEditDialog({Key? key, required this.surveyor}) : super(key: key);

  @override
  _SurveyorEditDialogState createState() => _SurveyorEditDialogState();
}

class _SurveyorEditDialogState extends State<SurveyorEditDialog> {
  String? selectedDate;
  Map<String, String> surveyorForm = {};
  final formKey = GlobalKey<FormState>();
  final GlobalKey<State> surveyorEditKey = GlobalKey<State>();
  Loading? _loading;
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? qualificationDropDown;
  DropDownButtonWidget? villageToAssign;

  // List of items in our dropdown menu
  List<int> ageList = generateN2MList(15, 100);
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

  Future<Response> onConfirmBtnPressed() async {
    if (formKey.currentState!.validate()) {
      //turning loading on
      // _loading!.on(); //invoking login
      surveyorForm['joiningDate'] = selectedDate!;
      surveyorForm['age'] = ageDropDown!.selectedItem!;
      surveyorForm['gender'] = genderDropDown!.selectedItem!;
      surveyorForm['profession'] = qualificationDropDown!.selectedItem!;
      surveyorForm['villageToAssign'] = villageToAssign!.selectedItem!;
      formKey.currentState!.save();
      Surveyor surveyor = Surveyor.fromMap(surveyorForm);
      Response isUpdate = await _firebaseService.updateSurveyor(surveyor);

      if (isUpdate.isSuccessful) {
        await Common.showAlert(
            context: context,
            title: 'Surveyor Update',
            content: isUpdate.message,
            isError: false);
        return isUpdate;
      } else {
        await Common.showAlert(
            context: context,
            title: 'Surveyor Update',
            content: isUpdate.message,
            isError: true);
        return isUpdate;
      }
    }else{
      Common.showAlert(
          context: context,
          title: 'Surveyor Update',
          content: 'Incorrect Values',
          isError: true);
      return Response(isSuccessful: false, message: 'Incorrect Values');
    }
  }

  @override
  void initState() {
    _loading = Loading(key: surveyorEditKey, context: context);
    selectedDate = formatDate(widget.surveyor.joiningDate);
    // assigning dropdowns
    ageDropDown = DropDownButtonWidget(
      selectedItem: widget.surveyor.age.toString(),
      items: ageList.map((age) => age.toString()).toList(),
      name: 'Age',
    );
    genderDropDown = DropDownButtonWidget(
      selectedItem: widget.surveyor.gender,
      items: genders,
      name: 'Gender',
    );
    qualificationDropDown = DropDownButtonWidget(
      selectedItem: widget.surveyor.profession,
      items: qualifications,
      name: 'Qualification',
    );
    villageToAssign = DropDownButtonWidget(
      selectedItem: widget.surveyor.villageToAssign,
      items: villages,
      name: 'Village To Assign',
    );

    _loading = Loading(context: context, key: surveyorEditKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    final fullName = TextFormField(
      initialValue:
          "${widget.surveyor.firstName} ${widget.surveyor.middleName} ${widget.surveyor.lastName} ",
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
        surveyorForm["firstName"] = splitName[0];
        surveyorForm["middleName"] = splitName[1];
        surveyorForm["lastName"] = splitName[2];
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
    );

    final email = TextFormField(
      initialValue: '${widget.surveyor.email}',
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      enabled: false,
      validator: (email) => emailValidator(email!),
      onSaved: (email) {
        surveyorForm["email"] = email!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );
    final address = TextFormField(
      initialValue: '${widget.surveyor.address}',
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (address) {
        surveyorForm["address"] = address!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Address"),
    );
    final mobileNo = TextFormField(
      initialValue: '${widget.surveyor.mobileNumber}',
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
      initialValue: '${widget.surveyor.aadhaarNumber}',
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
    return AlertDialog(
      scrollable: true,
      title: Text('Edit Surveyor'),
      content: Form(
          key: formKey,
          child: Row(
            children: [
              Expanded(
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
                                    child: Text(
                                      selectedDate ==
                                              formatDate(
                                                  DateTime.now().toString())
                                          ? "Today"
                                          : selectedDate.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 5),
                                    )),
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
                  ],
                ),
              ),
            ],
          )),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            Response res = await onConfirmBtnPressed();
            print(res.isSuccessful);
            if(res.isSuccessful){
              Navigator.pop(context);
            }
          },
          child: Text('Confirm'),
        ),
      ],
    );
    ;
  }
}
