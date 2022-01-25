import 'package:flutter/material.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/curve_clipper.dart';

class SurveyorHomePage extends StatefulWidget {
  const SurveyorHomePage({Key? key}) : super(key: key);

  @override
  _SurveyorHomePageState createState() => _SurveyorHomePageState();
}

class _SurveyorHomePageState extends State<SurveyorHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [

          Column(
            children: [
              Flexible(
                  flex: 2,
                  child: ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      decoration: Common.gradientBoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            topLeft: Radius.circular(0)),
                      ),
                    ),
                  )),
              Flexible(
                flex: 5,
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
