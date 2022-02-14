import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/Services/Admin/disease_percentage_calculate_service.dart';
import 'package:medical_servey_app/utils/constants.dart';

import '../../../../widgets/common.dart';

class DistrictReport extends StatefulWidget {
  DistrictReport({
    Key? key,
  }) : super(key: key);

  @override
  State<DistrictReport> createState() => _DistrictReportState();
}

class _DistrictReportState extends State<DistrictReport> {
  var height, width;
  DiseasePercentageCalculateService diseasePercentageCalculateService = DiseasePercentageCalculateService();

  @override
  void initState() {
   diseasePercentageCalculateService.calculatePercentageOfAllDisease();
    super.initState();
  }

  @override
  build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<Map<String,double>>(
            future: diseasePercentageCalculateService.calculatePercentageOfAllDisease(), // a previously-obtained Future<String> or null
            builder: (BuildContext context, AsyncSnapshot<Map<String,double>> snapshot) {
              List<Widget> children;
              if (snapshot.hasData) {
                children = <Widget>[
                  const Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Result: ${snapshot.data}'),
                  )
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
          Text(
            "Diseases Report",
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              itemBuilder: (_, index) => Row(
                    children: [
                      Expanded(
                        child: Card(
                          child: Padding(
                            padding: Common.allPadding(mHeight: height),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(child: Text("Corono")),
                                Flexible(child: Text("Corono")),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ))
        ],
      ),
    );
  }
}

