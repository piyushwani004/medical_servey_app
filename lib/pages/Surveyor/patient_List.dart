import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/widgets/CustomScrollViewBody.dart';
import 'package:medical_servey_app/widgets/patient_edit_dialog.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  SurveyorFirebaseService _firebaseService = SurveyorFirebaseService();

  var width, height;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: "Patients List"),
          CustomScrollViewBody(
              bodyWidget: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: fetchAllPatients()))
        ],
      ),
    );
  }

  onPressedEdit({patientData}) async {
    await showDialog(
        context: context,
        builder: (context) => PatientEditDialog(patient: patientData));
    setState(() {});
  }

  onPressedDelete({patientData}) async {
    print("onPressedDelete $patientData");
    Response response = await _firebaseService.deletePatient(patientData);
    if (response.isSuccessful) {
      showSnackBar(context, response.message);
    } else {
      showSnackBar(context, response.message);
    }
    setState(() {});
  }

  Stream<List<Patient>> getAllPatient() async* {
    List<Patient> allDisease = await _firebaseService.getAllPatients();
    yield allDisease;
  }

  Widget fetchAllPatients() {
    return StreamBuilder<List<Patient>>(
        stream: getAllPatient(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [CircularProgressIndicator()],
            );
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
                        child: Text(snapshot.data![index].firstName[0]),
                      ),
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                                child: Text(
                                    '${snapshot.data![index].firstName} ${snapshot.data![index].lastName} ')),
                          ]),
                      subtitle: Row(
                        children: [
                          Flexible(
                              child: Text(snapshot.data![index].mobileNumber)),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) {
                          return [
                            PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            )
                          ];
                        },
                        onSelected: (String value) {
                          if (value == "edit") {
                            onPressedEdit(patientData: snapshot.data![index]);
                          } else {
                            onPressedDelete(patientData: snapshot.data![index]);
                          }
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          );
        });
  }
}
