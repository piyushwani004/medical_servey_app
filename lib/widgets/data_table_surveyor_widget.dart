import 'package:flutter/material.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';

class DataTableWithGivenColumnForSurveyor extends StatefulWidget {
  final List<String> columns;
  final List<Surveyor> records;
  List<Surveyor> selectedRecords = [];

  DataTableWithGivenColumnForSurveyor(
      {Key? key, required this.columns, required this.records})
      : super(key: key);

  @override
  _DataTableWithGivenColumnForSurveyorState createState() =>
      _DataTableWithGivenColumnForSurveyorState();
}

class _DataTableWithGivenColumnForSurveyorState
    extends State<DataTableWithGivenColumnForSurveyor> {
  int? sortColumnIndex;
  bool isAscending = false;
  List<Surveyor>? filteredRecords;

  int compareString(bool ascending, String val1, String val2) =>
      ascending ? val1.compareTo(val2) : val2.compareTo(val1);

  void onSort(int columnIndex, bool ascending) {
    switch (columnIndex) {
      //email
      case 0:
        print('email');
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.email, r2.email));
        break;
      case 1:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.firstName, r2.firstName));
        break;
      case 2:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.middleName, r2.middleName));
        break;
      case 3:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.lastName, r2.lastName));
        break;
      case 4:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.age.toString(), r2.age.toString()));
        break;
      case 5:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.gender, r2.gender));
        break;
      case 6:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.address, r2.address));
        break;
      case 7:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.profession, r2.profession));
        break;
      case 8:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.joiningDate, r2.joiningDate));
        break;
      case 9:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.district, r2.district));
        break;
      case 10:
        widget.records.sort((Surveyor r1, Surveyor r2) =>
            compareString(ascending, r1.aadhaarNumber, r2.aadhaarNumber));
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

  List<DataRow> getRows(List<Surveyor> records) => records
      .map((Surveyor row) => DataRow(
            cells: [
              DataCell(Text((records.indexOf(row) + 1).toString())),
              DataCell(Text(row.email)),
              DataCell(Text(row.firstName)),
              DataCell(Text(row.middleName)),
              DataCell(Text(row.lastName)),
              DataCell(Text(row.age.toString())),
              DataCell(Text(row.gender)),
              DataCell(Text(row.address)),
              DataCell(Text(row.profession)),
              DataCell(Text(row.joiningDate)),
              DataCell(Text(row.district)),
              DataCell(Text(row.taluka)),
              DataCell(Text(row.village.toString())),
              DataCell(Text(row.aadhaarNumber)),
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
