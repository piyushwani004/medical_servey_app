import "package:flutter/material.dart";
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class NewSurveyorForm extends StatefulWidget {
  const NewSurveyorForm({Key? key}) : super(key: key);

  @override
  _NewSurveyorFormState createState() => _NewSurveyorFormState();
}

class _NewSurveyorFormState extends State<NewSurveyorForm> {
  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  var width, height;
  Map<String,String> surveyorForm = {};



  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: "New Surveyor Form"),
          CustomScrollViewBody(bodyWidget: body(surveyorForm))
        ],
      ),
    );
  }
}



Widget body(Map<String,String> surveyorForm) {

  final fullName = TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    onSaved: (email){
      List<String> splitEmail = email!.split(" ");
      surveyorForm["firstName"] = splitEmail[0];
      surveyorForm["middleName"] = splitEmail[1];
      surveyorForm["lastName"] = splitEmail[2];
    },
    // validator: (email) => emailValidator(email!),
    decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
  );
  // final age = TextFormField(
  //   keyboardType: TextInputType.emailAddress,
  //   autofocus: false,
  //   onSaved: (email){
  //     List<String> splitEmail = email!.split(" ");
  //     surveyorForm["firstName"] = splitEmail[0];
  //     surveyorForm["middleName"] = splitEmail[1];
  //     surveyorForm["lastName"] = splitEmail[2];
  //   },
  //   // validator: (email) => emailValidator(email!),
  //   decoration: Common.textFormFieldInputDecoration(labelText: "Full Name"),
  // );


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
