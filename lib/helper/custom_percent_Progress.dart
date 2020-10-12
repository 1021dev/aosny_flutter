import 'dart:math';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter{
  double currentProgress;
  CircleProgress(this.currentProgress);

  @override
  void paint(Canvas canvas, Size size) {

    //this is base circle
    Paint outerCircle = Paint()
      ..strokeWidth = 10
      ..color = Colors.black
      ..style = PaintingStyle.stroke;

    Paint completeArc = Paint()
      ..strokeWidth = 10
      ..color = Colors.redAccent
      ..style = PaintingStyle.stroke
      ..strokeCap  = StrokeCap.round;

    Offset center = Offset(size.width/2, size.height/2);
    double radius = min(size.width/2,size.height/2) - 10;

    canvas.drawCircle(center, radius, outerCircle); // this draws main outer circle

    double angle = 2 * pi * (currentProgress/100);

    canvas.drawArc(Rect.fromCircle(center: center,radius: radius), -pi/2, angle, false, completeArc);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class CreateProgressBarTime extends StatefulWidget {
  @override
  _CreateProgressBarTimeState createState() => _CreateProgressBarTimeState();
}

class _CreateProgressBarTimeState extends State<CreateProgressBarTime> with SingleTickerProviderStateMixin {
   AnimationController progressController;
  Animation animation;

  @override
  void initState() {
    super.initState();
    progressController = AnimationController(TickerProvider: this,duration: Duration(milliseconds: 1000));
    animation = Tween(begin: 0,end: 80).animate(progressController)..addListener((){
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          foregroundPainter: CircleProgress(animation.value), // this will add custom painter after child
          child: Container(
            width: 200,
            height: 200,
            child: GestureDetector(
                onTap: (){
                  if(animation.value == 80){
                    progressController.reverse();
                  }else {
                    progressController.forward();
                  }
                },
                child: Center(child: Text("${animation.value.toInt()}%",style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ),))),
          ),
        ),

      ),
    );
  }
}


/*
  it will check , has internet connectivity or not
*/

Future<bool> check() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}


