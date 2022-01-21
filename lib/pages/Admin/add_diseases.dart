import 'package:flutter/material.dart';
import 'package:medical_servey_app/widgets/top_sliver_app_bar.dart';

class AddDiseases extends StatefulWidget {
  AddDiseases({Key? key}) : super(key: key);

  @override
  _AddDiseasesState createState() => _AddDiseasesState();
}

class _AddDiseasesState extends State<AddDiseases> {
  var width, height;
  final List<String> _names = [
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
    'Alexander'
  ];

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          TopSliverAppBar(mHeight: height, text: "Add Disease Form"),
          SliverList(
              delegate: SliverChildBuilderDelegate(
            (_, i) {
              String name = _names[i];
              return body(_, i, name);
            },
            childCount: _names.length,
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.add_circle,
          color: Colors.white,
          size: 29,
        ),
        tooltip: 'Add Disease',
        elevation: 5,
        splashColor: Colors.grey,
      ),
    );
  }

  Widget body(_, i, name) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${name[0]}'),
      ),
      title: Text('$name'),
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
      // </Add>
    );
  }
}
