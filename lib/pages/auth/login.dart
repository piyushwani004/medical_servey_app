import 'package:flutter/material.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/widgets/common.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKeyEmailPass = GlobalKey<FormState>();
  var width, height;
  Map<String ,String> emailPassword = {};


  onLoginPressed(){
    if(formKeyEmailPass.currentState!.validate()){
      formKeyEmailPass.currentState!.save();
    }
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    final logo = Hero(
      tag: 'hero',
      child: Container(
        child: Image.asset(
          LOGO_PATH,
        ),
      ),
    );

    final email = TextFormField(
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (email){
        emailPassword["email"] = email!;
      },
      validator: (email) => emailValidator(email!),
      decoration: Common.textFormFieldInputDecoration(labelText: "Email"),
    );

    final password = TextFormField(
      validator: (password) => passwordValidator(password!),
      onSaved: (password){
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
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: Common.leftRightPadding(mHeight: height),
          children: <Widget>[
            logo,
            Form(
              key: formKeyEmailPass,
              child: Column(
                children: [
                  SizedBox(height: 48.0),
                  email,
                  SizedBox(height: 8.0),
                  password,
                ],
              ),
            ),
            SizedBox(height: 24.0),
            loginButton,
            forgotLabel
          ],
        ),
      ),
    );
  }
}
