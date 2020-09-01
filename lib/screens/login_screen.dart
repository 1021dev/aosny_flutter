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
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aosny_services/api/env.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      preferences = value;
      setState(() {
        emailString = preferences.getString('email');
        passwordString = preferences.getString('password');
        _emailController.text = emailString;
        _passwordController.text = passwordString;
      });
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
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: true,
      body:
      ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: SafeArea(
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
                            validator: validateEmail,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            onFieldSubmitted: (text) {
                              FocusScope.of(context).requestFocus(passwordFocus);
                            },
                            decoration: InputDecoration(
                              hintText: 'Email',
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
                        SizedBox(height: 8.0),
//                        Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                          children: <Widget>[
//                            FlatButton(
//                              child: Text(
//                                'Forgot password?',
//                                style: TextStyle(color: Colors.black54),
//                              ),
//                              onPressed: () {},
//                            ),
//                          ],
//                        ),
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
                            'Don\'t you have an account? Sign Up',
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
                  text: 'By continuing, you agree to our ', style: TextStyle(
                  fontSize: 14, color: Colors.black
              ),
                  children: <TextSpan>[
                    TextSpan(
                        text: 'Terms of Service', style: TextStyle(
                      fontSize: 14, color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            _launchURL(GlobalCall.terms);
                          }
                    ),
                    TextSpan(
                        text: ' and ', style: TextStyle(
                        fontSize: 14, color: Colors.black
                    ),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'Privacy Policy', style: TextStyle(
                              fontSize: 14, color: Colors.black,
                              decoration: TextDecoration.underline
                          ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _launchURL(GlobalCall.privacy);
                                }
                          )
                        ]
                    )
                  ]
              )
          )
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
      email = 'test@gmail.com';
      password = '123';
    } else {
      email = _emailController.text;
      password = _passwordController.text;
    }

    LoginTokenPost newPost = new LoginTokenPost(
        email: email,
        password: password,
        createdDate: "",
        firstName: "",
        lastName: "",
        userId: 0);



    LoginResponse response = await loginapiCall.loginApiCall(url, body: newPost.toJson());

    int codeVal = loginapiCall.statuscode;

    if(codeVal == 200){


      prefs.setInt('user_id', response.userId);
      prefs.setString('email', response.email);
      prefs.setString('providerid', response.providerid);
      prefs.setString('token', response.token);
      prefs.setString('password', passwordString);

      print(response);

      Fluttertoast.showToast(msg: 'Logged In Successfully',);
      setState(() {
        _isLoading = false;
      });

//      Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(builder: (context) => SignatureScreen()),
//      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
      );
    } else {
      setState(() {
        _isLoading = false;
      });
      Fluttertoast.showToast(msg: response.message);
    }
  }

  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please Enter Valid Email Address';
    else
      return null;
  }

  void handleTimeout() {
    if (GlobalCall.token.length > 33) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MenuScreen()),
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
