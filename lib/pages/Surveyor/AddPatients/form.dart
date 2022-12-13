import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/widgets/DropDownWidget.dart';
import 'package:medical_servey_app/widgets/common.dart';

class UserForm extends StatefulWidget {
  final int patientId;
  final Patient patient;
  final String surveyorID;
  final String village;
  final String taluka;
  final List<String> diseaseList;
  var state = _UserFormState();
  final Function(UserForm) onDelete;

  UserForm({
    Key? key,
    required this.patientId,
    required this.patient,
    required this.surveyorID,
    required this.village,
    required this.taluka,
    required this.diseaseList,
    required this.onDelete,
  }) : super(key: key);
  // @override
  // _UserFormState createState() => state;

  @override
  _UserFormState createState() {
    return this.state = _UserFormState();
  }

  bool isValid() => state.validate();
}

class _UserFormState extends State<UserForm>
    with AutomaticKeepAliveClientMixin {
  final form = GlobalKey<FormState>();
  final _multiKey = GlobalKey<DropdownSearchState<String>>();

  var width, height;
  String _selectedDate = formatDate(DateTime.now().toString());
  bool _switchValue = false;

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

  onChangeOfIsMember(bool changedVal) {
    this.isMember = changedVal;
    setState(() {});
  }

  onChangeOfIsKids(bool changedVal) {
    this.isKids = changedVal;
    if (!changedVal) {
      kidsCountDropDown!.selectedItem = null;
    }
    widget.patient.isKids = this.isKids;
  }

  @override
  void initState() {
    ageDropDown = DropDownButtonWidget(
      items: ages.map((age) => age.toString()).toList(),
      name: 'Age',
      onSave: (save) {
        print("Age :" + save);
        widget.patient.age = int.parse(save);
      },
    );
    genderDropDown = DropDownButtonWidget(
      items: genders,
      name: 'Gender',
      onSave: (save) {
        widget.patient.gender = save;
      },
    );
    professionDropDown = DropDownButtonWidget(
      items: profession,
      name: 'Profession',
      onSave: (save) {
        widget.patient.profession = save;
      },
    );
    bloodGroupsDropDown = DropDownButtonWidget(
      items: bloodGroups,
      name: 'Blood Groups',
      onSave: (save) {
        widget.patient.bloodGroup = save;
      },
    );
    kidsCountDropDown = DropDownButtonWidget(
      items: kidsCount,
      selectedItem: kidsCount.first,
      name: 'Kids Count',
      onSave: (save) {
        widget.patient.kidsCount = int.parse(save);
      },
    );

    widget.patient.id = DateTime.now().millisecondsSinceEpoch.toString();
    widget.patient.date = _selectedDate;
    widget.patient.surveyorUID = widget.surveyorID;
    widget.patient.timestamp = Timestamp.fromDate(DateTime.now());
    widget.patient.village = widget.village;
    widget.patient.taluka = widget.taluka;

    super.initState();
  }

  String? otherDiseaseValidator(String? value) {
    if (_switchValue && value != null && value.isNotEmpty) {
      value = value.trim();
      return null;
    } else {
      return "Other Disease can't be empty";
    }
  }

  onDiseaseSaved(diseaseSave) {
    print("diseaseSave :: $diseaseSave");
    //patientForm['diseases'] = diseaseSave;
    widget.patient.diseases = diseaseSave;
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    final fullName = TextFormField(
      keyboardType: TextInputType.text,
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
        widget.patient.firstName = splitName[0];
        widget.patient.middleName = splitName[1];
        widget.patient.lastName = splitName[2];
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      validator: (email) => emailValidator(email!),
      onSaved: (email) {
        widget.patient.email = email!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );
    final address = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (address) {
        widget.patient.address = address!;
      },
      // validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Address"),
    );
    final mobileNo = TextFormField(
      keyboardType: TextInputType.number,
      autofocus: false,
      validator: (mobileNo) => mobileNumberValidator(mobileNo!),
      onSaved: (mobileNo) {
        widget.patient.mobileNumber = mobileNo!;
      },
      // validator: (email) => emailValidator(email!),
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Mobile Number"),
    );
    final otherDiseaseInput = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (othDisease) {
        widget.patient.otherDisease = othDisease!;
      },
      validator: (otherDisease) {
        return otherDiseaseValidator(otherDisease);
      },
      decoration: Common.textFormFieldInputDecoration(labelText: "Disease"),
    );
    final aadhaarNo = TextFormField(
      keyboardType: TextInputType.number,
      validator: (aadhaarNo) => aadhaarNumberValidator(aadhaarNo!),
      autofocus: false,
      onSaved: (aadhaarNo) {
        widget.patient.aadhaarNumber = aadhaarNo!;
      },
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Aadhaar Number"),
    );

    final bootNo = TextFormField(
      keyboardType: TextInputType.text,
      autofocus: false,
      onSaved: (bootNo) {
        widget.patient.bootNo = bootNo!;
      },
      decoration:
          Common.textFormFieldInputDecoration(labelText: "Boot No./Ward No"),
    );

    final isMemberListTile = CheckboxListTile(
      title: Text("Already a member?"),
      value: isMember,
      onChanged: (value) => onChangeOfIsMember(value!),
    );

    // final submitBtn = OutlinedButton(
    //   onPressed: () {
    //     //onPressedSubmit();
    //   },
    //   child: Text('Submit'),
    // );

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
        setState(() {
          onChangeOfIsKids(value);
        });
      },
    );

    return Padding(
      padding: EdgeInsets.all(16),
      child: Material(
        elevation: 1,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(8),
        child: Form(
          key: form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                leading: Icon(Icons.verified_user),
                elevation: 0,
                title: Text('Family Member ${widget.patientId + 1}'),
                backgroundColor: Theme.of(context).colorScheme.secondary,
                centerTitle: true,
                actions: <Widget>[
                  // IconButton(
                  //   icon: Icon(Icons.delete),
                  //   onPressed: () {
                  //     widget.onDelete(widget);
                  //   },
                  // )
                ],
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
                    padding: Common.allPadding(mHeight: height),
                    child: multipleSelectionDropdown(),
                  )),
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
        ),
      ),
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
      dropdownSearchDecoration: Common.textFormFieldInputDecoration(
        labelText: "Select Diseases",
      ),
      mode: Mode.DIALOG,
      showSelectedItems: true,
      // onSaved: (villageSave) => onVllageSaved(villageSave),
      items: widget.diseaseList,
      showClearButton: true,
      onChanged: (onSaved) {
        onDiseaseSaved(onSaved);
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

  ///form validator
  bool validate() {
    var valid = form.currentState!.validate();
    if (valid) form.currentState!.save();
    return valid;
  }

  @override
  bool get wantKeepAlive => true;
}
