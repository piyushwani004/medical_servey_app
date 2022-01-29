import 'package:flutter/material.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';

class DataTableWithGivenColumn extends StatefulWidget {
  final List<String> columns;
  final List<Surveyor> records;
  List<Surveyor> selectedRecords = [];

  DataTableWithGivenColumn(
      {Key? key, required this.columns, required this.records})
      : super(key: key);

  @override
  _DataTableWithGivenColumnState createState() =>
      _DataTableWithGivenColumnState();
}

class _DataTableWithGivenColumnState extends State<DataTableWithGivenColumn> {
  List<DataColumn> getColumns(List<String> columns) =>
      columns.map((String column) => DataColumn(label: Text(column))).toList();

  List<DataRow> getRows(List<Surveyor> records) => records
      .map((Surveyor row) => DataRow(
    cells: [
            DataCell(Text(row.email)),
            DataCell(Text(row.firstName)),
            DataCell(Text(row.middleName)),
            DataCell(Text(row.lastName)),

          ],
    selected: widget.selectedRecords.contains(row),
    onSelectChanged: (isSelected) => setState(() {
      final isAdding = isSelected != null && isSelected;
      isAdding?widget.selectedRecords.add(row):widget.selectedRecords.remove(row);

    }),
  ))
      .toList();

  Widget buildDataTable() {
    return DataTable(
        columns: getColumns(widget.columns), rows: getRows(widget.records));
  }

  @override
  Widget build(BuildContext context) {
    return buildDataTable();
  }
}
