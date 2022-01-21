import "package:flutter/material.dart";
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class NewSurveyorForm extends StatefulWidget {
  const NewSurveyorForm({Key? key}) : super(key: key);

  @override
  _NewSurveyorFormState createState() => _NewSurveyorFormState();
}

class _NewSurveyorFormState extends State<NewSurveyorForm> {
  var width, height;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: "New Surveyor Form"),
          CustomScrollViewBody(bodyWidget: body())
        ],
      ),
    );
  }
}

Widget body() {
  return Column(
    children: [
      Text("hello"),
      Text("hello"),
      Container(
        color: Colors.black26,
        child: Text("hello"),
      ),
      Container(
        color: Colors.red,
        child: Text("hello"),

      )
    ],
  );
}
