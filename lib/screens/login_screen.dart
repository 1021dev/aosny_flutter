import 'package:aosny_services/api/login_token_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/login_post_data_model.dart';
import 'package:aosny_services/models/login_response.dart';
import 'package:aosny_services/screens/menu_screen.dart';
import 'package:aosny_services/screens/signature_screen.dart';
import 'package:aosny_services/screens/signup_screem.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:package_info/package_info.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aosny_services/api/env.dart';
import 'package:url_launcher/url_launcher.dart';

import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LoginApi loginapiCall = new LoginApi();

  bool _isLoading = false;

  String emailString = "", passwordString = "";

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  SharedPreferences preferences;

  String buildNumber = '';
  String versionNumber = '';
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      setState(() {
        emailString = preferences.getString('userName');
        passwordString = preferences.getString('password');
        _emailController.text = emailString;
        _passwordController.text = passwordString;
      });
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      setState(() {
        versionNumber = packageInfo.version;
        buildNumber = packageInfo.buildNumber;
      });
      print(versionNumber);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double minWidth = width > height ? height : width;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: SingleChildScrollView(
                  child: Center(
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(42),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 200,
                                width: 200,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                    AssetImage("assets/logo/ic_logo.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  focusNode: emailFocus,
                                  validator: (val) {
                                    if (val.isEmpty) {
                                      return 'User Name is required';
                                    }
                                    return null;
                                  },
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.text,
                                  onFieldSubmitted: (text) {
                                    FocusScope.of(context).requestFocus(passwordFocus);
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Username',
                                    contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.email),
                                      onPressed: () {
                                        _emailController.clear();
                                      },
                                    ),
                                  ),
                                  controller: _emailController,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                height: MediaQuery.of(context).size.height * 0.08,
                                child: TextFormField(
                                  focusNode: passwordFocus,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Please Enter Password';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (text) async {
                                    FocusScope.of(context).unfocus();
                                  },
                                  autofocus: false,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    contentPadding:
                                    EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                    suffixIcon: Icon(Icons.lock,),
                                  ),
                                  controller: _passwordController,
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  FlatButton(
                                    child: Text(
                                      'Forgot password?',
                                      style: TextStyle(color: Colors.black54),
                                    ),
                                    onPressed: () {
                                      FocusScope.of(context).unfocus();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return ForgotPasswordScreen(
                                              userName: _emailController.text,
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 8.0),
                              InkWell(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 50,
                                  width: MediaQuery.of(context).size.width / 1.3,
                                  decoration: BoxDecoration(
                                      color: Colors.blue,
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: () async {
                                  setState(() {
                                    emailString = _emailController.text;
                                    passwordString = _passwordController.text;
                                  });

                                  if (_formKey.currentState.validate()) {
                                    print(emailString);
                                    print(passwordString);

                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    callLoginApi();
                                  }
                                },
                              ),
                              SizedBox(height: 8.0),
                              FlatButton(
                                child: Text(
                                  'Don\'t have an account? Sign Up',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                                  );
                                },
                              ),
                              privacyPolicyLinkAndTermsOfService(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 8,
                child: Text(
                  'App version: $versionNumber($buildNumber)',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget privacyPolicyLinkAndTermsOfService() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: 'By continuing, you agree to our ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
            children: <TextSpan>[
              TextSpan(
                text: 'Terms of Service',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    _launchURL(GlobalCall.terms);
                  },
              ),
              TextSpan(
                text: ' and ',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontSize: 14, color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        _launchURL(GlobalCall.privacy);
                      },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void callLoginApi() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _isLoading = true;
    });
    if (emailString == '' || passwordString == '') return;

    //var url = "http://aosapi.pdgcorp.com/api/Token";
    var url = baseURL + "Token";

    String singUpEmail = prefs.getString('signUpEmail') ?? '';
    String singUpPassword = prefs.getString('singUpPassword') ?? '';
    String email = '';
    String password = '';
    if (singUpEmail == _emailController.text && singUpPassword == _passwordController.text) {
      email = 'testuser';
      password = '123';
    } else {
      email = _emailController.text;
      password = _passwordController.text;
    }

    LoginTokenPost newPost = new LoginTokenPost(
      userName: email,
      password: password,
    );

    try {
      LoginResponse response = await loginapiCall.loginApiCall(url, body: newPost.toJson());
      GlobalCall.user = response;
      int codeVal = loginapiCall.statuscode;

      if(codeVal == 200){


        prefs.setInt('user_id', response.userId);
        prefs.setString('email', response.email);
        prefs.setString('userName', response.userName);
        prefs.setString('firstName', response.firstName);
        prefs.setString('lastName', response.lastName);
        prefs.setString('providerid', response.providerid);
        prefs.setString('token', response.token);
        prefs.setString('password', passwordString);

        print(response);
        GlobalCall.email = email;
        GlobalCall.name = response.userName;

        Fluttertoast.showToast(msg: 'Logged In Successfully',);
        setState(() {
          _isLoading = false;
        });
        GlobalCall.openDrawer = true;

        if ((response.signatureFilename ?? '') == '') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignatureScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuScreen()),
          );
        }

      } else {
        setState(() {
          _isLoading = false;
        });
        Fluttertoast.showToast(msg: response.message);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // String validateEmail(String value) {
  //   Pattern pattern =
  //       r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  //   RegExp regex = new RegExp(pattern);
  //   if (!regex.hasMatch(value))
  //     return 'Please Enter Valid Email Address';
  //   else
  //     return null;
  // }

  void handleTimeout() {
    if (GlobalCall.token.length > 33) {
      GlobalCall.openDrawer = true;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
        // MaterialPageRoute(builder: (context) => SignatureScreen()),
      );
    } else {
      // Navigator.pop(context);

      Alert(
        context: context,
        type: AlertType.info,
        title: "Alert",
        desc: "Invalid credentials",
        buttons: [
          DialogButton(
            child: Text(
              "Okay",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Color.fromRGBO(91, 55, 185, 1.0),
            radius: BorderRadius.circular(10.0),
          ),
        ],

      ).show();
    }
  }
}
