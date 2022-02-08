import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/utils/functions.dart';

import '../models/common/villageData.dart';
import '../utils/image_utils.dart';
import '../utils/responsive.dart';
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
  Map<String, dynamic> surveyorForm = {};
  final formKey = GlobalKey<FormState>();
  final GlobalKey<State> surveyorEditKey = GlobalKey<State>();
  final _multiKey = GlobalKey<DropdownSearchState<String>>();
  Loading? _loading;
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? qualificationDropDown;
  DropdownSearch<String>? districtDropDown;
  DropdownSearch<String>? talukaDropDown;

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

  Future<Response> onConfirmBtnPressed() async {
    if (formKey.currentState!.validate()) {
      //turning loading on
      // _loading!.on(); //invoking login
      surveyorForm['joiningDate'] = selectedDate!;
      surveyorForm['age'] = ageDropDown!.selectedItem!;
      surveyorForm['gender'] = genderDropDown!.selectedItem!;
      surveyorForm['profession'] = qualificationDropDown!.selectedItem!;
      formKey.currentState!.save();
      print("surveyorForm $surveyorForm");
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
    } else {
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
    fetchDataFromJson();
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

    districtDropDown = DropdownSearch<String>(
      items: district,
      mode: Mode.MENU,
      onSaved: (districtSaved) => onDistrictSaved(districtSaved),
      dropdownSearchDecoration:
      Common.textFormFieldInputDecoration(labelText: "Select District"),
      selectedItem: district.first,
      validator: (v) => v == null ? "required field" : null,
    );

    _loading = Loading(context: context, key: surveyorEditKey);
    super.initState();
  }


  onTalukaSaved(saved) {
    surveyorForm['taluka'] = saved;
  }

  onVillageSaved(villageSave) {
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
      selectedItem: widget.surveyor.taluka,
      items: taluka,
      showSelectedItems: true,
      onSaved: (saved) => onTalukaSaved(saved),
      dropdownSearchDecoration:
      Common.textFormFieldInputDecoration(labelText: "Select Taluka"),
      onChanged: print,
      showClearButton: true,
      validator: (v) => v == null ? "required field" : null,
    );

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
      readOnly: true,
      // enabled: false,
      onTap: () {
        Common.showAlert(
            context: context,
            title: "Invalid Operation",
            content: "Email cannot be edited",
            isError: true);
      },
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
        surveyorForm["aadhaarNumber"] = aadhaarNo!;
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
            if (res.isSuccessful) {
              Navigator.pop(context);
            }
          },
          child: Text('Confirm'),
        ),
      ],
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
      selectedItems: widget.surveyor.village,
      dropdownSearchDecoration:
      Common.textFormFieldInputDecoration(labelText: "Select Villages"),
      mode: Mode.DIALOG,
      showSelectedItems: true,
      // onSaved: (villageSave) => onVllageSaved(villageSave),
      items: villages,
      showClearButton: true,
      onChanged: (onSaved) {
        print('onsaveForVillage ${onSaved}');
        onVillageSaved(onSaved);
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
