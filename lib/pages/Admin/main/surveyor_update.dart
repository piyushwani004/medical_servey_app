import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

import 'components/side_menu.dart';

class SurveyorListForUpdate extends StatefulWidget {
  const SurveyorListForUpdate({Key? key}) : super(key: key);

  @override
  _SurveyorListForUpdateState createState() => _SurveyorListForUpdateState();
}

class _SurveyorListForUpdateState extends State<SurveyorListForUpdate> {
  var width, height;
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
                      child: body(),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget body(){
    return Column(
      children: [

      ],
    );
  }
}
