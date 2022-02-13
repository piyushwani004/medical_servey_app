import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/models/common/villageData.dart';
import 'package:medical_servey_app/pages/Admin/main/components/side_menu.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class GenerateReport extends StatefulWidget {
  const GenerateReport({Key? key}) : super(key: key);

  @override
  _GenerateReportState createState() => _GenerateReportState();
}

class _GenerateReportState extends State<GenerateReport> {
  var width, height;
  List<VillageData> villageData = [];
  List<String> villages = [];
  List<String> taluka = [];

  Future<void> fetchDataFromJson() async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString(JSON_PATH);
    List body = json.decode(data)['Sheet1'];
    setState(() {
      villageData = body.map((e) => VillageData.fromMap(e)).toList();
      villages = villageData.map((e) => e.village).toSet().toList();
      taluka = villageData.map((e) => e.taluka).toSet().toList();
    });
  }

  onVillageChanged(village) {
    print("village $village");
  }

  onTalukaChanged(taluka) {
    print("village $taluka");
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
          ],
        )
      ],
    );
  }
}
