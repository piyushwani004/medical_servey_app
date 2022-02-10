import 'dart:convert';


import "package:flutter/material.dart";
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/common/villageData.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/form_container.dart';
import 'package:medical_servey_app/widgets/loading.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'main/components/side_menu.dart';

class NewSurveyorForm extends StatefulWidget {
  const NewSurveyorForm({Key? key}) : super(key: key);

  @override
  _NewSurveyorFormState createState() => _NewSurveyorFormState();
}

class _NewSurveyorFormState extends State<NewSurveyorForm> {
  String selectedDate = formatDate(DateTime.now().toString());
  Map<String, dynamic> surveyorForm = {};

  final _multiKey = GlobalKey<DropdownSearchState<String>>();
  final formKeyNewSurveyorForm = GlobalKey<FormState>();
  final GlobalKey<State> newSurveyorKey = GlobalKey<State>();

  Loading? _loading;
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? qualificationDropDown;

  DropdownSearch<String>? districtDropDown;
  DropdownSearch<String>? talukaDropDown;

  onPressedSubmit() async {
    print("surveyorStart");
    print("surveyorForm $surveyorForm");
    if (formKeyNewSurveyorForm.currentState!.validate()) {
      // //turning loading on
      // _loading!.on(); //invoking login
      surveyorForm['joiningDate'] = selectedDate;
      surveyorForm['age'] = ageDropDown!.selectedItem!;
      surveyorForm['gender'] = genderDropDown!.selectedItem!;
      surveyorForm['profession'] = qualificationDropDown!.selectedItem!;

      formKeyNewSurveyorForm.currentState!.save();

      print("surveyorForm $surveyorForm");
      Surveyor surveyor = Surveyor.fromMap(surveyorForm);
      print(surveyor);
      //creating account for surveyor
      Response responseForCreatingAcc =
          await _firebaseService.createSurveyorAccount(surveyor);
      print("Firestore Response for  ::" +
          responseForCreatingAcc.toString());

      //if successfully created then try to push details to fire store
      if (responseForCreatingAcc.isSuccessful) {
        Response response = await _firebaseService.saveNewSurveyor(surveyor);
        if (response.isSuccessful) {
          // if successfully return  a message that process is complete
          // _loading!.off(); // popping loading
          Common.showAlert(
              context: context,
              title: 'Surveyor Registration',
              content: response.message,
              isError: false);
          // isLoading = false;

        } else {
          //if failed while creating an account
          // _loading!.off(); // popping loading
          Common.showAlert(
              context: context,
              title: 'Failed in Creating Account',
              content: response.message,
              isError: true);
          // isLoading = false;
        }
        print("Firestore Response ::" + response.message.toString());
      } else {
        //if failed while creating an account
        // _loading!.off(); // popping loading
        Common.showAlert(
            context: context,
            title: 'Failed in Creating Account',
            content: responseForCreatingAcc.message,
            isError: true);
        // isLoading = false;
        print(responseForCreatingAcc.message);
      }
    }
  }

  // List of items in our dropdown menu
  List<int> ageList = generateN2MList(15, 100);
  List<VillageData> villageData = [];
  List<String> taluka = [];
  List<String> villages = [];
  var district = [
    'Jalgaon',
  ];

  var genders = [
    'Male',
    'Female',
    'Intersex',
  ];
  var qualifications = [
    'No formal education',
    'Primary education',
    'Secondary education or high school',
    'GED',
    'Vocational qualification',
    'Diploma',
    'Bachelors degree',
    'Masters degree',
    'Doctorate or higher'
  ];
  var width, height;

