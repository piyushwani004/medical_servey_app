import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatefulWidget {
  String? selectedItem;
  final String name;
  final List<String> items;
  DropDownButtonWidget({
    Key? key,
    required this.items,
    required this.name,
  }) : super(key: key);

  @override
  DropDownButtonWidgetState createState() => DropDownButtonWidgetState();
}

class DropDownButtonWidgetState extends State<DropDownButtonWidget> {
  List<String>? items;
  @override
  void initState() {
    items = widget.items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      hint: Text(widget.name),
      value: widget.selectedItem,
      icon: const Icon(Icons.arrow_downward),
      elevation: 10,
      validator: (value) => value == null ? 'field required' : null,
      onChanged: (String? newValue) {
        setState(() {
          widget.selectedItem = newValue!;
        });
      },
      items: items!.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
