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

  var width, height;
  List<DiseaseReportModel>? reportLst = [];
  Map<String, String> info = {};
  List<VillageData> villageData = [];
  List<String> villages = [];
  List<String> taluka = [];
  List<Patient> patientList = [];
  String? selectedTaluka;
  String? selectedVillage;

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
    print("village $village");
    selectedVillage = village;
    if (village != null) {
      patientList = await adminFirebaseService.getPatientsByKeys(
        key: "village",
        value: village,
      );
      print("patient sort by village Size : ${patientList.length}");
    } else {
      if (selectedTaluka != null) {
        patientList = await adminFirebaseService.getPatientsByKeys(
          key: "taluka",
          value: selectedTaluka!,
        );
      }
    }
    setState(() {});
  }

  onTalukaChanged(talukaChanged) async {
    selectedTaluka = talukaChanged;
    if (talukaChanged != null) {
      setState(() {
        String village = talukaChanged;
        villages = villageData
            .map((e) {
              if (talukaChanged == e.taluka) {
                village = e.village;
              }
              return village;
            })
            .toSet()
            .toList();
      });
      patientList = await adminFirebaseService.getPatientsByKeys(
        key: "taluka",
        value: talukaChanged,
      );
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
    info[SELECTEDVILLAGE] = selectedVillage ?? "";
    info[SELECTEDTALUKA] = selectedTaluka ?? "";
    info[SELECTEDDISTRICT] = DISTRICT;
    await PdfInvoiceApi.generateReportData(
      report: reportData,
      info: info,
    );
  }

  Stream<Map<String, double>> calculatePercentageOfSelectedPatients(
      List<Patient> patients) async* {
    Map<String, double> freqDisease = {};
    Map<String, double> perDisease = {};
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

    //calculating percentage
    for (String dis in freqDisease.keys) {
      perDisease[dis] = (freqDisease[dis]! / totalPatients) * 100;
    }
    print("$perDisease --perDisease MAP");
    this.reportLst = perDisease.entries
        .map(
          (entry) => DiseaseReportModel(
            diseaseName: entry.key,
            diseasePercentage: entry.value,
          ),
        )
        .toList();
    print("${this.reportLst} --report List");

    yield perDisease;
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
                child: DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  items: taluka,
                  showSelectedItems: true,
                  dropdownSearchDecoration: Common.textFormFieldInputDecoration(
                      labelText: "Select Taluka"),
                  onChanged: (saved) => onTalukaChanged(saved),
                  showClearButton: true,
                  validator: (v) => v == null ? "required field" : null,
                ),
              ),
            ),
            Flexible(
              flex: 3,
              child: Padding(
                padding: Common.allPadding(mHeight: height),
                child: DropdownSearch<String>(
                  mode: Mode.DIALOG,
                  showSearchBox: true,
                  items: villages,
                  showSelectedItems: true,
                  dropdownSearchDecoration: Common.textFormFieldInputDecoration(
                      labelText: "Select Village"),
                  onChanged: (saved) => onVillageChanged(saved),
                  showClearButton: true,
                  validator: (v) => v == null ? "required field" : null,
                ),
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
              StreamBuilder<Map<String, double>>(
                stream: calculatePercentageOfSelectedPatients(patientList),
                // a previously-obtained Future<String> or null
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, double>> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      const Icon(
                        Icons.check_circle_outline,
                        color: Colors.green,
                        size: 60,
                      ),
                      Text(
                        "${selectedTaluka != null ? selectedTaluka : ""}${selectedVillage != null ? " [$selectedVillage]" : ""} Diseases Report",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black),
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: (snapshot.data?.keys)!.toList().length,
                          itemBuilder: (_, index) {
                            double? per = snapshot
                                .data?[(snapshot.data!.keys).toList()[index]];
                            String dis = (snapshot.data?.keys)!.toList()[index];
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
                                          Flexible(
                                              child: Text(
                                                  '${per?.toStringAsFixed(2)}%')),
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
}
