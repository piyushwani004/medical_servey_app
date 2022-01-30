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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Disease List"),
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
              Container(child: fetchAllDisease())
            ]),
          )),
    );
  }

  Widget fetchAllDisease() {
    return StreamBuilder<List<Disease>>(
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
                      title: Row(children: <Widget>[
                        Expanded(
                            child: Text(
                          snapshot.data![index].id,
                        )),
                        Expanded(child: Text(snapshot.data![index].name)),
                      ]),
                    );
                  },
                )
              ],
            ),
          );
        });
  }
}
