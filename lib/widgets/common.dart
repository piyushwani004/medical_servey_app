import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class Common {
  // header text
  static headerTextStyle({Color? color, double? size}) {
    return GoogleFonts.varelaRound(
      color: color,
      fontSize: size ?? 19,
      fontWeight: FontWeight.bold,
    );
  }

  static buttonStyle({Color? backClr, Color? foreClr}) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(backClr),
      foregroundColor: MaterialStateProperty.all(foreClr ?? Colors.white),
    );
  }

  static normalTextStyle({Color? color, double? fs}) {
    return GoogleFonts.varelaRound(
        color: color, fontSize: fs ?? 15);
  }

  // // container decoration
  static containerBoxDecoration(
      {Color? backColor, BorderRadius? borderRadius}) {
    return BoxDecoration(
        borderRadius:
        borderRadius ?? const BorderRadius.all(Radius.circular(5)));
  }

  // // AppBar
  // static appBar({required String title, BackButton? bckBtn}) {
  //   return AppBar(
  //     centerTitle: true,
  //     backgroundColor: foregroundColor,
  //     elevation: 0.0,
  //     leading: bckBtn,
  //     title: Text(
  //       title,
  //       style: headerTextStyle(),
  //     ),
  //   );
  // }

  // all padding
  static allPadding({mHeight}) {
    return EdgeInsets.all(mHeight * 0.01);
  }

  // all left right only
  static leftRightPadding({mHeight}) {
    return EdgeInsets.only(left: mHeight * 0.02, right: mHeight * 0.02);
  }

  // //connectivity checker
  // static checkConnectivity() async {
  //   try {
  //     final result = await InternetAddress.lookup('www.google.com');
  //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
  //       // print('connected');
  //       return true;
  //     }
  //   } on SocketException catch (exception) {
  //     // print('not connected $exception');
  //     return false;
  //   }
  // }

  static InputDecoration textFormFieldInputDecoration(
      {required String labelText}) {
    return InputDecoration(
      labelText: labelText,
      hintText: labelText,
      contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
    );
  }

  static BoxDecoration gradientBoxDecoration({borderRadius}) {
    return BoxDecoration(
        borderRadius:
        borderRadius ?? const BorderRadius.all(Radius.circular(10),),
        gradient: LinearGradient(
            colors: [Colors.purple, Colors.deepPurpleAccent]));
  }
}