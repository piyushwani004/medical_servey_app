import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_servey_app/utils/constants.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final Function onSearchTap;
  final Function onCrossTap;
  final bool isCrossVisible;
  SearchField({
    Key? key,required this.controller, required this.onSearchTap, required this.onCrossTap, required this.isCrossVisible
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: "Search",
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        prefixIcon:isCrossVisible?InkWell(
          onTap: () {
            onCrossTap();
          } ,
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Icon(Icons.close_rounded),
          ),
        ):null,
        suffixIcon: InkWell(
          onTap: () {
            onSearchTap();
          } ,
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
        ),
      ),
    );
  }
}