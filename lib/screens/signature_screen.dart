import 'dart:convert';
import 'dart:typed_data';

import 'package:aosny_services/api/login_token_api.dart';
import 'package:aosny_services/screens/menu_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignatureScreenState();
  }
}

class _SignatureScreenState extends State<SignatureScreen> {

  bool _isLoading = false;
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool loaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await showDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text(
            'Please turn your phone sideways and sign the screen',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          content: Text(
            'Your digital signature will be kept on file and used when you submit reports and invoices',
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                'Ok',
              ),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        )
      );
    });
  }

  showPopUp() async {
    setState(() {
      loaded = true;
    });
    await showDialog(context: context, builder: (context) {
      return CupertinoAlertDialog(
        title: Text(
          'Please turn your phone sideways and sign the screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        content: Text(
          'Your digital signature will be kept on file and used when you submit reports and invoices',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            child: Text(
              'Ok',
            ),
            onPressed: () async {
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          'Signature',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              _controller.clear();
            },
            minWidth: 0,
            child: Text(
              'Clear',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
            },
            minWidth: 0,
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          MaterialButton(
            onPressed: () async {
              if (_controller.isEmpty) {
                setState(() {
                  _isLoading = false;
                });
                return;
              }
              setState(() {
                _isLoading = true;
              });
              Uint8List bytes = await _controller.toPngBytes();
              LoginApi loginapiCall = new LoginApi();
              dynamic response = await loginapiCall.postSignature(base: base64Encode(bytes));
              setState(() {
                _isLoading = false;
              });

              if (response.statusCode == 200) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              }
            },
            minWidth: 0,
            child: Text(
              'Done',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16
              ),
            ),
          )
        ],
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Container(
          padding: const EdgeInsets.all(10),
          child:  Container(
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.lightBlueAccent,
              width: MediaQuery.of(context).size.width,
            ),
          ),
        ),
      ),
    );
  }
}