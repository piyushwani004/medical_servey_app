import 'package:flutter/material.dart';

class DropDownButtonWidget extends StatefulWidget {
  final String? initValue;
  final List<String> items;
  final Function callback;
  DropDownButtonWidget({Key? key, this.initValue,required this.items,required this.callback }) : super(key: key);

  @override
  _DropDownButtonWidgetState createState() => _DropDownButtonWidgetState();
}

class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {

  String get selectedItem => _selected;
  String _selected='';

  String? initValue;
   List<String>? items;
  @override
  void initState() {
     initValue = widget.initValue;
     items = widget.items;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: initValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
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
