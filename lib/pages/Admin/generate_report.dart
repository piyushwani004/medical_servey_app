import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/Services/Admin/pdf_genrate_service.dart';
import 'package:medical_servey_app/models/Admin/disease_report.dart';
import 'package:medical_servey_app/models/common/pdf_model.dart';
import 'package:medical_servey_app/models/common/villageData.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/pages/Admin/main/components/side_menu.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

import '../../Services/Admin/disease_percentage_calculate_service.dart';

class GenerateReport extends StatefulWidget {
  const GenerateReport({Key? key}) : super(key: key);

  @override
  _GenerateReportState createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  DiseasePercentageCalculateService diseasePercentageCalculateService =
      DiseasePercentageCalculateService();
  AdminFirebaseService adminFirebaseService = AdminFirebaseService();
  final _multiKeyTaluka = GlobalKey<DropdownSearchState<String>>();
  final _multiKeyVillage = GlobalKey<DropdownSearchState<String>>();

  var width, height;
  List<DiseaseReportModel>? reportLst = [];
  Map<String, String> info = {};

  List<VillageData> villageData = [];
  List<String> villages = [];
  List<String> taluka = [];

  List<Patient> patientList = [];

  List<String>? selectedTaluka;
  List<String>? selectedVillage;

  Future<void> fetchDataFromJson() async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString(JSON_PATH);
    List body = json.decode(data)['Sheet1'];
    setState(() {
      villageData = body.map((e) => VillageData.fromMap(e)).toList();
      taluka = villageData.map((e) => e.taluka).toSet().toList();
    });
  }

  onVillageChanged(village) async {
    patientList.clear();
    print("village $village");
    selectedVillage = village;
    if (selectedVillage != null && selectedVillage!.isNotEmpty) {
      for (var item in village) {
        patientList.addAll(
          await adminFirebaseService.getPatientsByKeys(
            key: "village",
            value: item,
          ),
        );
      }
      print("patient sort by village Size : ${patientList.length}");
    } else {
      if (selectedTaluka != null && selectedTaluka!.isNotEmpty) {
        for (var item in selectedTaluka!) {
          patientList.addAll(
            await adminFirebaseService.getPatientsByKeys(
              key: "taluka",
              value: item,
            ),
          );
        }
      }
    }
    setState(() {});
  }

  onTalukaChanged(talukaChanged) async {
    patientList.clear();
    selectedTaluka = talukaChanged;
    if (selectedTaluka != null && selectedTaluka!.isNotEmpty) {
      villages.clear();
      setState(() {
        for (String item in selectedTaluka!) {
          String village = item;
          villages.addAll(
            villageData
                .map((e) {
                  if (item == e.taluka) {
                    village = e.village;
                  }
                  return village;
                })
                .toSet()
                .toList(),
          );
        }
      });
      for (var item in selectedTaluka!) {
        patientList.addAll(await adminFirebaseService.getPatientsByKeys(
          key: "taluka",
          value: item,
        ));
      }
      print("patient sort by taluka Size : ${patientList.length}");
    } else {
      patientList.clear();
    }

    setState(() {});
  }

  onPDFSavePressed() async {
    final reportData = PdfModel(
      reportLst: this.reportLst,
    );

    info[DATE] = DateTime.now().toString();
    info[SELECTEDVILLAGE] = selectedVillage.toString();
    info[SELECTEDTALUKA] = selectedTaluka.toString();
    info[SELECTEDDISTRICT] = DISTRICT;
    await PdfInvoiceApi.generateReportData(
      report: reportData,
      info: info,
    );
  }

  Stream<List<DiseaseReportModel>> calculatePercentageOfSelectedPatients(
      List<Patient> patients) async* {
    List<DiseaseReportModel> result = [];
    Map<String, double> freqDisease = {};

    int totalPatients;
    //getting count of total patients
    totalPatients = patients.length;
    //calculating freq
    for (Patient pat in patients) {
      for (String dis in pat.diseases) {
        //if freq has disease name increase its count
        if ((freqDisease.keys.toList()).contains(dis)) {
          freqDisease[dis] = (freqDisease[dis]! + 1);
        } else {
          ////if freq don't have disease name init its count to 1
          freqDisease[dis] = 1;
        }
      }
      // listOfDisease.addAll(pat.diseases);
    }
    print("$freqDisease --freqDisease");

    this.reportLst = freqDisease.entries
        .map(
          (entry) => DiseaseReportModel(
            diseaseName: entry.key,
            diseasePercentage: (entry.value / totalPatients) * 100,
            patientCount: int.parse(
              entry.value.toString(),
            ),
          ),
        )
        .toList();
    result = this.reportLst!;

    print("$result --report List");

    yield result;
  }

  @override
  void initState() {
    fetchDataFromJson();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                TopSliverAppBar(mHeight: height, text: "Report"),
                CustomScrollViewBody(
                    bodyWidget: Padding(
                        padding: Common.allPadding(mHeight: height),
                        child: body(width, height)))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body(width, height) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(
              flex: 3,
              child: Padding(
                padding: Common.allPadding(mHeight: height),
                child: multipleSelectionDropdownTaluka(),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: Common.allPadding(mHeight: height),
                child: multipleSelectionDropdownVillage(),
              ),
            ),
            Flexible(
              child: IconButton(
                tooltip: "Save PDF",
                onPressed: () async {
                  onPDFSavePressed();
                },
                icon: Icon(Icons.save),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.all(defaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<List<DiseaseReportModel>>(
                stream: calculatePercentageOfSelectedPatients(patientList),
                // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<List<DiseaseReportModel>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      Text(
                        "${selectedTaluka != null && selectedTaluka!.isNotEmpty ? selectedTaluka : ""}${selectedVillage != null && selectedVillage!.isNotEmpty ? " [$selectedVillage]" : ""} Diseases Report",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            double? per =
                                snapshot.data![index].diseasePercentage;
                            String dis = snapshot.data![index].diseaseName;
                            int patCnt = snapshot.data![index].patientCount;
                            return Row(
                              children: [
                                Expanded(
                                  child: Card(
                                    child: Padding(
                                      padding:
                                          Common.allPadding(mHeight: height),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(child: Text(dis)),
                                          Expanded(
                                              child: Text(patCnt.toString() +
                                                  " patients")),
                                          Flexible(
                                              child: Text(
                                                  '${per.toStringAsFixed(2)}%')),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          })
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 60,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text('Error: ${snapshot.error}'),
                      )
                    ];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      )
                    ];
                  }
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: children,
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget multipleSelectionDropdownTaluka() {
    return DropdownSearch<String>.multiSelection(
      key: _multiKeyTaluka,
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
                      _multiKeyTaluka.currentState?.removeItem(i);
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
                    _multiKeyTaluka.currentState?.closeDropDownSearch();
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
                    _multiKeyTaluka.currentState?.popupDeselectAllItems();
                  },
                  child: const Text('None'),
                ),
              ),
            ),
          ],
        );
      },
      dropdownSearchDecoration:
          Common.textFormFieldInputDecoration(labelText: "Select Taluka"),
      mode: Mode.DIALOG,
      showSelectedItems: true,
      // onSaved: (villageSave) => onVllageSaved(villageSave),
      items: taluka,
      showClearButton: true,
      onChanged: (saved) => onTalukaChanged(saved),
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

  Widget multipleSelectionDropdownVillage() {
    return DropdownSearch<String>.multiSelection(
      key: _multiKeyVillage,
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
                      _multiKeyVillage.currentState?.removeItem(i);
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
                    _multiKeyVillage.currentState?.closeDropDownSearch();
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
                    _multiKeyVillage.currentState?.popupDeselectAllItems();
                  },
                  child: const Text('None'),
                ),
              ),
            ),
          ],
        );
      },
      dropdownSearchDecoration:
          Common.textFormFieldInputDecoration(labelText: "Select Village"),
      mode: Mode.DIALOG,
      showSelectedItems: true,
      // onSaved: (villageSave) => onVllageSaved(villageSave),
      items: villages,
      showClearButton: true,
      onChanged: (saved) => onVillageChanged(saved),
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
