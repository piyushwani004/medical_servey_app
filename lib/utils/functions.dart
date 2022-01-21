import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medical_servey_app/widgets/common.dart';

String? emailValidator(String text) {
  bool validEmail = RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$').hasMatch(text);
  if (validEmail) {
    return null;
  } else {
    return "Enter a valid Email";
  }
}

String? passwordValidator(String text) {
  bool validPassword = RegExp(
          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#$@!%&*?])[A-Za-z\d#$@!%&*?]{8,30}$')
      .hasMatch(text);
  if (validPassword) {
    return null;
  } else {
    return "*Password must contain a uppercase character and a symbol.\n*Must be 8 characters long";
  }
}

String? mobileNumberValidator(String text) {
  bool validPassword = RegExp(
      r'^(\+\d{1,3}[- ]?)?\d{10}$')
      .hasMatch(text);
  if (validPassword) {
    return null;
  } else {
    return "*10 Digit Mobile Number\n*With country code ex- +91 ";
  }
}

String? aadhaarNumberValidator(String text) {
  bool validPassword = RegExp(
      r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$')
      .hasMatch(text);
  if (validPassword) {
    return null;
  } else {
    return "*Enter a valid Aadhaar Number";
  }
}

Future<String> selectDate(BuildContext context) async {
  DateTime selectedDate = DateTime.now();
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate,
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );
  if (picked != null && picked != selectedDate) {
    selectedDate = picked;
  }

  return formatDate(selectedDate.toString());
}

String formatDate(oldFormat) {
  DateTime dt = DateTime.parse(oldFormat);
  String _date = DateFormat('yyyy-MM-dd').format(dt).toString().split(" ")[0];
  return _date;
}

Future inputDialog(BuildContext context, {required String inputText}) async {
  return showDialog(
    context: context,
    barrierDismissible:
        false, // dialog is dismissible with a tap on the barrier
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(inputText),
        content: new Row(
          children: [
            Expanded(
                child: TextField(
              autofocus: true,
              decoration: Common.textFormFieldInputDecoration(
                  labelText: "Disease Name"),
              onChanged: (value) {
                inputText = value;
              },
            ))
          ],
        ),
        actions: [
          TextButton(
            child: Text('Save'),
            onPressed: () {
              Navigator.of(context).pop(inputText);
            },
          ),
        ],
      );
    },
  );
}
