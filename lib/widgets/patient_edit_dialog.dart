import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';

import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/functions.dart';

import 'DropDownWidget.dart';
import 'common.dart';

class PatientEditDialog extends StatefulWidget {
  final Patient patient;

  PatientEditDialog({Key? key, required this.patient}) : super(key: key);

  @override
  _PatientEditDialogState createState() => _PatientEditDialogState();
}

class _PatientEditDialogState extends State<PatientEditDialog> {
  final _multiKey = GlobalKey<DropdownSearchState<String>>();
  final _formKey = GlobalKey<FormState>();
  AdminFirebaseService _firebaseService = AdminFirebaseService();

  var width, height;
  String _selectedDate = formatDate(DateTime.now().toString());
  bool _switchValue = false;

  Map<String, dynamic> patientForm = {};
  List<Disease> _diseaseData = [];
  List<String> _diseaseList = [];
  List<int> ages = generateN2MList(15, 100);
  bool isMember = false;
  bool isKids = false;

  DropDownButtonWidget? ageDropDown;
  DropDownButtonWidget? genderDropDown;
  DropDownButtonWidget? professionDropDown;
  DropDownButtonWidget? bloodGroupsDropDown;
  DropDownButtonWidget? kidsCountDropDown;

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

  var bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-',
  ];

  var kidsCount = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
  ];

  Future<Response> onPressedSubmit() async {
    Response response;

    if (_formKey.currentState!.validate()) {
      // print(widget.patient.toString() + "\npatient that is selected 61");
      // print('$patientForm' + 'Patient form before');
      // print('in if of form valid 62');
      patientForm['id'] = widget.patient.id;
      // print(widget.patient.id);
      patientForm['date'] = _selectedDate;
      // print(_selectedDate);
      patientForm['surveyorUID'] = widget.patient.surveyorUID;
      // print(_selectedDate);
      patientForm['age'] = ageDropDown!.selectedItem!;
      patientForm['gender'] = genderDropDown!.selectedItem!;
      patientForm['profession'] = professionDropDown!.selectedItem!;
      patientForm['village'] = widget.patient.village;
      patientForm['timestamp'] = widget.patient.timestamp;
      patientForm['isMember'] = isMember;
      patientForm['bloodGroup'] = bloodGroupsDropDown!.selectedItem!;
      patientForm['isKids'] = isKids;
      patientForm['kidsCount'] = kidsCountDropDown!.selectedItem ?? 0;
      _formKey.currentState!.save();
      // print('$patientForm' + 'Patient form after');

      // print('in if of form saved 69');
      Patient patientData = Patient.fromMap(patientForm);
      // print('in if of form patient assigned');

      print("patientData $patientData");
      response = await _firebaseService.updatePatient(patientData);
      // print('in if of form after fetching from firebase 95');
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

  onChangeOfIsMember(bool changedVal) {
    this.isMember = changedVal;
    setState(() {});
  }

  onChangeOfIsKids(bool changedVal) {
    this.isKids = changedVal;
    if (!changedVal) {
      kidsCountDropDown!.selectedItem = null;
    }
    setState(() {});
  }

  @override
  void initState() {
    isMember = widget.patient.isMember;
    isKids = widget.patient.isKids ?? false;

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

    bloodGroupsDropDown = DropDownButtonWidget(
      items: bloodGroups,
      name: 'Blood Groups',
      selectedItem: widget.patient.bloodGroup,
    );
    kidsCountDropDown = DropDownButtonWidget(
      items: kidsCount,
      name: 'Kids Count',
      selectedItem: widget.patient.kidsCount.toString(),
    );

    getAllDisease();
    super.initState();
  }

  getAllDisease() async {
    _diseaseData = await _firebaseService.getAllDiseases();
    _diseaseList = _diseaseData.map((e) => e.name).toSet().toList();
    setState(() {});
  }

  onDiseaseSaved(diseaseSave) {
    print("diseaseSave :: $diseaseSave");
    patientForm['diseases'] = diseaseSave ?? widget.patient.diseases;
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
      keyboardType: TextInputType.text,
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
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Mobile Number"),
    );
    final aadhaarNo = TextFormField(
      initialValue: widget.patient.aadhaarNumber,
      keyboardType: TextInputType.number,
      validator: (aadhaarNo) => aadhaarNumberValidator(aadhaarNo!),
      autofocus: false,
      onSaved: (aadhaarNo) {
        patientForm["aadhaarNumber"] = aadhaarNo!;
      },
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Aadhaar Number"),
    );

    final bootNo = TextFormField(
      initialValue: widget.patient.bootNo,
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (bootNo) {
        patientForm["bootNo"] = bootNo!;
      },
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Boot No./Ward No"),
    );

    final isMemberListTile = CheckboxListTile(
        title: Text("Already a member?"),
        value: isMember,
        onChanged: (value) => onChangeOfIsMember(value!));

    final otherDiseaseInput = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (othDisease) {
        patientForm["diseases"] = othDisease!;
      },
      decoration: Common.textFormFieldInputDecoration(labelText: "Disease"),
    );

    final diseaseSwitch = CupertinoSwitch(
      value: _switchValue,
      onChanged: (value) {
        setState(() {
          _switchValue = value;
        });
      },
    );

    final kidsSwitch = CupertinoSwitch(
      value: isKids,
      onChanged: (value) {
        onChangeOfIsKids(value);
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
              Padding(
                padding: Common.allPadding(mHeight: height),
                child: aadhaarNo,
              ),
              Padding(
                padding: Common.allPadding(mHeight: height),
                child: bootNo,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Padding(
                      padding: Common.allPadding(mHeight: height),
                      child: bloodGroupsDropDown!,
                    ),
                  ),
                ],
              ),
              //kids Switch section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    flex: isKids ? 2 : 3,
                    child: Text("Do you have kids ?"),
                  ),
                  Flexible(
                    flex: isKids ? 2 : 3,
                    child: Padding(
                      padding: Common.allPadding(mHeight: height),
                      child: kidsSwitch,
                    ),
                  ),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: Common.allPadding(mHeight: height),
                      child: Visibility(
                          visible: isKids, child: kidsCountDropDown!),
                    ),
                  )
                ],
              ),
              //end kids switch section
              Padding(
                padding: Common.allPadding(mHeight: height),
                child: isMemberListTile,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(0),
                      child: multipleSelectionDropdown(),
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
      onSaved: (onSaved) {
        onDiseaseSaved(onSaved);
      },
      selectedItems: List<String>.from(widget.patient.diseases),
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
