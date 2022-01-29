import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/data_table_widget.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

import 'main/components/side_menu.dart';

class SurveyorListForUpdate extends StatefulWidget {
  const SurveyorListForUpdate({Key? key}) : super(key: key);

  @override
  _SurveyorListForUpdateState createState() => _SurveyorListForUpdateState();
}

class _SurveyorListForUpdateState extends State<SurveyorListForUpdate> {
  var width, height;
  DataTableWithGivenColumn? dataTableWithGivenColumn;
  List<Surveyor>? listOfSurveyor;
  AdminFirebaseService _firebaseService = AdminFirebaseService();

  List<String> columnsOfDataTable = ['Email', 'First Name', 'Middle Name', 'Last Name'];

  getSurveyorsList() async {
    listOfSurveyor = await _firebaseService.getSurveyors();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getSurveyorsList();

  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                TopSliverAppBar(mHeight: height, text: "Surveyor List"),
                CustomScrollViewBody(
                    bodyWidget: Padding(
                  padding: Common.allPadding(mHeight: height),
                  child: listOfSurveyor != null
                      ? body()
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    dataTableWithGivenColumn = DataTableWithGivenColumn(
      columns: columnsOfDataTable ,
      records: listOfSurveyor ?? [],
    );
    return Column(
      children: [dataTableWithGivenColumn!],
    );
  }
}
