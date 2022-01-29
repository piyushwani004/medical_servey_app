import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Common/auth_service.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/routes/routes.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/curve_clipper.dart';
import 'package:provider/provider.dart';

class SurveyorHomePage extends StatefulWidget {
  const SurveyorHomePage({Key? key}) : super(key: key);

  @override
  _SurveyorHomePageState createState() => _SurveyorHomePageState();
}

class _SurveyorHomePageState extends State<SurveyorHomePage> {
  SurveyorFirebaseService _surveyorFirebaseService = SurveyorFirebaseService();
  var width, height;

  onLogoutPressed() {
    context.read<FirebaseAuthService>().signOut();
  }

  getSurveyorDetails() async {
    var user = await _surveyorFirebaseService.getSurveyorDetails();
  }

  @override
  void initState() {
    getSurveyorDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // background design
          Column(
            children: [
              Flexible(
                  flex: 2,
                  child: ClipPath(
                    clipper: CurveClipper(),
                    child: Container(
                      decoration: Common.gradientBoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            topLeft: Radius.circular(0)),
                      ),
                    ),
                  )),
              Flexible(
                flex: 5,
                child: Container(
                  color: Colors.white,
                ),
              )
            ],
          ),
          ListView(
            children: [
              Align(
                // name of profile
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: Common.allPadding(mHeight: height),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: Common.allPadding(mHeight: height),
                                child: CircleAvatar(
                                  //first letter of name
                                  child: Text('N'),
                                ),
                              ),
                              Padding(
                                padding: Common.allPadding(mHeight: height),
                                child: Column(
                                  children: [
                                    Text(
                                      'Name',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Text(
                                      'more Info',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          IconButton(
                              onPressed: () {
                                onLogoutPressed();
                              },
                              icon: Icon(Icons.logout_rounded))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //table containers for each feature
              Padding(
                padding: Common.allPadding(mHeight: height * 1),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Table(
                        children: [
                          TableRow(children: [
                            Padding(
                              padding: Common.allPadding(mHeight: height * 0.9),
                              child: Container(
                                decoration: Common.containerBoxDecoration(),
                                height: 200,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.holiday_village_rounded,
                                      size: height * 0.09,
                                    ),
                                    Text("Select Village")
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: Common.allPadding(mHeight: height * 0.9),
                              child: InkWell(
                                child: Container(
                                  decoration: Common.containerBoxDecoration(),
                                  height: 200,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add_rounded,
                                        size: height * 0.09,
                                      ),
                                      Text("Add Patient")
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(context, routeAddpatient);
                                },
                              ),
                            ),
                          ]),
                          TableRow(children: [
                            Padding(
                              padding: Common.allPadding(mHeight: height * 0.9),
                              child: InkWell(
                                child: Container(
                                  decoration: Common.containerBoxDecoration(),
                                  height: 200,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.edit,
                                        size: height * 0.09,
                                      ),
                                      Text("Update Patient")
                                    ],
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, routeUpdatepatient);
                                },
                              ),
                            ),
                            Padding(
                              padding: Common.allPadding(mHeight: height * 0.9),
                              child: Container(
                                decoration: Common.containerBoxDecoration(),
                                height: 200,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline_rounded,
                                      size: height * 0.09,
                                    ),
                                    Text("Surveyor Profile")
                                  ],
                                ),
                              ),
                            ),
                          ])
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
