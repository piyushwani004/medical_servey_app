import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Common/auth_service.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKeyEmailPass = GlobalKey<FormState>();
  var width, height;
  Map<String, String> emailPassword = {};

  onLoginPressed() async {
    if (formKeyEmailPass.currentState!.validate()) {
      formKeyEmailPass.currentState!.save();

      String isSignedIn = await context.read<FirebaseAuthService>().signIn(
          email: emailPassword['email'] ?? '',
          password: emailPassword['password'] ?? '');

      print(isSignedIn);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final logo = Hero(
      tag: 'hero',
      child: Container(
        height: size.height * 0.25,
        width: size.width * 0.3,
        child: Image.asset(
          LOGO_PATH,
        ),
      ),
    );
    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (email) {
        emailPassword["email"] = email!;
      },
      validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );

    final password = TextFormField(
      onSaved: (password) {
        emailPassword["password"] = password!;
      },
      autofocus: false,
      obscureText: true,
      decoration: Common.textFormFieldInputDecoration(labelText: "Password"),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: OutlinedButton(
        style: Common.buttonStyle(),
        onPressed: () {
          onLoginPressed();
        },
        child: Text('Log In', style: TextStyle(color: Colors.blue)),
      ),
    );

    final forgotLabel = TextButton(
      child: Text(
        'Forgot password?',
        style: TextStyle(color: Colors.black54),
      ),
      onPressed: () {},
    );

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 223, 222, 221),
      body: Padding(
        padding: EdgeInsets.all(size.height > 770
            ? 64
            : size.height > 670
                ? 32
                : 16),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(25),
              ),
            ),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: size.height *
                  (size.height > 770
                      ? 0.7
                      : size.height > 670
                          ? 0.8
                          : 0.9),
              width: 500,
              color: Colors.white,
              child: Form(
                key: formKeyEmailPass,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          logo,
                          Text(
                            "LOG IN",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[700],
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Container(
                            width: 30,
                            child: Divider(
                              color: kPrimaryColor,
                              thickness: 2,
                            ),
                          ),
                          SizedBox(
                            height: 32,
                          ),
                          email,
                          SizedBox(
                            height: 32,
                          ),
                          password,
                          SizedBox(
                            height: 24,
                          ),
                          Align(
                              alignment: Alignment.centerRight,
                              child: forgotLabel),
                          SizedBox(
                            height: 10,
                          ),
                          loginButton,
                          SizedBox(
                            height: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
