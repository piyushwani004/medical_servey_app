import 'package:flutter/material.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class PatientList extends StatefulWidget {
  const PatientList({Key? key}) : super(key: key);

  @override
  _PatientListState createState() => _PatientListState();
}

class _PatientListState extends State<PatientList> {
  var width, height;
  final List<String> _patientList = [
    'Liam',
    'Noah',
    'Oliver',
    'William',
    'Elijah',
    'James',
    'Benjamin',
    'Lucas',
    'Mason',
    'Ethan',
    'Alexander',
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: "Patients List"),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (_, i) {
              String name = _patientList[i];
              return body(_, i, name);
            },
            childCount: _patientList.length,
          )),
        ],
      ),
    );
  }

  Widget body(_, i, value) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${value[0]}'),
      ),
      title: Text('$value'),
      trailing: PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            )
          ];
        },
        onSelected: (String value) {
          print('You Click on po up menu item $value');
        },
      ),
    );
  }
}
