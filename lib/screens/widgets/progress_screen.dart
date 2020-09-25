import 'package:aosny_services/bloc/bloc.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:sprintf/sprintf.dart';

class ProgressScreen extends StatefulWidget {
  final MainScreenBloc mainScreenBloc;

  ProgressScreen({this.mainScreenBloc});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();

}

class _ProgressScreenState extends State<ProgressScreen> with AutomaticKeepAliveClientMixin<ProgressScreen> {
  @override
  bool get wantKeepAlive => true;


  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isFiltered = false;

  String dropDownValue, studentID;
  String startDate ='';
  String endDate='';
  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  showDateTimePicker(String whichStringType)async{

    if(whichStringType == 'Start Date'){
      final datePick= await showDatePicker(
        context: context,
        initialDate: GlobalCall.proStartDate ?? DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
      );
      if(datePick != null && datePick != GlobalCall.proStartDate){
        setState(() {
          GlobalCall.proStartDate = datePick;
          startDate = DateFormat('MM/dd/yyyy').format(datePick);
          DateTime sevenDaysAgo = GlobalCall.proStartDate.add(new Duration(days: 7));
          GlobalCall.proEndDate = sevenDaysAgo;
          endDate = DateFormat('MM/dd/yyyy').format(sevenDaysAgo);
        });
        widget.mainScreenBloc.add(GetProgressEvent(startDate: startDate, endDate: endDate));
      }

    }else{
      print(GlobalCall.proEndDate);
      final datePick= await showDatePicker(
        context: context,
        initialDate: GlobalCall.proEndDate ?? DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
      );
      if(datePick != null && datePick != GlobalCall.proEndDate){
        setState(() {
          GlobalCall.proEndDate = datePick;
          endDate = DateFormat('MM/dd/yyyy').format(datePick);
          DateTime sevenDaysAgo = GlobalCall.proEndDate.subtract(new Duration(days: 7));
          GlobalCall.proStartDate = sevenDaysAgo;
          startDate = DateFormat('MM/dd/yyyy').format(sevenDaysAgo);
        });
        if (startDate != null) {
          widget.mainScreenBloc.add(GetProgressEvent(startDate: startDate, endDate: endDate));
        }
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener(
      cubit: widget.mainScreenBloc,
      listener: (BuildContext context, MainScreenState state) async {
      },
      child: BlocBuilder<MainScreenBloc, MainScreenState>(
          cubit: widget.mainScreenBloc,
          builder: (BuildContext context, MainScreenState state) {
            List<StudentsDetailsModel> students = [];
            GlobalCall.globaleStudentList.forEach((element) {
              bool isContain = false;
              students.forEach((student) {
                if (student.firstName == element.firstName && student.lastName == element.lastName) {
                  isContain = true;
                }
              });
              if (!isContain) {
                students.add(element);
              }
            });
            return Scaffold(
              backgroundColor: Colors.grey[100],
              body: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    GlobalCall.filterDates ?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text('Start Date', style: TextStyle(fontSize: 12),),
                              ),
                              FlatButton(
                                color: Colors.blue,
                                onPressed: () async {
                                  showDateTimePicker('Start Date');
                                },
                                child: Text(
                                  startDate,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Flexible(
                                child: Text('End Date', style: TextStyle(fontSize: 12),),
                              ),
                              FlatButton(
                                color: Colors.blue,
                                onPressed: (){
                                  showDateTimePicker('End Date');
                                },
                                child: Text(
                                  endDate,
                                  style: TextStyle(
                                    color:Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                        :Container(),
                    SizedBox(height: 8,),
                    GlobalCall.filterStudents ? Container(
                      alignment: Alignment.center,
                      height: 40,
                      padding: const EdgeInsets.all(5),
                      color: Colors.white,
                      child: DropdownButton(
                        underline: Container(),
                        hint: GlobalCall.student == null
                            ? Text("Students")
                            : Text(
                          GlobalCall.student,
                          style: TextStyle(color: Colors.black),
                        ),
                        isExpanded: true,
                        elevation: 5,
                        icon: Icon(Icons.keyboard_arrow_down),
                        iconSize: 30.0,
                        style: TextStyle(color: Colors.black),
                        items: students.map(
                              (val) {
                            return DropdownMenuItem<StudentsDetailsModel>(
                              value: val,
                              child: Text(
                                val.firstName + " " + val.lastName,
                              ),
                            );
                          },
                        ).toList(),
                        onChanged: (val) {
                          setState(
                                () {
                              dropDownValue =
                                  val.firstName + " " + val.lastName;
                              GlobalCall.student = dropDownValue;
                              studentID = val.id.toString();
                              print(studentID);
                            },
                          );
                          widget.mainScreenBloc.add(UpdateSortFilterEvent());
                          widget.mainScreenBloc.add(UpdateFilterProgressEvent());
                        },
                      ),
                    ) : Container(),
                    Divider(height: 0, thickness: 0.5,),
                    Text('This Week',
                      style: TextStyle(color:Colors.grey, fontSize:16),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                        child: RefreshIndicator(
                          key: refreshKey,
                          child: state.filterProgress.length == 0 ? Center(
                            child: Text(
                              'No progress data, please try to change start/end Date',
                            ),
                          ) : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(height: 0, thickness: 0.5, color: Colors.transparent,);
                            },
                            itemCount: state.filterProgress.length,
                            itemBuilder: (context, index){
                              ProgressAmountModel model = state.filterProgress[index];

                              double required = double.parse(model.required);
                              double completed = double.parse(model.regCompleted);
                              double percent = required != 0 ? completed / required: 1;

                              double nonRequired = double.parse(model.reqNonDir);
                              double nonActual = double.parse(model.actNonDir);
                              double percent1 = nonRequired != 0 ? nonActual / nonRequired: 1;
                              if (percent1 > 1) {
                                percent1 = 1;
                              }
                              if (percent > 1) {
                                percent = 1;
                              }

                              return Card(
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  alignment: Alignment.topLeft,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Text(
                                        model.student,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.sp,
                                        ),
                                      ),
                                      SizedBox(height: 8,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: new CircularPercentIndicator(
                                                    radius: 64,
                                                    lineWidth: 5.5,
                                                    percent: percent,
                                                    circularStrokeCap: CircularStrokeCap.round,
                                                    center: new Text(
                                                      hmMaker(model.regCompleted),
                                                      style: TextStyle(
                                                        fontSize: 24.sp,
                                                      ),
                                                    ),
                                                    progressColor: percent >= 0.5
                                                        ? Colors.blue
                                                        : percent >= 0.3 ? Colors.orange : Colors.red,
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                                Flexible(
                                                  child: Text(
                                                    '${discrepString(double.parse(model.required) * 60 - double.parse(model.regCompleted) * 60)} of ${hmMaker(model.required)} remaining',
                                                    style: TextStyle(
                                                      fontSize: 24.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 16,),
                                          Flexible(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Container(
                                                  child: new CircularPercentIndicator(
                                                    radius: 64,
                                                    lineWidth: 5.5,
                                                    percent: percent1,
                                                    circularStrokeCap: CircularStrokeCap.round,
                                                    center: new Text(
                                                      discrepString(model.actNonDur),
                                                      style: TextStyle(
                                                        fontSize: 24.sp,
                                                      ),
                                                    ),
                                                    progressColor: percent1 >= 0.5
                                                        ? Colors.blue
                                                        : percent1 >= 0.3 ? Colors.orange : Colors.red,
                                                  ),
                                                ),
                                                SizedBox(width: 8,),
                                                Flexible(
                                                  child: Text(
                                                    '${discrepString(model.discrep)} of ${discrepString(model.reqNonDir1 * 60)} remaining',
                                                    style: TextStyle(
                                                      fontSize: 24.sp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          onRefresh: refreshList,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }
      ),
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    widget.mainScreenBloc.add(RefreshProgressEvent(startDate: startDate, endDate: endDate));
    await Future.delayed(Duration(seconds: 4));
    return null;
  }

  @override
  void initState() {

    setState(() {
      startDate = DateFormat('MM/dd/yyyy').format(GlobalCall.proStartDate).toString();
      GlobalCall.proEndDate = GlobalCall.proStartDate.add(new Duration(days: 7));
      endDate =  DateFormat('MM/dd/yyyy').format(GlobalCall.proEndDate).toString();
    });
    super.initState();
  }

  String hmMaker(String value) {
    double direct = double.parse(value) * 60;

    return discrepString(direct);
  }

  String discrepString(num value) {
    int doubleV = value.toInt();
    if (doubleV < 0) {
      return sprintf('%i:%02i', [0, 0]);
    } else {
      int h = doubleV ~/ 60;
      int m = doubleV % 60;
      return sprintf('%i:%02i', [h, m]);
    }
  }

}