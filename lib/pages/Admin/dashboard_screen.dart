import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';
import '../../widgets/dashboardCounts.dart';
import '../../widgets/dashboard_patients_list.dart';
import '../../widgets/district_report.dart';

class DashboardScreen extends StatelessWidget {
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: 'Medical Survey'),
          CustomScrollViewBody(bodyWidget: body(context))
        ],
      ),
    );
  }

  final createdByText = Text(
    "$CREATEDBY",
    style: TextStyle(fontSize: 12, color: Colors.grey),
  );

  final companyNameText = Text(
    "$COMPANYNAME",
    style: TextStyle(
        fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
  );

  Widget body(context) {
    return Column(
      children: [
        SizedBox(height: defaultPadding),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Column(
                children: [
                  MyFiles(),
                  SizedBox(height: defaultPadding),
                  DashboardPatientsList(),
                  if (Responsive.isMobile(context))
                    SizedBox(height: defaultPadding),
                  if (Responsive.isMobile(context)) DistrictReport(),
                ],
              ),
            ),
            if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
            // On Mobile means if the screen is less than 850 we dont want to show it
            if (!Responsive.isMobile(context))
              Expanded(
                flex: 2,
                child: DistrictReport(),
              ),
          ],
        ),
        SizedBox(
          height: height * 0.01,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: createdByText),
            Flexible(
              child: InkWell(
                  onTap: () {
                    launchURL();
                  },
                  child: companyNameText),
            ),
          ],
        )
      ],
    );
  }
}
