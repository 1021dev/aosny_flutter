import 'package:aosny_services/screens/menu_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class SignatureScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignatureScreenState();
  }
}

class _SignatureScreenState extends State<SignatureScreen> {

  final SignatureController _controller = SignatureController(
    penStrokeWidth: 4,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  var _signatureCanvas;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _signatureCanvas = Signature(
      controller: _controller,
      backgroundColor: Colors.lightBlueAccent,
    );

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue[200],
        title: Text("Signature",style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),),
        actions: <Widget>[
          MaterialButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MenuScreen()),
              );
            },
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
      body: Container(
          padding: const EdgeInsets.all(10),
          child:  Container(
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.lightBlueAccent,
              width: MediaQuery.of(context).size.width,
            ),
          )
      ),
    );
  }
}