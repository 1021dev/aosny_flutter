import 'package:aosny_services/api/student_api.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/drawer/session_note.dart';
import 'package:flutter/material.dart';

class EnterSession extends StatefulWidget {
  
 final  List<LongTermGpDropDownModel> longTermGpDropDownList;
 final  List<ShortTermGpModel> shortTermGpList;

  const EnterSession({Key key, this.longTermGpDropDownList, this.shortTermGpList}) : super(key: key);
  @override
  _EnterSessionState createState() => _EnterSessionState();
}

class _EnterSessionState extends State<EnterSession> 
with SingleTickerProviderStateMixin {
 
  AnimationController _animationController;
  bool isBackArrow = false;
  StudentApi studentApi = new StudentApi();

  @override
  void initState() {
    super.initState();
    _animationController =
      AnimationController(vsync: this, 
      duration: Duration(milliseconds: 300)
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _handleOnPressed() {
    setState(() {
      isBackArrow = !isBackArrow;
      isBackArrow
        ? _animationController.forward()
        :  Navigator.of(context).pop();   
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text("Enter sessions",style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),),

        leading: IconButton(
          iconSize: 30,
          icon: AnimatedIcon(
            icon: AnimatedIcons.arrow_menu,
            progress: _animationController,
          ),
          onPressed: () => _handleOnPressed(),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child:  FutureBuilder(
          future: studentApi.getAllStudentsList(),
          builder: (BuildContext context ,
          AsyncSnapshot<List<StudentsDetailsModel>> snapshot) {
          
          

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      leading: Container(
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        child: Text(snapshot.data[index].firstName[0],
                        style: TextStyle(color:Colors.white),),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(80)
                        ),
                      ),
                      title:  Text( '${snapshot.data[index].firstName} ${snapshot.data[index].lastName}',
                        style: TextStyle(
                        ),
                      ),
                      subtitle: Text(snapshot.data[index].schoolName,
                        style: TextStyle(
                        ),
                      ) ,
                      onTap:(){
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context)=>SessionNote(
                          selectedStudentName: snapshot.data[index].firstName,
                          eventType: "Enter",
                          longTermGpDropDownList: widget.longTermGpDropDownList,
                          shortTermGpList: widget.shortTermGpList,
                        )));
                      } ,
                    ),
                    Divider()
                  ],
                );
              }
            );
          } 
        )
      ),
    );
  }
}


