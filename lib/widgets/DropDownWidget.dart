import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatefulWidget {

  final String name;
  final List<String> items;
  DropDownButtonWidget({Key? key,required this.items,required this.name,}) : super(key: key);

  @override
  _DropDownButtonWidgetState createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {

  String? get selectedItem => _selected;
  String? _selected;
   List<String>? items;
  @override
  void initState() {
    items =widget.items;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      isExpanded: true,
      hint: Text(widget.name),
      value: _selected,
      icon: const Icon(Icons.arrow_downward),
      elevation: 10,
      // style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.blue,
      ),
      onChanged: (String? newValue) {
        setState(() {
          _selected = newValue!;
        });
      },
      items: items!
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
