import 'package:flutter/material.dart';
import 'package:medical_servey_app/routes/routes.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/Services/Surveyor/surveyor_firebase_service.dart';
import 'package:medical_servey_app/models/Admin/surveyor.dart';

class SurveyorProfie extends StatefulWidget {
  SurveyorProfie({Key? key}) : super(key: key);

  @override
  _SurveyorProfieState createState() => _SurveyorProfieState();
}

class _SurveyorProfieState extends State<SurveyorProfie> {
  SurveyorFirebaseService _surveyorFirebaseService = SurveyorFirebaseService();
  var width, height;

  Surveyor? user;

  int counter = 0;

  getProfileDetails() async {
    user = await _surveyorFirebaseService.getSurveyorDetails();
    setState(() {});
  }

  @override
  void initState() {
    getProfileDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: user != null
              ? body()
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
    );
  }

  Widget body() {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 131, 96, 228),
                      Colors.deepPurpleAccent
                    ],
                  ),
                ),
                child: Column(children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back)),
                  ),
                  SizedBox(
                    height: 80.0,
                  ),
                  CircleAvatar(
                    radius: 65.0,
                    backgroundImage: AssetImage(LOGO_PATH),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text('${user!.firstName} ${user!.lastName}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    '${user!.email}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.0,
                    ),
                  )
                ]),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.grey[200],
                child: Center(
                    child: Card(
                        margin: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                        child: Container(
                            width: 310.0,
                            height: 290.0,
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Information",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Divider(
                                      color: Colors.grey[300],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          color: Colors.blueAccent[400],
                                          size: 35,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Address",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              "${user!.address}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.auto_awesome,
                                          color: Colors.yellowAccent[400],
                                          size: 35,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Aadhaar Number",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              "${user!.aadhaarNumber}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.call,
                                          color: Colors.pinkAccent[400],
                                          size: 35,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Mobile Number",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              "${user!.mobileNumber}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.holiday_village,
                                          color: Colors.lightGreen[400],
                                          size: 35,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Village",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              "${user!.villageToAssign}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.date_range,
                                          color: Colors.lightGreen[400],
                                          size: 35,
                                        ),
                                        SizedBox(
                                          width: 20.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Profession",
                                              style: TextStyle(
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text(
                                              "${user!.profession}",
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                color: Colors.grey[400],
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )))),
              ),
            ),
          ],
        ),
        Positioned(
            top: MediaQuery.of(context).size.height * 0.45,
            left: 20.0,
            right: 20.0,
            child: Card(
                child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                      child: Column(
                    children: [
                      Text(
                        'Age',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        "${user!.age}",
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  )),
                  Container(
                    child: Column(children: [
                      Text(
                        'Gender',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${user!.gender}',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )
                    ]),
                  ),
                  Container(
                      child: Column(
                    children: [
                      Text(
                        'Joining Date',
                        style:
                            TextStyle(color: Colors.grey[400], fontSize: 14.0),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Text(
                        '${user!.joiningDate}',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      )
                    ],
                  )),
                ],
              ),
            )))
      ],
    );
  }
}
