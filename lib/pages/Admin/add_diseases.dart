import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Admin/admin_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/Disease.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/pages/Admin/main/components/side_menu.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/form_container.dart';
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
    return FormContainer(
      mHeight: height,
      mWidth: width,
      form: Form(
          key: formKeyAddDiseseForm,
          child: Padding(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: width * 0.2,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        autofocus: true,
                        validator: (disease) {
                          return disease == null
                              ? "Disease can't be empty"
                              : null;
                        },
                        onSaved: (value) {
                          diseaseForm['name'] = value.toString();
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.blueAccent),
                            ),
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Enter Diseases"),
                      ),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () {
                        onPressedAddDisease();
                      },
                      child: Text('Add Disease')),
                ],
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Divider(
                color: Colors.blueAccent,
              ),
              SizedBox(
                height: height * 0.03,
              ),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Flexible(
                          child: Text(
                        "ID",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.normal),
                      )),
                      Flexible(
                          child: Text("Name",
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.normal))),
                      Flexible(
                          child: Text("Actions",
                              style: TextStyle(
                                  fontSize: 20, fontStyle: FontStyle.normal))),
                    ]),
              ),
              Container(child: fetchAllDisease())
            ]),
          )),
    );
  }

  Widget fetchAllDisease() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder<List<Disease>>(
          stream: _firebaseService.getAllDiseases(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
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
                      return ListTile(
                        onTap: null,
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          child: Text(snapshot.data![index].name[0]),
                        ),
                        title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                  child: Text(
                                snapshot.data![index].id,
                              )),
                              Flexible(child: Text(snapshot.data![index].name)),
                              Flexible(
                                  child: ElevatedButton(
                                      onPressed: () async {
                                        await _displayTextInputDialog(
                                            context,
                                            Disease(
                                              id: snapshot.data![index].id,
                                              name: snapshot.data![index].name,
                                            ));
                                      },
                                      child: Text('Edit'))),
                              Flexible(
                                  child: ElevatedButton(
                                      onPressed: () {}, child: Text("Delete"))),
                            ]),
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
    String updatedDisease = "";
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('update Disease'),
            content: TextFormField(
              onChanged: (value) {
                updatedDisease = value;
              },
              initialValue: "${disease.name}",
              autofocus: false,
              decoration: InputDecoration(hintText: "Enter Dsease"),
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
                  Navigator.pop(context);
                  Response response = await _firebaseService.updateDisease(
                      disease: Disease(id: disease.id, name: updatedDisease));
                  print(response.toString());
                },
              ),
            ],
          );
        });
  }
}
