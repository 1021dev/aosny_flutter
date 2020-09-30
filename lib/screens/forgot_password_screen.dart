import 'dart:convert';

import 'package:aosny_services/api/login_token_api.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String userName;

  ForgotPasswordScreen({Key key, this.userName});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController _emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();

  bool isLoading = false;
  @override
  void initState() {
    if (widget.userName != null) {
      setState(() {
        _emailController.text = widget.userName;
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Forgot Password'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    focusNode: emailFocus,
                    validator: (val) {
                      if (val.isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (text) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'UserName',
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.person),
                        onPressed: () {
                          _emailController.clear();
                        },
                      ),
                    ),
                    controller: _emailController,
                  ),
                ),
                SizedBox(height: 16,),
                InkWell(
                    child: Container(
                      alignment: Alignment.center,
                      height: 50,
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30)),
                      child: Text(
                        'Request',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (_emailController.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'Username is required');
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      http.Response response = await LoginApi().forgetPassword(userName: _emailController.text);
                      dynamic data = json.decode(response.body);
                      if (data is Map) {
                        if (data.containsKey('message')) {
                          Fluttertoast.showToast(msg: data['message']);
                        }
                      }
                      setState(() {
                        isLoading = false;
                      });
                      Future.delayed(Duration(milliseconds: 300)).then((value) {
                        Navigator.pop(context);
                      });
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
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

}