import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/widgets/scrollable_widget.dart';

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
  List<Patient> listOfPatient = [];
  AdminFirebaseService _firebaseService = AdminFirebaseService();

  final columns = [
    'First Name',
    'Last Name',
    'Age',
    'Gender',
    'Village',
    'Diseases',
    'Date',
  ];
  int? sortColumnIndex;
  bool isAscending = false;

  Stream<List<Patient>> getPatientsList() async* {
    List<Patient> listOfPatient = await _firebaseService.getPatients();
    this.listOfPatient = listOfPatient;
    yield listOfPatient;
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map(
        (String column) => DataColumn(
          label: Text(column),
          onSort: onSort,
        ),
      )
      .toList();

  List<DataRow> getRows({required List<Patient> patients}) =>
      patients.map((Patient user) {
        final cells = [
          user.firstName,
          user.lastName,
          user.age,
          user.gender,
          user.village,
          user.diseases,
          user.date,
        ];
        print("cells $cells");
        return DataRow(
          cells: getCells(cells),
        );
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, user1.firstName, user2.firstName),
      );
    } else if (columnIndex == 1) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, user1.lastName, user2.lastName),
      );
    } else if (columnIndex == 2) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, '${user1.age}', '${user2.age}'),
      );
    } else if (columnIndex == 3) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, '${user1.gender}', '${user2.gender}'),
      );
    } else if (columnIndex == 4) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, '${user1.village}', '${user2.village}'),
      );
    } else if (columnIndex == 5) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, '${user1.diseases}', '${user2.diseases}'),
      );
    } else if (columnIndex == 6) {
      listOfPatient.sort(
        (user1, user2) =>
            compareString(ascending, '${user1.date}', '${user2.date}'),
      );
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
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
                    if (snapshot.hasData && snapshot.data != null) {
                      return snapshot.hasData
                          ? ScrollableWidget(
                              child: DataTable(
                                sortAscending: isAscending,
                                sortColumnIndex: sortColumnIndex,
                                columns: getColumns(columns),
                                rows: getRows(patients: this.listOfPatient),
                              ),
                            )
                          : Center(
                              child: CircularProgressIndicator(),
                            );
                    } else {
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
}
