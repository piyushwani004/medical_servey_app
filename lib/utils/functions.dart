import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:math';

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
  bool validPassword = RegExp(r'^(\+\d{1,3}[- ]?)?\d{10}$').hasMatch(text);
  if (validPassword) {
    return null;
  } else {
    return "*10 Digit Mobile Number\n*With country code ex- +91 ";
  }
}

String? aadhaarNumberValidator(String text) {
  bool validPassword =
      RegExp(r'^[2-9]{1}[0-9]{3}\\s[0-9]{4}\\s[0-9]{4}$').hasMatch(text);
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
    firstDate: DateTime.now(),
    lastDate: DateTime(2050),
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

String generateRandomString(int len) {
  var r = Random();
  String randomString =
      String.fromCharCodes(List.generate(len, (index) => r.nextInt(33) + 89));
  return randomString;
}

List<int> generateN2MList(int n, int m, [bool excludeLimits = false]) {
  final diff = m - n;
  final times = excludeLimits ? diff - 1 : diff + 1;
  final startingIdx = excludeLimits ? n + 1 : n;
  List<int> generated = List.generate(times, (i) => startingIdx + i);

  return generated;
}

void showSnackBar(BuildContext context, String text) {
  final snackBar = SnackBar(content: Text(text));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> showLoadingDialog(BuildContext context, GlobalKey key) async {
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
            onWillPop: () async => false,
            child: SimpleDialog(
                key: key,
                children: <Widget>[
                  Center(
                    child: Column(children: [
                      CircularProgressIndicator(),
                    ]),
                  )
                ]));
      });
}
