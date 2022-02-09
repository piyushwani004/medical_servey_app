import 'package:flutter/material.dart';

import 'common.dart';

class FormContainer extends StatefulWidget {
  final double mHeight;
  final double mWidth;
  final Widget form;
  const FormContainer(
      {Key? key,
      required this.mHeight,
      required this.mWidth,
      required this.form})
      : super(key: key);

  @override
  _FormContainerState createState() => _FormContainerState();
}

class _FormContainerState extends State<FormContainer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(widget.mHeight > 770
          ? 10
          : widget.mHeight > 670
              ? 20
              : 16),
      child: Center(
          child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(25),
          ),
        ),
        child: Padding(
          padding: Common.allPadding(mHeight: widget.mHeight),
          child: widget.form,
        ),
      )),
    );
  }
}
