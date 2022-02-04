import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/constants.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.all(defaultPadding * 0.75),
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Container(
                    child: Text("78", style: TextStyle(color: Colors.white)),
                  )),
            ],
          ),
          Divider(),
          Text(
            "Surveyor Count :",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Surveyor Count",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}
