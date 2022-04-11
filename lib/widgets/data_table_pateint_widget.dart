import 'package:flutter/material.dart';
import 'package:medical_servey_app/models/surveyor/patient.dart';

class DataTableWithGivenColumnForPatient extends StatefulWidget {
  final List<String> columns;
  final List<Patient> records;
  List<Patient> selectedRecords = [];

  DataTableWithGivenColumnForPatient(
      {Key? key, required this.columns, required this.records})
      : super(key: key);

  @override
  _DataTableWithGivenColumnForPatientState createState() =>
      _DataTableWithGivenColumnForPatientState();
}

class _DataTableWithGivenColumnForPatientState
    extends State<DataTableWithGivenColumnForPatient> {
  int? sortColumnIndex;
  bool isAscending = false;
  List<Patient>? filteredRecords;

  int compareString(bool ascending, String val1, String val2) =>
      ascending ? val1.compareTo(val2) : val2.compareTo(val1);

  void onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      //email
      case 0:
        print('email');
        widget.records.sort(
            (Patient r1, Patient r2) => compareString(ascending, r1.id, r2.id));
        break;
      case 1:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.village, r2.village));
        break;
      case 2:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.email, r2.email));
        break;
      case 3:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.firstName, r2.firstName));
        break;
      case 4:
        widget.records.sort((Patient r1, Patient r2) => compareString(
            ascending, r1.middleName.toString(), r2.middleName.toString()));
        break;
      case 5:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.lastName, r2.lastName));
        break;
      case 6:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.age.toString(), r2.age.toString()));
        break;
      case 7:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.gender, r2.gender));
        break;
      case 8:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.address, r2.address));
        break;
      case 10:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.mobileNumber, r2.mobileNumber));
        break;
      case 12:
        widget.records.sort((Patient r1, Patient r2) =>
            compareString(ascending, r1.aadhaarNumber, r2.aadhaarNumber));
        break;
      case 13:
        widget.records.sort((Patient r1, Patient r2) => compareString(
            ascending, r1.isMember.toString(), r2.isMember.toString()));
        break;
      case 14:
        widget.records.sort((Patient r1, Patient r2) => compareString(
            ascending, r1.bootNo.toString(), r2.bootNo.toString()));
        break;
    }

    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          onSort: onSort,
          label: Text(
            column,
            style: TextStyle(fontWeight: FontWeight.bold),
          )))
      .toList();

  List<DataRow> getRows(List<Patient> records) => records
      .map((Patient row) => DataRow(
            cells: [
              DataCell(Text((records.indexOf(row) + 1).toString())),
              DataCell(Text(row.village)),
              DataCell(Text(row.email)),
              DataCell(Text(row.firstName)),
              DataCell(Text(row.middleName)),
              DataCell(Text(row.lastName)),
              DataCell(Text(row.age.toString())),
              DataCell(Text(row.gender)),
              DataCell(Text(row.address)),
              DataCell(Text(row.profession)),
              DataCell(Text(row.mobileNumber)),
              DataCell(Text(row.diseases.toString())),
              DataCell(Text(row.aadhaarNumber.toString())),
              DataCell(Text(row.isMember ? 'Yes' : 'No')),
              DataCell(Text(row.bootNo.toString())),
            ],
            selected: widget.selectedRecords.contains(row),
            onSelectChanged: (isSelected) => setState(() {
              final isAdding = isSelected != null && isSelected;
              isAdding
                  ? widget.selectedRecords.add(row)
                  : widget.selectedRecords.remove(row);
            }),
          ))
      .toList();

  Widget buildDataTable() {
    return DataTable(
        sortAscending: isAscending,
        sortColumnIndex: sortColumnIndex,
        columns: getColumns(widget.columns),
        rows: getRows(widget.records));
  }

  @override
  Widget build(BuildContext context) {
    return buildDataTable();
  }
}
