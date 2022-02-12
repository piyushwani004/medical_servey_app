import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/Services/Admin/pdf_genrate_service.dart';
import 'package:medical_servey_app/models/common/pdf_model.dart';
import 'package:medical_servey_app/models/common/villageData.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/data_table_pateint_widget.dart';
import 'package:medical_servey_app/widgets/loading.dart';
import 'package:medical_servey_app/widgets/search_field.dart';
import 'package:medical_servey_app/widgets/patient_edit_dialog.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

import 'main/components/side_menu.dart';

class PatientUpdateAdminForUpdate extends StatefulWidget {
  const PatientUpdateAdminForUpdate({Key? key}) : super(key: key);

  @override
  _PatientListForUpdateState createState() => _PatientListForUpdateState();
}

class _PatientListForUpdateState extends State<PatientUpdateAdminForUpdate> {
  var width, height;
  DataTableWithGivenColumnForPatient? dataTableWithGivenColumn;
  List<Patient>? listOfPatient;
  List<Patient>? listOfFilteredPatient;
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<State> patientListKey = GlobalKey<State>();
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  Loading? _loading;
  final scaffoldState = GlobalKey<ScaffoldState>();

  DropdownSearch<String>? villageDropDown;
  String? villageChanged;

  List<VillageData> villageData = [];
  List<String> villages = [];
  List<String> columnsOfDataTable = [
    'id',
    'Village',
    'Email',
    'First-Name',
    'Middle-Name',
    'Last-Name',
    'Age',
    'Gender',
    'Address',
    'Profession',
    'Mobile-Number',
    'Diseases',
  ];

  Future<void> fetchDataFromJson() async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString(JSON_PATH);
    List body = json.decode(data)['Sheet1'];
    setState(() {
      villageData = body.map((e) => VillageData.fromMap(e)).toList();
      villages = villageData.map((e) => e.village).toSet().toList();
    });
  }

  Stream<List<Patient>> getPatientsList() async* {
    List<Patient> listOfPatient = await _firebaseService.getPatients();
    this.listOfPatient = listOfPatient;
    yield listOfPatient;
    // setState(() {});
  }

  onSearchBtnPressed() {
    print(_textEditingController.text);
    String searchText = _textEditingController.text;
    listOfFilteredPatient = listOfPatient
        ?.where((Patient patient) =>
            patient.firstName.contains(searchText) ||
            patient.middleName.contains(searchText) ||
            patient.lastName.contains(searchText) ||
            patient.email.contains(searchText) ||
            patient.mobileNumber.contains(searchText) ||
            patient.address.contains(searchText) ||
            patient.gender.contains(searchText) ||
            patient.id.contains(searchText) ||
            patient.profession.contains(searchText))
        .toList();
    setState(() {});
  }

  onVillageAndTalukaSort(village) {
    listOfFilteredPatient = listOfPatient
        ?.where(
          (Patient patient) => patient.village.contains(village),
        )
        .toList();
    setState(() {});
  }

  onSearchCrossBtnPressed() {
    listOfFilteredPatient = null;
    setState(() {});
  }

  onUpdatePressed() async {
    if (dataTableWithGivenColumn!.selectedRecords.isNotEmpty &&
        dataTableWithGivenColumn!.selectedRecords.length == 1) {
      // print(dataTableWithGivenColumn!.selectedRecords);
      await showDialog(
          context: context,
          builder: (context) => PatientEditDialog(
              patient: dataTableWithGivenColumn!.selectedRecords[0]));

      setState(() {});
    } else {
      Common.showAlert(
          context: context,
          title: 'Patient Edit',
          content: dataTableWithGivenColumn!.selectedRecords.isEmpty
              ? 'Please select a Patient'
              : 'Cannot edit multiple at a time',
          isError: true);
    }
  }

  onVillageChanged(villageSave) {
    print("villageSave :: $villageSave");
    if (villageSave == null) {
      listOfFilteredPatient = null;
      setState(() {});
    } else {
      onVillageAndTalukaSort(villageSave);
    }
  }

  onPDFSavePressed() async {
    final patientData = PdfModel(
      patientLst: this.listOfPatient,
    );
    await PdfInvoiceApi.generatePatientData(patientData);
  }

  @override
  void initState() {
    fetchDataFromJson();
    _loading = Loading(context: context, key: patientListKey);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    villageDropDown = DropdownSearch<String>(
      mode: Mode.DIALOG,
      showSearchBox: true,
      items: villages,
      showSelectedItems: true,
      //onSaved: (save) {},
      dropdownSearchDecoration:
          Common.textFormFieldInputDecoration(labelText: "Select Village"),
      onChanged: (saved) => onVillageChanged(saved),
      showClearButton: true,
      validator: (v) => v == null ? "required field" : null,
    );

    return Scaffold(
      key: scaffoldState,
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
                TopSliverAppBar(mHeight: height, text: "Patient List"),
                CustomScrollViewBody(
                    bodyWidget: Padding(
                        padding: Common.allPadding(mHeight: height),
                        child: body()))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 2,
              child: SearchField(
                controller: _textEditingController,
                onSearchTap: () {
                  onSearchBtnPressed();
                },
                onCrossTap: () {
                  onSearchCrossBtnPressed();
                },
                isCrossVisible: listOfFilteredPatient != null,
              ),
            ),
            Flexible(
              child: Padding(
                padding: Common.allPadding(mHeight: height),
                child: villageDropDown!,
              ),
            ),
            IconButton(
              onPressed: () async {
                onPDFSavePressed();
              },
              icon: Icon(Icons.save),
            ),
            IconButton(
                onPressed: () async {
                  await onUpdatePressed();
                },
                icon: Icon(Icons.edit)),
            IconButton(onPressed: () {}, icon: Icon(Icons.delete_forever))
          ],
        ),
        Scrollbar(
          isAlwaysShown: true,
          controller: _verticalScrollController,
          child: SingleChildScrollView(
            controller: _verticalScrollController,
            scrollDirection: Axis.vertical,
            child: Scrollbar(
              isAlwaysShown: true,
              controller: _horizontalScrollController,
              child: SingleChildScrollView(
                controller: _horizontalScrollController,
                scrollDirection: Axis.horizontal,
                child: Card(
                    elevation: 10,
                    child: StreamBuilder<List<Patient>>(
                        stream: getPatientsList(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            dataTableWithGivenColumn =
                                DataTableWithGivenColumnForPatient(
                              columns: columnsOfDataTable,
                              records: listOfFilteredPatient ?? snapshot.data!,
                            );
                            print(dataTableWithGivenColumn?.selectedRecords);
                          }
                          return snapshot.hasData
                              ? dataTableWithGivenColumn!
                              : Center(
                                  child: CircularProgressIndicator(),
                                );
                        })),
              ),
            ),
          ),
        )
      ],
    );
  }
}
