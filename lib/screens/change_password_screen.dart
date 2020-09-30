import 'dart:convert';

import 'package:aosny_services/api/login_token_api.dart';
import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChangePasswordScreen extends StatefulWidget {

  ChangePasswordScreen({Key key,});
  @override
  State<StatefulWidget> createState() {
    return _ChangePasswordScreenState();
  }
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  TextEditingController _oldPasswordController = TextEditingController();
  FocusNode oldFocus = FocusNode();
  TextEditingController _newPasswordController = TextEditingController();
  FocusNode newFocus = FocusNode();
  TextEditingController _confirmPasswordController = TextEditingController();
  FocusNode confirmFocus = FocusNode();

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    oldFocus.dispose();
    _newPasswordController.dispose();
    newFocus.dispose();
    _confirmPasswordController.dispose();
    confirmFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Change Password'),
      ),
      drawer: DrawerWidget(),
      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              children: [
                SizedBox(height: 16,),
                Container(
                  child: TextFormField(
                    focusNode: oldFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (text) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Old Password',
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.lock_outline),
                        onPressed: () {
                          _oldPasswordController.clear();
                        },
                      ),
                    ),
                    obscureText: true,
                    controller: _oldPasswordController,
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  child: TextFormField(
                    focusNode: newFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (text) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'New Password',
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.lock_outline),
                        onPressed: () {
                          _newPasswordController.clear();
                        },
                      ),
                    ),
                    obscureText: true,
                    controller: _newPasswordController,
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  child: TextFormField(
                    focusNode: confirmFocus,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (text) {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      contentPadding:
                      EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.lock_outline),
                        onPressed: () {
                          _confirmPasswordController.clear();
                        },
                      ),
                    ),
                    obscureText: true,
                    controller: _confirmPasswordController,
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
                        'Change Password',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onTap: () async {
                      if (_oldPasswordController.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'Old password is required');
                        return;
                      }
                      if (_newPasswordController.text.isEmpty) {
                        Fluttertoast.showToast(msg: 'New password is required');
                        return;
                      }
                      if (_newPasswordController.text != _confirmPasswordController.text) {
                        Fluttertoast.showToast(msg: 'Confirm password doesn\'t match');
                        return;
                      }
                      setState(() {
                        isLoading = true;
                      });
                      http.Response response = await LoginApi().changePassword(oldPassword: _oldPasswordController.text, newPassword: _newPasswordController.text);
                      dynamic data = json.decode(response.body);
                      if (data is Map) {
                        if (data.containsKey('message')) {
                          Fluttertoast.showToast(msg: data['message']);
                        }
                      }
                      setState(() {
                        isLoading = false;
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