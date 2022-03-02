import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medical_servey_app/Services/Common/auth_service.dart';
import 'package:medical_servey_app/Services/Surveyor/village_select_service.dart';
import 'package:medical_servey_app/models/common/Responce.dart';
import 'package:medical_servey_app/utils/constants.dart';
import 'package:medical_servey_app/utils/functions.dart';
import 'package:medical_servey_app/utils/image_utils.dart';
import 'package:medical_servey_app/widgets/common.dart';
import 'package:medical_servey_app/widgets/loading.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _textControllerEmail = TextEditingController();
  final TextEditingController _textControllerPassword = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final formKeyEmailPass = GlobalKey<FormState>();
  VillageSelectService sharePrefrenceService = VillageSelectService();
  var width, height;
  Map<String, String> emailPassword = {};
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  Loading? _loading;
  bool _obscureText = true;
  bool _isChecked = false;

  onLoginPressed() async {
    if (formKeyEmailPass.currentState!.validate()) {
      _loading?.on();
      formKeyEmailPass.currentState!.save();

      Response isSignedIn = await context.read<FirebaseAuthService>().signIn(
          email: emailPassword['email'] ?? '',
          password: emailPassword['password'] ?? '');

      if (isSignedIn.isSuccessful) {
        sharePrefrenceService.setLoginDetails(
          rememberMe: _isChecked,
          password: _textControllerPassword.text,
          email: _textControllerEmail.text,
        );
        _loading?.off();
        showSnackBar(context, isSignedIn.message);
      } else {
        _loading?.off();
        showSnackBar(context, isSignedIn.message);
      }
    }
  }

  onForgotPressed() async {
    bool isEmailValid =
        emailValidator(_textControllerEmail.text) == null ? true : false;
    if (isEmailValid) {
      Response emailSent = await context
          .read<FirebaseAuthService>()
          .sendPasswordResetEmail(_textControllerEmail.text);
      if (emailSent.isSuccessful) {
        Common.showAlert(
            context: context,
            title: "Forget Password",
            content: emailSent.message,
            isError: false);
      } else {
        Common.showAlert(
            context: context,
            title: "Forget Password",
            content: emailSent.message,
            isError: true);
      }
    } else {
      showSnackBar(context, "Invalid Email");
    }
  }

  _handleRemeberme(bool value) {
    print("Handle Rember Me");
    _isChecked = value;
    sharePrefrenceService.getLoginDetails();
    setState(() {
      _isChecked = value;
    });
  }

  _loadUserEmailPassword() async {
    print("Load Email");
    try {
      Map<String, String> map = await sharePrefrenceService.getLoginDetails();
      String _email = map[EMAIL] ?? "";
      String _password = map[PASSWORD] ?? "";
      String val = map[REMEMBER_ME] ?? "";
      bool _remeberMe = val.parseBool();

      print(_remeberMe);
      print(_email);
      print(_password);

      if (_remeberMe) {
        setState(() {
          _isChecked = true;
        });
        _textControllerEmail.text = _email;
        _textControllerPassword.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    _loading = Loading(context: context, key: _keyLoader);
    _loadUserEmailPassword();
    super.initState();
  }

  @override
  void dispose() {
    _textControllerEmail.dispose();
    super.dispose();
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
      controller: _textControllerEmail,
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      onSaved: (email) {
        emailPassword["email"] = email!;
      },
      validator: (email) => emailValidator(email!),
      decoration: InputDecoration(
          hintText: 'Email',
          contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          label: Text("Email"),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          prefixIcon: Icon(Icons.email_outlined)),
    );

    final password = TextFormField(
      onSaved: (password) {
        emailPassword["password"] = password!;
      },
      validator: (value) => value!.isEmpty ? 'Password cannot be blank' : null,
      autofocus: false,
      controller: _textControllerPassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        label: Text("Password"),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
        prefixIcon: Icon(Icons.lock_open_rounded),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            semanticLabel: _obscureText ? 'show password' : 'hide password',
          ),
        ),
      ),
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
      onPressed: () {
        onForgotPressed();
      },
    );

    final createdByText = Text(
      "$CREATEDBY",
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );

    final templateText = Text(
      "$TEMPLATE",
      style: TextStyle(
        fontSize: 12,
      ),
    );

    final companyNameText = Text(
      "$COMPANYNAME",
      style: TextStyle(
          fontSize: 12,
          color: Colors.blue,
          decoration: TextDecoration.underline),
    );

    return Scaffold(
      backgroundColor: Color.fromRGBO(234, 242, 255, 1.0),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(size.height > 770
              ? 10
              : size.height > 670
                  ? 20
                  : 16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(25),
                      ),
                    ),
                    child: Form(
                      key: formKeyEmailPass,
                      child: Center(
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
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
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                          height: 24.0,
                                          width: 24.0,
                                          child: Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor: Color(
                                                    0xff00C8E8) // Your color
                                                ),
                                            child: Checkbox(
                                              activeColor: Color(0xff00C8E8),
                                              value: _isChecked,
                                              onChanged: (value) =>
                                                  _handleRemeberme(value!),
                                            ),
                                          )),
                                      SizedBox(width: 10.0),
                                      Text("Remember Me",
                                          style: TextStyle(
                                              color: Color(0xff646464),
                                              fontSize: 12,
                                              fontFamily: 'Rubic'))
                                    ]),
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
                SizedBox(
                  height: size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(child: createdByText),
                    Flexible(
                      child: InkWell(
                          onTap: () {
                            launchURL();
                          },
                          child: companyNameText),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
