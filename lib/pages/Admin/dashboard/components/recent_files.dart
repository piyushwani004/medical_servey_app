import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/constants.dart';

class RecentFiles extends StatelessWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      // padding: EdgeInsets.all(defaultPadding),
      // decoration: BoxDecoration(
      //   color: secondaryColor,
      //   borderRadius: const BorderRadius.all(Radius.circular(10)),
      // ),
      child: Padding(
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Patient List",
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Padding(
              padding:EdgeInsets.all(defaultPadding),
              child: SizedBox(
                width: double.infinity,
                child: Card(
                  child: Text("123"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
