import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/data_table_widget.dart';
import 'package:medical_servey_app/widgets/loading.dart';
import 'package:medical_servey_app/widgets/search_field.dart';
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
  List<Surveyor>? listOfFilteredSurveyor;
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<State> surveyorListKey = GlobalKey<State>();
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  Loading? _loading;
  List<String> columnsOfDataTable = [
    'Email',
    'First-Name',
    'Middle-Name',
    'Last-Name',
    'Age',
    'Gender',
    'Address',
    'Profession',
    'Joining-Date',
    'Assigned-Village',
  ];

  getSurveyorsList() async {
    listOfSurveyor = await _firebaseService.getSurveyors();
    setState(() {});
  }

  onSearchBtnPressed() {
    print(_textEditingController.text);
    String searchText = _textEditingController.text;
    listOfFilteredSurveyor = listOfSurveyor
        ?.where((Surveyor sur) =>
            sur.firstName.contains(searchText) ||
            sur.middleName.contains(searchText) ||
            sur.lastName.contains(searchText) ||
            sur.email.contains(searchText) ||
            sur.mobileNumber.contains(searchText) ||
            sur.address.contains(searchText) ||
            sur.gender.contains(searchText) ||
            sur.joiningDate.contains(searchText) ||
            sur.villageToAssign.contains(searchText) ||
            sur.profession.contains(searchText))
        .toList();
    setState(() {});
  }

  onSearchCrossBtnPressed() {
    listOfFilteredSurveyor = null;
    setState(() {});
  }

  @override
  void initState() {
    _loading = Loading(context: context, key: surveyorListKey);
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
      columns: columnsOfDataTable,
      records: listOfFilteredSurveyor ?? listOfSurveyor!,
    );
    return Column(
      children: [
        SearchField(
          controller: _textEditingController,
          onSearchTap: () {
            onSearchBtnPressed();
          },
          onCrossTap: () {
            onSearchCrossBtnPressed();
          },
          isCrossVisible: listOfFilteredSurveyor != null,
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
                child: Card(child: dataTableWithGivenColumn!),
              ),
            ),
          ),
        )
      ],
    );
  }
}