  Future<void> fetchDataFromJson() async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString(JSON_PATH);
    List body = json.decode(data)['Sheet1'];
    setState(() {
      villageData = body.map((e) => VillageData.fromMap(e)).toList();
      taluka = villageData.map((e) => e.taluka).toSet().toList();
      villages = villageData.map((e) => e.village).toSet().toList();
    });
  }

  @override
  void initState() {
    fetchDataFromJson();
    print("List<VillageData> ${villageData.length}");
    print("taluka ${taluka.length}");
    print("villages ${villages.length}");
    print("object");
    ageDropDown = DropDownButtonWidget(
      items: ageList.map((age) => age.toString()).toList(),
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

    districtDropDown = DropdownSearch<String>(
      items: district,
      mode: Mode.MENU,
      onSaved: (districtSaved) => onDistrictSaved(districtSaved),
      dropdownSearchDecoration:
          Common.textFormFieldInputDecoration(labelText: "Select District"),
      selectedItem: district.first,
      validator: (v) => v == null ? "required field" : null,
    );

    _loading = Loading(context: context, key: newSurveyorKey);

    super.initState();
  }

  onTalukaSaved(saved) {
    surveyorForm['taluka'] = saved;
  }

  onVllageSaved(villageSave) {
    print("villageSave :: $villageSave");
    surveyorForm['village'] = villageSave;
  }

  onDistrictSaved(districtSaved) {
    surveyorForm['district'] = districtSaved;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    //searchable dropdown widgets
    talukaDropDown = DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSearchBox: true,
      items: taluka,
      showSelectedItems: true,
      onSaved: (saved) => onTalukaSaved(saved),
      dropdownSearchDecoration:
          Common.textFormFieldInputDecoration(labelText: "Select Taluka"),
      onChanged: print,
      showClearButton: true,
      validator: (v) => v == null ? "required field" : null,
    );

    //

    return Scaffold(
      backgroundColor: scafoldbBackgroundColor,
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

  Widget body({required Map<String, dynamic> surveyorForm, required formKey}) {
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
        surveyorForm["firstName"] = splitName[0];
        surveyorForm["middleName"] = splitName[1];
        surveyorForm["lastName"] = splitName[2];
      },
      decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (email) => emailValidator(email!),
      onSaved: (email) {
        surveyorForm["email"] = email!;
      },
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );
    final address = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (address) {
        surveyorForm["address"] = address!;
      },
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
        surveyorForm["aadhaarNumber"] = aadhaarNo!;
      },
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
                              child: Text(
                                selectedDate ==
                                        formatDate(DateTime.now().toString())
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
              //
              taluka.isNotEmpty && villages.isNotEmpty
                  ? Responsive(mobile: mobileView(), desktop: desktopView())
                  : CircularProgressIndicator(),
              //
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

  Widget mobileView() {
    return Column(
      children: [
        Padding(
          padding: Common.allPadding(mHeight: height),
          child: districtDropDown!,
        ),
        SizedBox(
          width: width * 0.01,
        ),
        Padding(
          padding: Common.allPadding(mHeight: height),
          child: talukaDropDown!,
        ),
        SizedBox(
          width: width * 0.01,
        ),
        Padding(
          padding: Common.allPadding(mHeight: height),
          child: multipleSelectionDropdown(),
        ),
      ],
    );
  }

  Widget desktopView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Padding(
          padding: Common.allPadding(mHeight: height),
          child: districtDropDown!,
        )),
        SizedBox(
          width: width * 0.01,
        ),
        Expanded(
            child: Padding(
          padding: Common.allPadding(mHeight: height),
          child: talukaDropDown!,
        )),
        SizedBox(
          width: width * 0.01,
        ),
        Expanded(
            child: Padding(
          padding: Common.allPadding(mHeight: height),
          child: multipleSelectionDropdown(),
        )),
      ],
    );
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
      dropdownSearchDecoration:
          Common.textFormFieldInputDecoration(labelText: "Select Villages"),
      mode: Mode.DIALOG,
      showSelectedItems: true,
      // onSaved: (villageSave) => onVllageSaved(villageSave),
      items: villages,
      showClearButton: true,
      onChanged: (onSaved) {
        onVllageSaved(onSaved);
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
