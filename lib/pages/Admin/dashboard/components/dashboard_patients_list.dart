import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/constants.dart';

import '../../../../Services/Admin/admin_firebase_service.dart';
import '../../../../models/surveyor/patient.dart';

class DashboardPatientsList extends StatefulWidget {
  const DashboardPatientsList({
    Key? key,
  }) : super(key: key);

  @override
  State<DashboardPatientsList> createState() => _DashboardPatientsListState();
}

class _DashboardPatientsListState extends State<DashboardPatientsList> {
  List<Patient>? listOfPatient;
  AdminFirebaseService _firebaseService = AdminFirebaseService();

  Stream<List<Patient>> getPatientsList() async* {
    List<Patient> listOfPatient = await _firebaseService.getPatients();
    this.listOfPatient = listOfPatient;
    yield listOfPatient;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: EdgeInsets.all(defaultPadding),
      // decoration: BoxDecoration(
      //   color: secondaryColor,
      //   borderRadius: const BorderRadius.all(Radius.circular(10)),
      // ),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Patient List",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding: EdgeInsets.all(defaultPadding),
              child: StreamBuilder<List<Patient>>(
                  stream: getPatientsList(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data!=null) {
                      return snapshot.hasData
                          ? listViewOfPatients(snapshot.data!)
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    }else{
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }


  Widget listViewOfPatients(List<Patient> list){
    return ListView.builder(
      shrinkWrap: true,
      itemCount: list.length,
        itemBuilder: (context,index){
      return ListTile(
        leading: Text('${list[index].firstName} ${list[index].middleName} ${list[index].lastName}'.trim()),
        subtitle: Text('Village-TO-Display'),
        trailing: Text("${list[index].diseases} ${list[index].otherDisease}"),
      );
    });
  }
}
