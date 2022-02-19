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
    if(key.currentState==null){
      Navigator.of(context,rootNavigator: true).pop();
    }else{
      Navigator.of(key.currentState!.context,rootNavigator: true).pop();
    }

  }
}