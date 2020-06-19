import 'package:aosny_services/api/history_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/history_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:aosny_services/screens/widgets/drawer/drawer_widget.dart';
import 'package:aosny_services/screens/widgets/drawer/session_note.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final List<LongTermGpDropDownModel> longTermGpDropDownList;
  final List<ShortTermGpModel> shortTermGpList;

  const HistoryScreen(
      {Key key, this.longTermGpDropDownList, this.shortTermGpList})
      : super(key: key);
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  String selectedStartDate = '09/01/2019';
  String selectedEndDate = '11/01/2019';
  String startDate ="";
  String endDate="";
  bool isStartDate= false;
  bool isEndDate=  false;

  String displayStartDate = "Start Date";
  String displayEndDate = "End Date";

  String dropDownValue, studentID;
  bool isFiltered = false;
  HistoryApi historyApi = new HistoryApi();

  List<FilteredList> filteredList = [
    FilteredList(
      filterText: "Incomplete",
      checkBox: false,
    ),
    FilteredList(
      filterText: "Student Absent",
      checkBox: false,
    ),
    FilteredList(
      filterText: "Student Unavailable",
      checkBox: false,
    ),
    FilteredList(
      filterText: "Provider Absent",
      checkBox: false,
    ),
    FilteredList(
      filterText: "Complete",
      checkBox: false,
    ),
    FilteredList(
      filterText: "Make-up",
      checkBox: false,
    ),
  ];

  @override
  void initState() {

   endDate  =   DateFormat('MM/dd/yyyy').format(DateTime.now()).toString();
    print("DateFormat currentDate:::"+'$endDate');
    
    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 7));

   startDate  =  DateFormat('MM/dd/yyyy').format(fiftyDaysAgo).toString();
    
    print("before 7 days::::"+startDate.toString());

    setState(() {

      isStartDate = false;
      isEndDate   = false;

    });
    super.initState();
    
  }

  showDateTimePicker(String whichStringType) async {
    final datePick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2030),
    );
    if (whichStringType == 'Start Date') {
      if (datePick != null && datePick != selectedStartDate) {
        setState(() {
          startDate = DateFormat('MM/dd/yyyy').format(datePick);
          isStartDate= true;
          print('startdate');
        });
      }
    } else {
      if (datePick != null && datePick != selectedEndDate) {
        setState(() {
          endDate = DateFormat('MM/dd/yyyy').format(datePick);
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
      backgroundColor: Colors.grey[300],
      drawer: DrawerWidget(),
      body:
         Container(
          padding: const EdgeInsets.only(left: 15, right: 15, top: 8),
          
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment:  MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    isFiltered
                        ? Container(
                            alignment: Alignment.center,
                            height: 40,
                            width: 165,
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
                          )
                        : Container(),
                    IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() {
                            isFiltered = !isFiltered;
                          });
                        }),
                  ],
                )),
                isFiltered
                    ?
                    // listOfFilter()
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FlatButton(
                              color: Colors.blueGrey,
                              onPressed: () async {
                                showDateTimePicker('Start Date');
                              },
                              child: isStartDate ? Text(startDate,style: TextStyle(color:Colors.white)) : Text("Select Start Date",style: TextStyle(color:Colors.white),)
                              
                             /* Text(
                                selectedStartDate == '09/01/2019'
                                    ? "Select Start Date"
                                    : selectedStartDate,
                                style: TextStyle(color: Colors.white),
                              )),*/
                          ),
                          FlatButton(
                              color: Colors.blueGrey,
                              onPressed: () {
                                showDateTimePicker('End Date');
                              },
                              //child:  Text( "Select End Date",
                              //  style: TextStyle(color:Colors.white),
                              child: isEndDate ? Text(endDate,style: TextStyle(color:Colors.white)) : Text("Select End Date",style: TextStyle(color:Colors.white),)
                              /*Text(
                                selectedEndDate == '11/01/2019'
                                    ? "Select End Date"
                                    : selectedEndDate,
                                style: TextStyle(color: Colors.white),
                              )*/
                              )
                        ],
                      )
                    : Container(),
                SizedBox(height: isFiltered ? 60 : 0),
                RefreshIndicator(
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 10),
                                      Text(
                                          DateFormat('EEEE, MMMM d').format(
                                              DateTime.parse(
                                                  '${snapshot.data[index].sdate.split('/')[2]}-${snapshot.data[index].sdate.split('/')[0]}-${snapshot.data[index].sdate.split('/')[1]}')),
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10)),
                                      SizedBox(height: 4),

                                      snapshot.data[index].fname ==
                                              'School Closed'
                                          ? Container(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  20,
                                              decoration: BoxDecoration(
                                                  color: Colors.orange,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Text(
                                                    "School Closed",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 20),
                                                  ),
                                                  IconButton(
                                                      icon: Icon(Icons.cancel),
                                                      color: Colors.red,
                                                      onPressed: () {})
                                                ],
                                              ),
                                            )
                                          : Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  6.9,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Column(
                                                children: <Widget>[
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        '${snapshot.data[index].stime} - ${snapshot.data[index].etime}',
                                                        style: TextStyle(
                                                            fontSize: 11),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Text(
                                                        '${snapshot.data[index].fname} ${snapshot.data[index].lname}',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      ),
                                                      Text(
                                                        'Session Note Entered',
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize: 11),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                              "Torah V'daath Ave",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: Colors
                                                                      .grey)),
                                                          Text(
                                                            "L",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          )
                                                        ],
                                                      ),
                                                      editButton(context,
                                                          snapshot.data[index]),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                      // SizedBox(height:30),
                                      //Divider(color:Colors.grey,height: 10,),
                                    ],
                                  );
                                }),
                            // margin: EdgeInsets.fromLTRB(0, 0, 0,20),
                          );
                        } else {
                          return Center(
                            child: Text("Haven't found any data"),
                          );
                        }
                      }),
                  onRefresh: refreshList,
                )
              ],
            ),
          ),
        ),
     // ),
    );
  }

  Widget editButton(BuildContext context, var data) {
    return InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => SessionNote(
                    eventType: "Edit",
                    selectedStudentName: data.fname + ' ' + data.lname,
                    noteText: data.notes,
                    longTermGpDropDownList: widget.longTermGpDropDownList,
                    shortTermGpList: widget.shortTermGpList,
                  )));
        },
        child: Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 22,
          width: MediaQuery.of(context).size.width / 5.0,
          decoration: BoxDecoration(
              color: Color(0xff4A4A4A), borderRadius: BorderRadius.circular(2)),
          child: Text(
            "Edit",
            style: TextStyle(color: Colors.white),
          ),
        ));
  }

  Widget listOfFilter() {
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
