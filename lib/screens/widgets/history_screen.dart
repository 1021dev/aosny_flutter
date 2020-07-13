import 'dart:async';

import 'package:aosny_services/api/history_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/add_edit_session_note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final StreamController<bool> loadStudents;
  final StreamController<bool> loadCategoires;

  const HistoryScreen(
      {
        Key key,
        this.loadStudents,
        this.loadCategoires,
      })
      : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with AutomaticKeepAliveClientMixin<HistoryScreen> {
  @override
  bool get wantKeepAlive => true;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  String selectedStartDate = '';
  String selectedEndDate = '';
  String startDate ="";
  String endDate="";
  bool isStartDate= false;
  bool isEndDate=  false;

  String displayStartDate = "Start Date";
  String displayEndDate = "End Date";

  String dropDownValue, studentID;
  bool isFiltered = false;
  HistoryApi historyApi = new HistoryApi();

  bool isStudentsLoad = false;
  bool isCategoryLoad = false;

  @override
  void initState() {

    endDate  =   DateFormat('MM/dd/yyyy').format(GlobalCall.endDate).toString();
    print("DateFormat currentDate:::"+'$endDate');

    selectedEndDate = endDate;
    startDate  =  DateFormat('MM/dd/yyyy').format(GlobalCall.startDate).toString();

    selectedStartDate = startDate;
    print("before 7 days::::"+startDate.toString());

    setState(() {
      isStartDate = true;
      isEndDate   = true;
    });

    if (widget.loadStudents != null) {
      widget.loadCategoires.stream.listen((event) {
        setState(() {
          isCategoryLoad = event;
        });
      });

      widget.loadStudents.stream.listen((event) {
        setState(() {
          isStudentsLoad = event;
        });
      });
    }
    super.initState();
  }

  showDateTimePicker(String whichStringType, DateTime date) async {
    final datePick = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    );
    if (whichStringType == 'Start Date') {
      if (datePick != null && datePick != selectedStartDate) {
        setState(() {
          GlobalCall.startDate = datePick;
          startDate = DateFormat('MM/dd/yyyy').format(GlobalCall.startDate);
          isStartDate= true;
          print('startdate');
        });
      }
    } else {
      if (datePick != null && datePick != selectedEndDate) {
        setState(() {
          GlobalCall.endDate = datePick;
          endDate = DateFormat('MM/dd/yyyy').format(GlobalCall.endDate);
          isEndDate =true;
          print('enddate');
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    var _firstDayOfTheweek = DateFormat('MM/d/yyyy')
        .format(today.subtract(new Duration(days: today.weekday)));
    var _lastDayOfTheweek = DateFormat('MM/d/yyyy')
        .format(today.subtract(new Duration(days: today.weekday)));

    print(
        "_firstDayOfTheweek _firstDayOfTheweek _firstDayOfTheweek:$_firstDayOfTheweek");

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
        child: Column(
          mainAxisAlignment:  MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  GlobalCall.filterDates ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text('Start Date'),
                            ),
                            FlatButton(
                              color: Colors.blue,
                              onPressed: () async {
                                showDateTimePicker('Start Date', GlobalCall.startDate);
                              },
                              child: isStartDate ?
                              Text(
                                startDate,
                                style: TextStyle(color:Colors.white),
                              ) :
                              Text(
                                "Select Start Date",
                                style: TextStyle(color:Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                      ),
                      Flexible(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(
                              child: Text('End Date'),
                            ),
                            FlatButton(
                              color: Colors.blue,
                              onPressed: () {
                                showDateTimePicker('End Date', GlobalCall.endDate);
                              },
                              //child:  Text( "Select End Date",
                              //  style: TextStyle(color:Colors.white),
                              child: isEndDate ?
                              Text(
                                endDate,
                                style: TextStyle(color:Colors.white),
                              ) :
                              Text(
                                "Select End Date",
                                style: TextStyle(color:Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ): Container(),
                  GlobalCall.filterStudents ? Container(
                    alignment: Alignment.center,
                    height: 40,
                    padding: const EdgeInsets.all(5),
                    color: Colors.white,
                    child: DropdownButton(
                      underline: Container(),
                      hint: dropDownValue == null
                          ? Text("Students")
                          : Text(
                        dropDownValue,
                        style: TextStyle(color: Colors.black),
                      ),
                      isExpanded: true,
                      elevation: 5,
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 30.0,
                      style: TextStyle(color: Colors.black),
                      items: GlobalCall.globaleStudentList.map(
                            (val) {
                          return DropdownMenuItem<StudentsDetailsModel>(
                            value: val,
                            child: Text(
                                val.firstName + " " + val.lastName),
                          );
                        },
                      ).toList(),
                      onChanged: (val) {
                        setState(
                              () {
                            dropDownValue =
                                val.firstName + " " + val.lastName;
                            studentID = val.id.toString();
                            print(studentID);
                          },
                        );
                      },
                    ),
                  ) : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Divider(height: 0, thickness: 0.5,),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: RefreshIndicator(
                  key: refreshKey,
                  child: FutureBuilder<List<HistoryModel>>(
                      future: historyApi.getHistoryList(
                          sdate: startDate, endDate: endDate),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<HistoryModel>> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        if (snapshot.data.length > 0) {
                          return Container(
                            alignment: Alignment.center,
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                itemCount: snapshot.data.length,
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 60),
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Text(
                                          DateFormat('EEEE, MMMM d').format(
                                              DateTime.parse(
                                                  '${snapshot.data[index].sdate.split('/')[2]}-${snapshot.data[index].sdate.split('/')[0]}-${snapshot.data[index].sdate.split('/')[1]}')),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                          ),
                                      ),
                                      SizedBox(height: 4),

                                      snapshot.data[index].fname ==
                                          'School Closed'
                                          ? Container(
                                        padding: const EdgeInsets.only(left: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.orange,
                                            borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "School Closed",
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.bold,
                                                  fontSize: 20,
                                              ),
                                            ),
                                            IconButton(
                                                icon: Icon(Icons.cancel),
                                                color: Colors.red,
                                                onPressed: () {},
                                            )
                                          ],
                                        ),
                                      )
                                          : GestureDetector(
                                        onTap: () {
                                          GlobalCall.sessionID = snapshot.data[index].iD.toString();
                                          String studentId = snapshot.data[index].osis.toString().replaceAll('-', '');
                                          int id = int.parse(studentId);
                                          StudentsDetailsModel studentsDetailsModel = getStudent(id);
                                          if (studentsDetailsModel == null) {
                                            return ;
                                          }
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => AddEditSessionNote(
                                                eventType: "Edit",
                                                student: studentsDetailsModel,
                                                sessionId: snapshot.data[index].iD.toString(),
                                                selectedStudentName: snapshot.data[index].fname + ' ' + snapshot.data[index].lname,
                                                noteText: snapshot.data[index].notes,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            border:Border.all(width:0.5),
                                          ),
                                          child: Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '${snapshot.data[index].stime} - ${snapshot.data[index].etime}',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    child: Icon(
                                                      Icons.check_circle,
                                                      color: Colors.green,
                                                    ),
                                                    onTap: () {},
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    '${snapshot.data[index].fname} ${snapshot.data[index].lname}',
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                  ),
//                                                editButton(context,
//                                                    snapshot.data[index]),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }),
                            // margin: EdgeInsets.fromLTRB(0, 0, 0,20),
                          );
                        } else {
                          return Center(
                            child: Text("No data found. Please check dates and/or filters."),
                          );
                        }
                      }
                  ),
                  onRefresh: refreshList,
                ),
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget editButton(BuildContext context, HistoryModel data) {
    return InkWell(
        onTap: () {
          GlobalCall.sessionID =  data.iD.toString();
          String studentId = data.osis.toString().replaceAll('-', '');
          int id = int.parse(studentId);
          StudentsDetailsModel studentsDetailsModel = getStudent(id);
          if (studentsDetailsModel == null) {
            return ;
          }
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AddEditSessionNote(
                eventType: "Edit",
                student: studentsDetailsModel,
                sessionId: data.iD.toString(),
                selectedStudentName: data.fname + ' ' + data.lname,
                noteText: data.notes,
              ),
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          height: 44,
          width: MediaQuery.of(context).size.width / 5.0,
          decoration: BoxDecoration(
              color: Color(0xff4A4A4A), borderRadius: BorderRadius.circular(2)),
          child: Text(
            "Edit",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  StudentsDetailsModel getStudent(int id) {
    List<StudentsDetailsModel> list = GlobalCall.globaleStudentList.where((element) => element.studentID.toInt() == id).toList();
    if (list != null && list.length > 0) {
      return list.first;
    } else {
      return null;
    }
  }

  Widget listOfFilter() {
    List filteredList = List();
    return Container(
      height: MediaQuery.of(context).size.height / 2.8,
      width: MediaQuery.of(context).size.width / 1.7,
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height / 20, //17
                  decoration: BoxDecoration(),
                  child: CheckboxListTile(
                    title: Text(
                      filteredList[index].filterText,
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 60),
                    ),
                    value: filteredList[index].checkBox,
                    onChanged: (newValue) {
                      setState(() {
                        filteredList[index].checkBox = newValue;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, //  <-- leading Checkbox
                  )),
              Divider(color: Colors.black)
            ],
          );
        },
      ),
    );
  }



  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 4));

    setState(() {
      historyApi.getHistoryList(
          sdate: selectedStartDate, endDate: selectedEndDate);

      print("pull api called");
    });

    return null;
  }
}

class FilteredList {
  String filterText;
  bool checkBox;
  FilteredList({this.filterText, this.checkBox});
}
