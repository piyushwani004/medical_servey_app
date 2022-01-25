import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/constants.dart';

class SurveyorHomePage extends StatefulWidget {
  const SurveyorHomePage({Key? key}) : super(key: key);

  @override
  _SurveyorHomePageState createState() => _SurveyorHomePageState();
}

class _SurveyorHomePageState extends State<SurveyorHomePage> {
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text(TRUST_NAME),
          centerTitle: true,
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Icon(Icons.logout),
                )),
          ],
        ),
        body: Container());
  }
}
