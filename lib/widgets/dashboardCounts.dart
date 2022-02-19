import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/dashboard_count.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/utils/responsive.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<FileInfoCardGridView> createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  AdminFirebaseService _adminFirebaseService = AdminFirebaseService();
  List<DashboardCount> _countList = [];
  int diseasesCount = 0,
      patientCount = 0,
      surveyorCount = 0,
      villageCount = 0,
      maleCount = 0,
      femaleCount = 0;

  Future<int> fetchDataFromJson() async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle.loadString(JSON_PATH);
    List body = json.decode(data)['Sheet1'];
    return body.length;
  }

  getCount() async {
    _countList.clear();
    diseasesCount =
        await _adminFirebaseService.getCount(collectionName: "Diseases");
    patientCount =
        await _adminFirebaseService.getCount(collectionName: "Patient");

    maleCount = await _adminFirebaseService.getCountByGender(
      key: "gender",
      value: "Male",
    );
    femaleCount = await _adminFirebaseService.getCountByGender(
      key: "gender",
      value: "Female",
    );

    surveyorCount =
        await _adminFirebaseService.getCount(collectionName: "Surveyor");

    villageCount = await fetchDataFromJson();

    print("Counts ::  $diseasesCount   $patientCount   $surveyorCount ");
    print("Gender Counts ::  $maleCount   $femaleCount ");

    setState(() {
      _countList.add(DashboardCount(count: diseasesCount, name: "Diseases"));
      _countList.add(DashboardCount(count: patientCount, name: "Patient"));
      _countList.add(DashboardCount(count: surveyorCount, name: "Surveyor"));
      _countList.add(DashboardCount(count: villageCount, name: "Village"));
    });
  }

  @override
  void initState() {
    getCount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _countList.isNotEmpty
        ? GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _countList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: widget.childAspectRatio,
            ),
            itemBuilder: (context, index) {
              return Card(
                elevation: 10,
                child: Padding(
                  padding: const EdgeInsets.all(defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      index == 1
                          ? patientCard(index: index)
                          : normalCard(index: index),
                      Divider(),
                      Flexible(
                        child: Text(
                          "Total ${_countList[index].name}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        : CircularProgressIndicator();
  }

  Widget normalCard({required int index}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Card(
            elevation: 4,
            child: Padding(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              child: Text(
                "${_countList[index].count}",
                // style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget patientCard({required int index}) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  child: Text(
                    "$maleCount",
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  child: Text(
                    "$femaleCount",
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Flexible(
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding * 0.7),
                  child: Text(
                    "M",
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Card(
                elevation: 1,
                child: Padding(
                  padding: EdgeInsets.all(defaultPadding * 0.7),
                  child: Text(
                    "F",
                    // style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
