
import 'package:aosny_services/api/login_token_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/login_post_data_model.dart';
import 'package:aosny_services/models/login_response.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aosny_services/api/env.dart';

import 'login_screen.dart';
import 'menu_screen.dart';

class SignUpScreen extends StatefulWidget {

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  LoginApi loginapiCall = new LoginApi();

  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();
  FocusNode nameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  SharedPreferences preferences;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
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
                              AssetImage('assets/logo/ic_logo.png'),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child:
                          TextFormField(
                            focusNode: nameFocus,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Name';
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            onFieldSubmitted: (text) {
                              FocusScope.of(context).requestFocus(emailFocus);
                            },
                            decoration: InputDecoration(
                              hintText: 'Name',
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.person),
                                onPressed: () {
                                  _nameController.clear();
                                },
                              ),
                            ),
                            controller: _nameController,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child:
                          TextFormField(
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
                              FocusScope.of(context).requestFocus(confirmPasswordFocus);
                            },
                            textInputAction: TextInputAction.next,
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
                        Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          child: TextFormField(
                            focusNode: confirmPasswordFocus,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please Enter Confirm Password';
                              }
                              if (value != _passwordController.text) {
                                return 'Confirm password does not match';
                              }
                              return null;
                            },
                            onFieldSubmitted: (text) async {
                              FocusScope.of(context).unfocus();
                            },
                            textInputAction: TextInputAction.done,
                            autofocus: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              suffixIcon: Icon(Icons.lock,),
                            ),
                            controller: _confirmPasswordController,
                          ),
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
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () async {
                            setState(() {
                            });

                            if (_formKey.currentState.validate()) {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              callLoginApi();
                            }
                          },
                        ),
                        SizedBox(height: 8.0),
                        FlatButton(
                          child: Text(
                            'Already have an account? Sign In',
                            style: TextStyle(color: Colors.black54),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
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
    );
  }

  void callLoginApi() async {


    setState(() {
      _isLoading = true;
    });
    if (_nameController.text == '' || _emailController.text == '' || _passwordController.text == '' || _confirmPasswordController.text == '') return;

    //var url = 'http://aosapi.pdgcorp.com/api/Token';
    var url = baseURL + 'Token';


    LoginTokenPost newPost = new LoginTokenPost(
      userName: 'testuser',
      password: '123',
    );



    LoginResponse response = await loginapiCall.loginApiCall(url, body: newPost.toJson());

    int codeVal = loginapiCall.statuscode;

    if(codeVal == 200){


      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setInt('user_id', response.userId);
      prefs.setString('email', response.email);
      prefs.setString('providerid', response.providerid);
      prefs.setString('signUpEmail', _emailController.text);
      prefs.setString('singUpPassword', _passwordController.text);
      prefs.setString('token', response.token);
      prefs.setString('password', _passwordController.text);
      prefs.setString('name', _nameController.text);

      GlobalCall.singUpEmil = _emailController.text;
      GlobalCall.name = _nameController.text;
      print(response);

      Fluttertoast.showToast(msg: 'Sign up successfully',);
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
    Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
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
        //style: alertStyle,
        type: AlertType.info,
        title: 'Alert',
        desc: 'Invalid credentials',
        buttons: [
          DialogButton(
            child: Text(
              'Okay',
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
