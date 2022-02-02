import 'package:flutter/material.dart';

class MultiSelectDialogItem {
  const MultiSelectDialogItem(this.id, this.label);

  final id;
  final String label;
}

class MultiSelectDialog extends StatefulWidget {
  MultiSelectDialog(
      {Key? key, required this.items, required this.initialSelectedValues})
      : super(key: key);

  final List<MultiSelectDialogItem> items;
  final Set initialSelectedValues;

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  final _selectedValues = Set<String>();

  void _onItemCheckedChange(itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  void initState() {
    if (widget.initialSelectedValues != null) {
      _selectedValues
          .addAll(widget.initialSelectedValues.map((e) => e.toString()));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Diseases'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        ElevatedButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        )
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem item) {
    final checked = _selectedValues.contains(item.label);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.label, checked!),
    );
  }
}
