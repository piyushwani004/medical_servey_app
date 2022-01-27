import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Common/MenuController.dart';
import 'package:medical_servey_app/pages/Admin/dashboard/dashboard_screen.dart';
import 'package:medical_servey_app/utils/responsive.dart';
import 'package:provider/provider.dart';
import 'components/side_menu.dart';

class AdminHome extends StatefulWidget {
  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List _navigatorRoutes = [

  ];

  int _selectedIndex= 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuController>().scaffoldKey,
      drawer: SideMenu(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
