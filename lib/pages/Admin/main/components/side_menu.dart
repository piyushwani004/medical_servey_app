import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medical_servey_app/Services/Common/auth_service.dart';
import 'package:medical_servey_app/routes/routes.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/widgets/loading.dart';
import 'package:provider/provider.dart';

import '../../../../models/common/Responce.dart';
import '../../../../widgets/common.dart';

class SideMenu extends StatefulWidget {
  SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  ScrollController _scrollController = ScrollController();
  Loading? loading;
  final GlobalKey<State> sideMenuKey = GlobalKey<State>();
  @override
  void initState() {
    loading = Loading(key: sideMenuKey, context: context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        controller: _scrollController,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text("Admin"),
            accountEmail: Text("Admin@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(LOGO_PATH),
            ),
          ),
          DrawerListTile(
            title: "Dashboard",
            svgSrc: "assets/icons/menu_dashbord.svg",
            press: () {
              Navigator.pushReplacementNamed(context, routeAdminHome);
            },
          ),
          DrawerListTile(
            title: "Patient",
            svgSrc: "assets/icons/patient.svg",
            press: () {
              Navigator.pushReplacementNamed(context, routeAdminUpdatePatient);
            },
          ),
          DrawerListTile(
            title: "Surveyor ",
            svgSrc: "assets/icons/surveyor.svg",
            press: () {
              Navigator.pushReplacementNamed(
                  context, routeSurveyorListForUpdate);
            },
          ),
          DrawerListTile(
            title: "Disease",
            svgSrc: "assets/icons/disease.svg",
            press: () {
              Navigator.pushReplacementNamed(context, routeAddDiseases);
            },
          ),
          DrawerListTile(
            title: "Report",
            svgSrc: "assets/icons/menu_doc.svg",
            press: () {
              Navigator.pushReplacementNamed(context, routeGenerateReport);
            },
          ),
          DrawerListTile(
            title: "Logout",
            svgSrc: "assets/icons/menu_task.svg",
            press: () async {
              loading!.on();
              Response res =
                  await context.read<FirebaseAuthService>().signOut();
              if (res.isSuccessful) {
                loading!.off();
                Navigator.pushReplacementNamed(context, routeStart);
              } else {
                loading!.off();
                Common.showAlert(
                    context: context,
                    title: "Logout Failed",
                    content: res.message,
                    isError: true);
              }
            },
          ),
        ],
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.black,
        height: 25,
      ),
      title: Text(
        title,
        style: TextStyle(color: bgColor),
      ),
    );
  }
}
