import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/functions.dart';

class Loading{
  GlobalKey<State> key;
  BuildContext context;
  Loading({required this.key,required this.context});

  void on(){
    showLoadingDialog(this.context, this.key);
  }

  void off(){
    Navigator.of(this.key.currentContext!,rootNavigator: true).pop();
  }
}