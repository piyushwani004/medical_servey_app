import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/disease.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/pages/Admin/main/components/side_menu.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class AddDiseases extends StatefulWidget {
  AddDiseases({Key? key}) : super(key: key);

  @override
  _AddDiseasesState createState() => _AddDiseasesState();
}

class _AddDiseasesState extends State<AddDiseases> {
  var width, height;
  final formKeyAddDiseseForm = GlobalKey<FormState>();
  AdminFirebaseService _firebaseService = AdminFirebaseService();
  Map<String, String> diseaseForm = {};
  TextFormField? addDiseaseTextFormField;

  Future onEditPressed(snapshot, index) async {
    await _displayTextInputDialog(
        context,
        Disease(
          id: snapshot.data![index].id,
          name: snapshot.data![index].name,
        ));
    setState(() {});
  }

  Stream<List<Disease>> getAllDisease() async* {
    List<Disease> allDisease = await _firebaseService.getAllDiseases();
    yield allDisease;
  }

  onPressedAddDisease() async {
    if (formKeyAddDiseseForm.currentState!.validate()) {
      diseaseForm['id'] = DateTime.now().millisecondsSinceEpoch.toString();
      formKeyAddDiseseForm.currentState!.save();
      Disease disease = Disease.fromMap(diseaseForm);
      Response responseForDisease =
          await _firebaseService.saveNewDiseases(disease);
      if (responseForDisease.isSuccessful) {
        // if successfully return  a message that process is complete
        Common.showAlert(
            context: context,
            title: 'Disease Add',
            content: responseForDisease.message,
            isError: false);
        // isLoading = false;
        formKeyAddDiseseForm.currentState!.reset();
        setState(() {});
      } else {
        //if failed while creating an account
        Common.showAlert(
            context: context,
            title: 'Failed in Adding Disease',
            content: responseForDisease.message,
            isError: true);
        // isLoading = false;
      }
    } else {}
  }

  @override
  void initState() {
    addDiseaseTextFormField = TextFormField(
      cursorColor: Colors.black,
      keyboardType: TextInputType.text,
      autofocus: true,
      validator: (disease) {
        disease = disease?.trim();
        return disease == null || disease == ""
            ? "Disease name can't be empty"
            : null;
      },
      onSaved: (value) {
        diseaseForm['name'] = value.toString();
      },
      decoration: InputDecoration(
          suffix: Card(
              elevation: 2,
              child: IconButton(
                  tooltip: "Add New Disease",
                  onPressed: () async {
                    await onPressedAddDisease();
                  },
                  icon: Icon(Icons.add))),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          contentPadding:
              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
          hintText: "Add Diseases"),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                TopSliverAppBar(mHeight: height, text: "Diseases"),
                CustomScrollViewBody(
                    bodyWidget: Padding(
                        padding: Common.allPadding(mHeight: height),
                        child: body(width, height)))
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget body(width, height) {
    return Form(
      key: formKeyAddDiseseForm,
      child: Responsive(
        desktop: contentsDesktop(),
        mobile: contentsMobile(),
        tablet: contentsDesktop(),
      ),
    );
  }

  Widget contentsDesktop() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Flexible(
          child: addDiseaseTextFormField!,
        ),
        Flexible(flex: 3, child: diseaseListViewWithStream())
      ],
    );
  }

  Widget contentsMobile() {
    return Column(
      children: <Widget>[addDiseaseTextFormField!, diseaseListViewWithStream()],
    );
  }

  Widget diseaseListViewWithStream() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Disease>>(
          stream: getAllDisease(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            return Center(
              child: Column(
                children: [
                  ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Flexible(
                            flex: 3,
                            child: Card(
                              elevation: 2,
                              child: ListTile(
                                title: Row(children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    snapshot.data![index].name,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                ]),
                                subtitle: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      snapshot.data![index].id,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Card(
                            child: IconButton(
                                tooltip: "Edit",
                                onPressed: () {
                                  onEditPressed(snapshot, index);
                                },
                                icon: Icon(Icons.edit)),
                          )
                        ],
                      );
                    },
                  )
                ],
              ),
            );
          }),
    );
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, Disease disease) async {
    String? updatedDisease;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState2) {
            return AlertDialog(
              title: Text('Update Disease'),
              content: Form(
                key: formKey,
                child: TextFormField(
                  validator: (val) =>
                      val == null || val == "" ? 'Cant be empty' : null,
                  initialValue: "${disease.name}",
                  onSaved: (val) {
                    setState2(() {
                      updatedDisease = val;
                    });
                  },
                  autofocus: false,
                  decoration: InputDecoration(hintText: "Enter Disease"),
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  child: Text('CANCEL'),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                ),
                ElevatedButton(
                  child: Text('OK'),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      formKey.currentState!.save();
                      print("updatedDisease $updatedDisease");
                      Response response = await _firebaseService.updateDisease(
                          disease:
                              Disease(id: disease.id, name: updatedDisease!));
                      Navigator.pop(context);
                      print(response.toString());
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}
