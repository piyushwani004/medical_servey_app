import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/Services/Admin/pdf_genrate_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';
import 'package:medical_servey_app/models/common/pdf_model.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/data_table_surveyor_widget.dart';
import 'package:medical_servey_app/widgets/loading.dart';
import 'package:medical_servey_app/widgets/search_field.dart';
import 'package:medical_servey_app/widgets/surveyor_edit_dialog.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

import '../../routes/routes.dart';
import 'main/components/side_menu.dart';

class SurveyorListForUpdate extends StatefulWidget {
  const SurveyorListForUpdate({Key? key}) : super(key: key);

  @override
  _SurveyorListForUpdateState createState() => _SurveyorListForUpdateState();
}

class _SurveyorListForUpdateState extends State<SurveyorListForUpdate> {
  var width, height;
  DataTableWithGivenColumnForSurveyor? dataTableWithGivenColumn;
  List<Surveyor>? listOfSurveyor;
  List<Surveyor>? listOfFilteredSurveyor;
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  TextEditingController _textEditingController = TextEditingController();
  final GlobalKey<State> surveyorListKey = GlobalKey<State>();
  final _verticalScrollController = ScrollController();
  final _horizontalScrollController = ScrollController();
  Loading? _loading;
  final scaffoldState = GlobalKey<ScaffoldState>();
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
    'District',
    'Taluka',
    'Villages',
    'Aadhaar-Number'
  ];

  Stream<List<Surveyor>> getSurveyorsList() async* {
    List<Surveyor> listOfSurveyor = await _firebaseService.getSurveyors();
    this.listOfSurveyor = listOfSurveyor;
    yield listOfSurveyor;
    // setState(() {});
  }

  onSearchBtnPressed() {
    print(_textEditingController.text);
    String searchText = _textEditingController.text.toLowerCase();
    listOfFilteredSurveyor = listOfSurveyor
        ?.where((Surveyor sur) =>
            sur.firstName.toLowerCase().contains(searchText) ||
            sur.middleName.toLowerCase().contains(searchText) ||
            sur.lastName.toLowerCase().contains(searchText) ||
            sur.email.toLowerCase().contains(searchText) ||
            sur.mobileNumber.toLowerCase().contains(searchText) ||
            sur.address.toLowerCase().contains(searchText) ||
            sur.gender.toLowerCase().contains(searchText) ||
            sur.joiningDate.toLowerCase().contains(searchText) ||
            sur.district.toLowerCase().contains(searchText) ||
            sur.aadhaarNumber.toLowerCase().contains(searchText) ||
            sur.taluka.toLowerCase().contains(searchText) ||
            sur.village.contains(searchText) ||
            sur.profession.toLowerCase().contains(searchText))
        .toList();
    setState(() {});
  }

  onSearchCrossBtnPressed() {
    listOfFilteredSurveyor = null;
    setState(() {});
  }

  onUpdatePressed() async {
    if (dataTableWithGivenColumn!.selectedRecords.isNotEmpty &&
        dataTableWithGivenColumn!.selectedRecords.length == 1) {
      // print(dataTableWithGivenColumn!.selectedRecords);
      await showDialog(
          context: context,
          builder: (context) => SurveyorEditDialog(
              surveyor: dataTableWithGivenColumn!.selectedRecords[0]));
      setState(() {});
    } else {
      Common.showAlert(
          context: context,
          title: 'Surveyor Edit',
          content: dataTableWithGivenColumn!.selectedRecords.isEmpty
              ? 'Please select a Surveyor'
              : 'Cannot edit multiple at a time',
          isError: true);
    }
  }

  onAddSurveyorBtnPressed() {
    Navigator.pushNamed(context, routeAdminAddSurveyor);
  }

  final FocusNode _focusNode = FocusNode();

  void _handleKeyEvent(RawKeyEvent event) {
    var offset = _horizontalScrollController.offset;
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      setState(() {
        if (kReleaseMode) {
          _horizontalScrollController.animateTo(offset - 200,
              duration: Duration(milliseconds: 60), curve: Curves.ease);
        } else {
          // _horizontalScrollController.animateTo(offset - 200, duration: Duration(milliseconds: 60), curve: Curves.ease);
        }
      });
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      setState(() {
        if (kReleaseMode) {
          _horizontalScrollController.animateTo(offset + 200,
              duration: Duration(milliseconds: 30), curve: Curves.ease);
        } else {
          //_horizontalScrollController.animateTo(offset + 200, duration: Duration(milliseconds: 30), curve: Curves.ease);
        }
      });
    }
  }

  onEnterMouse(PointerEnterEvent event) {
    _focusNode.requestFocus();
  }

  onExitMouse(PointerExitEvent event) {
    _focusNode.unfocus();
  }

  @override
  void initState() {
    _loading = Loading(context: context, key: surveyorListKey);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  onPDFSavePressed() async {
    final surveyorData = PdfModel(
      surveyorLst: this.listOfSurveyor,
    );
    await PdfInvoiceApi.generateSurveyorData(surveyorData);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
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
                TopSliverAppBar(mHeight: height, text: "Surveyor List"),
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
              child: SearchField(
                controller: _textEditingController,
                onSearchTap: () {
                  onSearchBtnPressed();
                },
                onCrossTap: () {
                  onSearchCrossBtnPressed();
                },
                isCrossVisible: listOfFilteredSurveyor != null,
              ),
            ),
            IconButton(
              tooltip: "Edit",
              onPressed: () async {
                await onUpdatePressed();
              },
              icon: Icon(Icons.edit),
            ),
            IconButton(
              tooltip: "Save PDF",
              onPressed: () async {
                onPDFSavePressed();
              },
              icon: Icon(Icons.save),
            ),
            Card(
              child: IconButton(
                  tooltip: "Add new Surveyor",
                  onPressed: () {
                    onAddSurveyorBtnPressed();
                  },
                  icon: Icon(Icons.add)),
            ),
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
                    child: MouseRegion(
                      onEnter: onEnterMouse,
                      onExit: onExitMouse,
                      child: RawKeyboardListener(
                        autofocus: true,
                        focusNode: _focusNode,
                        onKey: _handleKeyEvent,
                        child: StreamBuilder<List<Surveyor>>(
                            stream: getSurveyorsList(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                dataTableWithGivenColumn =
                                    DataTableWithGivenColumnForSurveyor(
                                  columns: columnsOfDataTable,
                                  records:
                                      listOfFilteredSurveyor ?? snapshot.data!,
                                );
                                print(
                                    dataTableWithGivenColumn?.selectedRecords);
                              }
                              return snapshot.hasData
                                  ? dataTableWithGivenColumn!
                                  : Center(
                                      child: CircularProgressIndicator(),
                                    );
                            }),
                      ),
                    )),
              ),
            ),
          ),
        )
      ],
    );
  }
}
