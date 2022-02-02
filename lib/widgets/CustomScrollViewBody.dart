import "package:flutter/material.dart";

import 'common.dart';

class CustomScrollViewBody extends StatefulWidget {
  final Widget bodyWidget;
  const CustomScrollViewBody({Key? key,required this.bodyWidget}) : super(key: key);

  @override
  _CustomScrollViewBodyState createState() => _CustomScrollViewBodyState();
}

class _CustomScrollViewBodyState extends State<CustomScrollViewBody> {
  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Padding(
            padding: Common.leftRightPadding(mHeight: height),
            child: widget.bodyWidget,
          )
        ],
      ),
    );
  }
}

