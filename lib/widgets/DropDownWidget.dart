// import 'package:flutter/material.dart';
//
// class DropDownButtonWidget extends StatefulWidget {
//   final String? initValue;
//   final List items;
//   DropDownButtonWidget({Key? key, this.initValue,required this.items }) : super(key: key);
//
//   @override
//   _DropDownButtonWidgetState createState() => _DropDownButtonWidgetState();
// }
//
// class _DropDownButtonWidgetState extends State<DropDownButtonWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return DropDownButton(
//
//       // Initial Value
//       value: widget.initValue,
//
//       // Down Arrow Icon
//       icon: const Icon(Icons.keyboard_arrow_down),
//
//       // Array list of items
//       items: items.map((String items) {
//         return DropdownMenuItem(
//           value: items,
//           child: Text(items),
//         );
//       }).toList(),
//       // After selecting the desired option,it will
//       // change button value to selected value
//       onChanged: (String? newValue) {
//         setState(() {
//           dropDownValue = newValue!;
//         });
//       },
//     ),;
//   }
// }
