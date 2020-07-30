import 'package:aosny_services/bloc/session_note/session_note.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:aosny_services/api/env.dart';


List<String> sessionTypeStrings = [
  'Service Provided',
  'Service provided - Make-up',
  'Student Absent',
  'Provider Absent',
  'Student Unavailable',
  'Non-Direct Care',
  'Cancelled'
];

List<Color> sessionColors = [
  Colors.red,
  Colors.purple,
  Colors.green,
  Colors.blue,
];

Color getSessionColor(int group, int sessionType) {
  if (group == 1 && (sessionType == 0 || sessionType == 1)) {
    return Colors.green;
  } else if (group == 2 && (sessionType == 0 || sessionType == 1)) {
    return Colors.blue;
  } else if (sessionType == 2 || sessionType == 3 || sessionType == 4) {
    return Colors.red;
  } else if (sessionType == 5) {
    return Colors.purple;
  } else if (sessionType == 6) {
    return Colors.red;
  }
  return Colors.white;
}

class AddEditSessionNote extends StatefulWidget {
  final StudentsDetailsModel student;
  final String selectedStudentName;
  final String eventType ;
  final String noteText;
  final CompleteSessionNotes sessionNotes;
  final String sessionId;

  AddEditSessionNote({
    this.student,
    this.selectedStudentName,
    this.eventType,
    this.noteText,
    this.sessionId,
    this.sessionNotes
  });
  @override
  _AddEditSessionNotetate createState() => _AddEditSessionNotetate();
}

class _AddEditSessionNotetate extends State<AddEditSessionNote> {

  SessionNoteScreenBloc screenBloc;
  String noteText='',sessionDateTime='',sessionTime='',duration='',sessionEndTime='',
      locationHomeOrSchool='',sessionType='',sessionIDValue='',confirmedVal='';

  int settingsGroupOrNot = 0;
  final myNotesController = TextEditingController();

  AddSessionResponse responseAddSession;
  bool settingPersonSelectedbutton = true;
  bool settingGroupSelectedButton = false;
  bool locHomeSelectedButton= true;
  bool locBuildingSelectedButton = false;
  String _dropDownValue;
  bool checkedValue = false;
  int groupType = 1;
  TextEditingController startTimeController = new TextEditingController(text: '9:00 AM');
  TextEditingController showTimeController = new TextEditingController(text: '30');
  DateTime selectedDate;
  DateTime toPassDate,endDateTime;
  String showDate;
  bool isSelectecDate = false;

  bool colorGPMadeProgress = true;
  bool colorGPpartialProgress = false;
  bool colorGPNoProgress = false;


  bool goalsAndProgress = false;
  bool isActivities = false;
  bool socialPragmaics = false;
  bool seitIntervention = false;
  bool competedActivites = false;
  bool jointAttentionEyeContact = false;

  int selectedSPIndex = -1;
  int selectedSIIndex = -1;
  int selectedOutComesIndex = -1;
  int selectedCAIconIndex = -1;
  int selectedJAIconIndex = -1;
  int selectedSessionTypeIndex = 0;

  bool colorJAPMadeProgress = true;
  bool colorJApartialProgress = false;
  bool colorJANoProgress = false;

  TimeOfDay selectedTime ;
  int finalNumber= 30;

  List<String> listValue =[
    'Select Long Term Goal',
    'Given the aid of verbal and visual cues',
    'Given the aid of modeling verbal and visual cues',
    'Given the aid of modeling verbal and visual cues',
  ];

  List<IconData> iconsList = [
    Icons.check_circle,
    Icons.star_half,
    Icons.not_interested,
  ];

  @override
  void initState() {
    screenBloc = SessionNoteScreenBloc(SessionNoteScreenState(isLoading: true));
    screenBloc.add(
        SessionNoteScreenInitEvent(
          studentId: widget.student.studentID.toInt(),
          eventType: widget.eventType,
          noteText: widget.noteText,
          selectedStudentName: widget.selectedStudentName,
          sessionId: widget.sessionId,
          sessionNotes: widget.sessionNotes,
          student: widget.student,
        )
    );
    showDate = DateFormat('EEEE, MMMM d').format(DateTime.now()).toString();
    selectedTime = new TimeOfDay.now();
    selectedDate = DateTime.now();

    super.initState();
  }

  static var  currentTime = DateTime(  DateTime.now().year, DateTime.now().month, DateTime.now().day,  TimeOfDay.now().hour, TimeOfDay.now().minute);

  var pickedTime = DateFormat.jm().format(currentTime);
  var pickedTimedt = currentTime;

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay response = await showTimePicker(
      context: context,
      initialTime: pickedTimedt ?? TimeOfDay.now(),
    );
    if (response != null && response != TimeOfDay.fromDateTime(pickedTimedt)) {
      final dt = DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, response.hour, response.minute);
      final format = DateFormat.jm();
      setState(() {
        pickedTime = format.format(dt);
        pickedTimedt=dt;
        print('pickedTime :$pickedTime');
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    screenBloc.close();
    myNotesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      cubit: screenBloc,
      listener: (BuildContext context, SessionNoteScreenState state) async {
      },
      child: BlocBuilder<SessionNoteScreenBloc, SessionNoteScreenState>(
          cubit: screenBloc,
          builder: (BuildContext context, SessionNoteScreenState state) {
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                automaticallyImplyLeading: true,
                backgroundColor: Colors.lightBlue[200],
                title: Text(
                  'Add Session Note',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              body: ModalProgressHUD(
                inAsyncCall: state.isLoading,
                child: new GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: SafeArea(
                    child: Container(
                      padding: const EdgeInsets.only(left:5,right:5, top:25),
                      child: _getBody(state),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }

  Widget _getBody(SessionNoteScreenState state) {
    if (state.sessionNotes != null) {
      noteText =  state.sessionNotes.notes;
      myNotesController.text = noteText;

      locationHomeOrSchool = state.sessionNotes.location;
      sessionType =  state.sessionNotes.sessionType;
      int index = sessionTypeStrings.indexOf(sessionType);
      if (index != null) {
        selectedSessionTypeIndex = index;
      }
      if(locationHomeOrSchool != null && locationHomeOrSchool.contains('School')){
        locHomeSelectedButton = false;
        locBuildingSelectedButton = true;
      } else {
        locHomeSelectedButton = false;
        locBuildingSelectedButton = true;
      }
      settingsGroupOrNot = state.sessionNotes.group;

      groupType = settingsGroupOrNot ?? 1;

      duration =  state.sessionNotes.duration.toString();
      finalNumber = state.sessionNotes.duration;
      sessionDateTime = '${state.sessionNotes.sessionDate} ${state.sessionNotes.sessionTime}';
      toPassDate = new DateFormat('MM/dd/yy hh:mm:ss').parse(sessionDateTime);
      sessionTime = DateFormat.jm().format(toPassDate);
      selectedDate = toPassDate;
      pickedTimedt = selectedDate;
      pickedTime = DateFormat.jm().format(pickedTimedt);

      endDateTime =  toPassDate.add(Duration(days: 0, hours: 0, minutes: int.parse(duration)));

      sessionEndTime = DateFormat.jm().format(endDateTime);
      LongTermGpDropDownModel model = state.longTermGpDropDownList.firstWhere((element) => element.longGoalID == state.selectedLtGoalId);
      if (model != null) {
        _dropDownValue = model.longGoalText;
      }
      List<SessionNoteExtrasList> sessionNotesExtras = state.sessionNotes.sessionNoteExtrasList;

      if (GlobalCall.socialPragmatics.categoryData.length > 0) {
        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          CategoryTextAndID temp;
          for (CategoryTextAndID data in GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID){
            if (sessionNotesExtras.length > 0) {
              sessionNotesExtras.forEach((element) {
                if (element.sNECategoryID == GlobalCall.socialPragmatics.categoryData[0].mainCategoryID) {
                  if (element.sNECategoryDetailID == data.categoryTextID) {
                    temp = data;
                  }
                }
              });
            }
          }
          if (temp != null) {
            selectedSPIndex = state.sPcheckListItems.indexOf(temp) ?? -1;
          }
        }

        if (GlobalCall.SEITIntervention.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID){
            CategoryTextAndID temp;
            if (sessionNotesExtras.length > 0) {
              sessionNotesExtras.forEach((element) {
                if (element.sNECategoryID == GlobalCall.SEITIntervention.categoryData[0].mainCategoryID) {
                  if (element.sNECategoryDetailID == data.categoryTextID) {
                    temp = data;
                  }
                }
              });
            }
            if (temp != null) {
              selectedSIIndex = state.sIcheckListItems.indexOf(temp) ?? -1;
            }
          }
        }

        if (GlobalCall.completedActivity.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.completedActivity.categoryData[0].categoryTextAndID){
            CategoryTextAndID temp;
            if (sessionNotesExtras.length > 0) {
              sessionNotesExtras.forEach((element) {
                if (element.sNECategoryID == GlobalCall.completedActivity.categoryData[0].mainCategoryID) {
                  if (element.sNECategoryDetailID == data.categoryTextID) {
                    temp = data;
                  }
                }
              });
            }
            if (temp != null) {
              selectedCAIconIndex = state.cAcheckListItems.indexOf(temp) ?? -1;
            }
          }
        }

        if (GlobalCall.jointAttention.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.jointAttention.categoryData[0].categoryTextAndID){
            CategoryTextAndID temp;
            if (sessionNotesExtras.length > 0) {
              sessionNotesExtras.forEach((element) {
                if (element.sNECategoryID == GlobalCall.jointAttention.categoryData[0].mainCategoryID) {
                  if (element.sNECategoryDetailID == data.categoryTextID) {
                    temp = data;
                  }
                }
              });
            }
            if (temp != null) {
              selectedJAIconIndex = state.jAcheckListItems.indexOf(temp) ?? -1;
            }
          }
        }

        if (GlobalCall.outcomes.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.outcomes.categoryData[0].categoryTextAndID){
            CategoryTextAndID temp;
            if (sessionNotesExtras.length > 0) {
              sessionNotesExtras.forEach((element) {
                if (element.sNECategoryID == GlobalCall.outcomes.categoryData[0].mainCategoryID) {
                  if (element.sNECategoryDetailID == data.categoryTextID) {
                    temp = data;
                  }
                }
              });
            }
            if (temp != null) {
              selectedOutComesIndex = state.outComesListItems.indexOf(temp) ?? -1;
            }
          }
        }
      }
    }
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left:5,right:5,),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //${widget.eventType}
                          Text('Session Note',
                            style: TextStyle(color:Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height:2),
                          Text(
                            widget.selectedStudentName,
                            style: TextStyle(
                              color:Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            DateFormat('EEEE').format(selectedDate).toString(),
                            style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),
                            //DateFormat('EEEE').format(toPassDate).toString(),
                            //style: TextStyle(color:Colors.grey,fontWeight: FontWeight.bold),

                          ),
                          SizedBox(height:2),

                          InkWell(
                            child: Container(
                                alignment: Alignment.center,
                                height: 64,
                                width: MediaQuery.of(context).size.width/7,
                                decoration: BoxDecoration(
                                    border: Border.all(color:Colors.blue)
                                ),
                                child:Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text( DateFormat('d').format(selectedDate).toString(),
                                      style: TextStyle(
                                          color:Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    //sessionDateTime== '' ? Text(''):
                                    Text( DateFormat('MMM').format(selectedDate).toString().toUpperCase(),
                                      style: TextStyle(
                                          color:Colors.blue,
                                          fontWeight: FontWeight.normal
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            onTap: () async {
                              final datePick= await showDatePicker(
                                context: context,
                                initialDate: selectedDate ?? DateTime.now(),
                                firstDate: DateTime(2018),
                                lastDate: DateTime(2030),
                              );
                              if(datePick!=null && datePick!=selectedDate){
                                setState(() {
                                  selectedDate=datePick;
                                  isSelectecDate= true;
                                });
                              }
                            },
                          )

                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(left:11,right:11),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Text('Start Time',
                                style: TextStyle(
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                child: Container(
                                  height: 44,
                                  alignment: Alignment.center,
                                  width: MediaQuery.of(context).size.width/4,
                                  decoration: BoxDecoration(
                                    border: Border.all(color:Colors.grey),
                                  ),
                                  child:  Text(
                                    pickedTime.toString(),
                                    style: TextStyle(
                                      color:Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                onTap: (){
                                  setState(() {
                                    _selectTime(context);
                                  });
                                },
                              )

                            ],
                          ),
                          // SizedBox(width:40),
                          Column(
                            children: <Widget>[
                              Text('',
                                  style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                              Row(
                                children: <Widget>[
                                  InkWell(
                                    child: Container(
                                      height: 44,
                                      width: MediaQuery.of(context).size.width/8.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: Colors.blue
                                      ),
                                      child: Icon(Icons.remove,color: Colors.white,),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        finalNumber = finalNumber - 1;
                                      });
                                    },
                                  ),
                                  Container(
                                    height: 44,
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width/8.5,
                                    decoration: BoxDecoration(
                                      border: Border.all(color:Colors.grey,width: 0.5),
                                    ),
                                    child:  Text(
                                      finalNumber.toString(),
                                      style: TextStyle(
                                        color:Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    child: Container(
                                      height: 44,
                                      width: MediaQuery.of(context).size.width/8.5,
                                      decoration: BoxDecoration(
                                          border: Border.all(color:Colors.grey,width: 0.5),
                                          color: Colors.blue
                                      ),
                                      child: Icon(Icons.add,color: Colors.white,),
                                    ),
                                    onTap: (){
                                      setState(() {
                                        finalNumber = finalNumber +1;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              // )

                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text('End Time',
                                style: TextStyle(
                                  color:Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 44,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width/4,
                                decoration: BoxDecoration(
                                    border: Border.all(color:Colors.grey)
                                ),
                                child: Text(
                                  DateFormat.jm().format(pickedTimedt.add(new Duration(minutes: finalNumber))).toString(),//'10:21 PM',
                                  style: TextStyle(
                                    color:Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ),
                            ],
                          ),
                        ],
                      ) ,

                      SizedBox(height: 30,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/2.5,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Location',
                                  style: TextStyle(fontWeight:FontWeight.bold,fontSize:15),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                      children: <Widget>[
                                        InkWell(
                                          child: Container(
                                            height: 44,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width/6.5,
                                            decoration: BoxDecoration(
                                                color: locHomeSelectedButton ?
                                                Color(0xff4A4A4A) :Colors.white,
                                                border: Border.all(color:Colors.grey,width: 0.5)
                                            ),
                                            child: Icon(Icons.home,
                                              color: locHomeSelectedButton
                                                  ? Colors.white:Color(0xff4A4A4A),
                                            ),
                                          ),
                                          onTap: (){
                                            setState(() {
                                              locHomeSelectedButton = true;
                                              locBuildingSelectedButton = false;
                                            });
                                          },

                                        ),

                                        Text('Home',style: TextStyle(fontSize: 11),),
                                      ],
                                    ),

                                    Container(width: 2,),

                                    Column(
                                      children: <Widget>[

                                        InkWell(
                                          child: Container(
                                            height: 44,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width/6.5,
                                            decoration: BoxDecoration(
                                                color: locBuildingSelectedButton
                                                    ? Color(0xff4A4A4A): Colors.white,
                                                border: Border.all(color:Colors.grey,width: 0.5)
                                            ),
                                            child: Icon(Icons.school,
                                              color: locBuildingSelectedButton
                                                  ? Colors.white: Color(0xff4A4A4A),
                                            ),
                                          ),
                                          onTap: (){
                                            setState(() {
                                              locHomeSelectedButton = false;
                                              locBuildingSelectedButton = true;
                                            });
                                          },

                                        ),

                                        Text('School',style: TextStyle(fontSize: 11),),

                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          Container(
                            width:  MediaQuery.of(context).size.width/2.5,
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Setting',
                                  style: TextStyle(fontWeight:FontWeight.bold, fontSize:15),
                                ),
                                Row(
                                  children: <Widget>[
                                    Column(
                                        children:<Widget>[
                                          InkWell(
                                            child: Container(
                                              height: 44,
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context).size.width/6.5,
                                              decoration: BoxDecoration(
                                                  color: groupType == 1
                                                      ? Color(0xff4A4A4A): Colors.white,
                                                  border: Border.all(color:Colors.grey,width: 0.5)
                                              ),
                                              child: Icon(Icons.person,
                                                color: groupType == 1
                                                    ? Colors.white: Color(0xff4A4A4A),
                                              ),
                                            ),
                                            onTap: (){
                                              setState(() {
                                                groupType = 1;
                                              });
                                            },

                                          ),
                                          Text('Individual',style: TextStyle(fontSize: 11),),

                                        ]
                                    ),

                                    Column(
                                      children:<Widget>[

                                        InkWell(
                                          child: Container(
                                            height: 44,
                                            alignment: Alignment.center,
                                            width: MediaQuery.of(context).size.width/6.5,
                                            decoration: BoxDecoration(
                                                color: groupType == 2
                                                    ?Color(0xff4A4A4A):Colors.white,
                                                border: Border.all(color:Colors.grey,width: 0.5)
                                            ),
                                            child: Icon(Icons.group,
                                              color: groupType == 2
                                                  ?Colors.white:Color(0xff4A4A4A),
                                            ),
                                          ),
                                          onTap: (){
                                            setState(() {
                                              groupType = 2;
                                            });

                                          },

                                        ),

                                        Text('Group',style: TextStyle(fontSize: 11),),

                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15,),
                      _sessionTypeWidget(state),
                    ],
                  ),
                )
              ],
            ),

          ),
          //Container(height: 10,),
          GestureDetector(
            onTap: (){
              setState(() {
                goalsAndProgress = !goalsAndProgress;
              });
            },
            child: Container(
              height: 44,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff4A4A4A),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      child: Text('Goals & Progress',
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                      ),
                      padding: const EdgeInsets.all(0)),

                  Container(
                    alignment: Alignment.centerRight,
                    child: goalsAndProgress ? Icon(Icons.arrow_drop_down,
                      color:Colors.white,
                      size: 35,
                    ) : Icon(Icons.arrow_right,
                      color:Colors.white,
                      size: 35,
                    ),
                  ),
                ],
              ),
            ),
          ),

          goalsAndProgress ? Container(
            margin: const EdgeInsets.all(5),
            padding:  const EdgeInsets.all(5.0),
            height: 50,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
            ),
            child: DropdownButton(
              underline: Container(),
              hint: _dropDownValue == null
                  ? Text(
                state.longTermGpDropDownList.length > 0  ? state.longTermGpDropDownList[0].longGoalText : '' ,
                maxLines: 1,
              )
                  : Text(
                _dropDownValue,
                maxLines: 1,
                style: TextStyle(color: Colors.black),
              ),
              isExpanded: true,
              // elevation: 10,
              iconSize: 30.0,
              style: TextStyle(color: Colors.black),
              items: state.longTermGpDropDownList.map(
                    (val) {
                  return DropdownMenuItem<LongTermGpDropDownModel>(
                    value: val,
                    child: Column(
                      children: <Widget>[
                        Text(val.longGoalText),
                        Container(height: 5,),
                        Divider(height: 10,color: Colors.black,),
                        Container(height: 5,),
                      ],
                    ),
                  );
                },
              ).toList(),
              onChanged: (val) {
                List<SelectedShortTermResultListModel> selectedShortTermResultListModel = [];
                int selectedLtGoalId = val.longGoalID;

                for(int i = 0; i< state.shortTermGpList.length; i++){
                  if(state.shortTermGpList[i].longGoalID == val.longGoalID){
                    selectedShortTermResultListModel.add(
                        SelectedShortTermResultListModel(
                          id: state.shortTermGpList[i].shortgoalid,
                          selectedId: state.shortTermGpList[i].longGoalID,
                          selectedShortgoaltext: state.shortTermGpList[i].shortgoaltext,
                          checkVal: false,
                        )
                    );
                  }
                }
                screenBloc.add(SelectLongTermID(id: selectedLtGoalId));
                screenBloc.add(UpdateSelectedShortTerms(selectedShortTermResultListModel: selectedShortTermResultListModel));
                setState(() {
                  _dropDownValue = val.longGoalText;
                });
              },
              //  selectedItemBuilder: (context){

              //   },
            ),
          ) : Container(),
          goalsAndProgress ? Container(
            margin: const EdgeInsets.only(left:5,right:5),
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemCount: state.selectedShortTermResultListModel.length,
              physics: const NeverScrollableScrollPhysics(),
              //scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return Container();//Divider(height: 0, color: Colors.transparent, thickness: 1,);
              },
              shrinkWrap: true,
              itemBuilder: (context, index){
                return Column(
                  children: <Widget>[
                    Container(
                        child: CheckboxListTile(
                          title: Text(
                            state.selectedShortTermResultListModel[index].selectedShortgoaltext,
                            style: TextStyle(fontSize: 15),
                          ),
                          value: state.selectedShortTermResultListModel[index].checkVal,
                          onChanged: (newValue) {
                            List<SelectedShortTermResultListModel> selected = state.selectedShortTermResultListModel;
                            selected[index].checkVal = newValue;
                            screenBloc.add(UpdateSelectedShortTerms(selectedShortTermResultListModel: selected));
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        )
                    ),
                    //Divider(color: Colors.black,)
                  ],
                );
              },
            ),
          ) : Container(),
          goalsAndProgress ? goalprogressReview(state) : Container(),
          goalsAndProgress ? Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                //border: Border.all(color:Colors.grey)
              ),
              child: CheckboxListTile(
                title: Text('Regression Noted?',
                  style: TextStyle(fontSize:18),
                ),
                value: checkedValue,
                onChanged: (newValue) {
                  setState(() {
                    checkedValue = newValue;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              )
          ):Container(),

          SizedBox(height:20),
          GestureDetector(
            onTap: (){
              setState(() {
                isActivities =  !isActivities;
              });

            },
            child:Container(
              alignment: Alignment.center,
              height: 44,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff4A4A4A),
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text('Activities',
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,

                      child: isActivities ? Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),
                    ),
                  ]
              ), ///Text('Activities',
            ),
          ),
          SizedBox(height:16),
          isActivities ? activitiesDropdownWidget(state) : Container(),
          GestureDetector(
            onTap: (){
              setState(() {
                socialPragmaics = !socialPragmaics;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 44,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff4A4A4A),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Text('Social Pragmatics',
                        style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    child:socialPragmaics?Icon(Icons.arrow_drop_down,
                      color:Colors.white,
                      size: 35,
                    ) :Icon(Icons.arrow_right,
                      color:Colors.white,
                      size: 35,
                    ),
                  ),
                ] ,
              ),
            ),
          ),

          socialPragmaics ? Container(
            margin: EdgeInsets.only(left:5,right:5, top: 12),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: ListTile(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: ListView.separated(
                        itemCount: state.sPcheckListItems.length,
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                        },
                        itemBuilder: (context, index){
                          return CheckboxListTile(
                            dense: true,
                            title: Text(
                              state.sPcheckListItems[index].categoryTextDetail,
                              style: TextStyle(fontSize: 14),
                            ),
                            value: selectedSPIndex == index,
                            onChanged: (newValue) {
                              setState(() {
                                selectedSPIndex = index;
                              });
                              Navigator.pop(context);
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          );
                        },
                      ),
                    );
                  },
                );
              },
              dense: true,
              title: Text(
                selectedSPIndex > -1 ? state.sPcheckListItems[selectedSPIndex].categoryTextDetail: 'Select Your Choice',
              ),
              trailing: Icon(Icons.keyboard_arrow_down),
            ),
          ) : Container(),

          SizedBox(height:20),
          GestureDetector(
            onTap: (){
              setState(() {
                seitIntervention =  !seitIntervention;
              });
            },
            child: Container(
              alignment: Alignment.center,
              height: 44,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff4A4A4A),
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      child: Text('SEIT Intervention',
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child:seitIntervention?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                  ]
              ),
            ),
          ),
          seitIntervention ? Container(
            margin: EdgeInsets.only(left:5,right:5, top: 12),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
            child: ListTile(
              onTap: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return SafeArea(
                      child: ListView.separated(
                        itemCount: state.sIcheckListItems.length,
                        separatorBuilder: (context, index) {
                          return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                        },
                        itemBuilder: (context, index){
                          return CheckboxListTile(
                            dense: true,
                            title: Text(
                              state.sIcheckListItems[index].categoryTextDetail,
                              style: TextStyle(fontSize: 14),
                            ),
                            value: selectedSIIndex == index,
                            onChanged: (newValue) {
                              setState(() {
//                                            sIcheckListItems[index].checkVal = newValue;
                                selectedSIIndex = index;
                              });
                              Navigator.pop(context);
                            },
                            controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                          );
                        },
                      ),
                    );
                  },
                );
              },
              dense: true,
              title: Text(
                selectedSIIndex > -1 ? state.sIcheckListItems[selectedSIIndex].categoryTextDetail: 'Select Your Choice',
              ),
              trailing: Icon(Icons.keyboard_arrow_down),
            ),
          ) : Container(),

          SizedBox(height:20),

          GestureDetector(
            onTap: (){
              setState(() {
                competedActivites =  !competedActivites;
              });

            },
            child: Container(
              alignment: Alignment.center,
              height: 44,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff4A4A4A),
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    Container(

                      alignment: Alignment.center,
                      child: Text('Completed activity',
                        style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal),

                      ),
                    ),


                    Container(
                      alignment: Alignment.centerRight,

                      child:competedActivites?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                  ]
              ), ///Text('Activities',


            ),),
          competedActivites ? completedActivityReview(state) : Container(),
          SizedBox(height:20),
          GestureDetector(
            onTap: (){
              setState(() {
                jointAttentionEyeContact =  !jointAttentionEyeContact;
              });

            },
            child: Container(
              alignment: Alignment.center,
              height: 44,
              width: MediaQuery.of(context).size.width,
              color: Color(0xff4A4A4A),
              child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[

                    Container(

                      alignment: Alignment.center,
                      child: Text('Joint Attention / Eye Contact',
                          style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)

                      ),),


                    Container(
                      alignment: Alignment.centerRight,

                      child:jointAttentionEyeContact?Icon(Icons.arrow_drop_down,
                        color:Colors.white,
                        size: 35,
                      ) :Icon(Icons.arrow_right,
                        color:Colors.white,
                        size: 35,
                      ),),
                  ]
              ), ///Text('Activities',


            ),),
          jointAttentionEyeContact? jointAttentionOrEyeContactReview(state): Container(),

          Padding(padding: EdgeInsets.only(top: 16),),
          Container(
            alignment: Alignment.bottomLeft,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left:20,right:20,top:5),
            child: Text(
              'Notes: (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),

          Container(
            alignment: Alignment.topLeft,
            margin: const EdgeInsets.only(left:20,right:20,top:2),
            decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.grey,width: 1)
            ) ,
            child: TextField(
              maxLines: 5,
              controller: myNotesController,
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  // enabled: false,
                  hintText: '',
                  // noteText,
                  //widget.noteText == '' ? 'Placeholder':widget.noteText,
                  hintStyle: TextStyle(fontSize: 16,color: Colors.black),
                  border: InputBorder.none
              ),
              onChanged: (val){
                setState(() {

                });
              },
            ),
          ),
          SizedBox(height:30),
          Container(
            width:  MediaQuery.of(context).size.width/2,
            height: 44,
            decoration: BoxDecoration(
            ),
            child: InkWell(
              onTap: (){
                addSaveNotesApiCall(state);
              },
              child: Container(
                  color: Colors.blue,
                  alignment: Alignment.center,
                  child: Text('Save',style: TextStyle(color:Colors.white),)
              ),
            ),
          ),
          // SizedBox(height:10),
        ],
      ),
    );
  }

  Widget activitiesDropdownWidget(SessionNoteScreenState state) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int key = state.activitiesListItems.keys.toList()[index];
          List<CheckList> list = state.activitiesListItems[key];
          return Container(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index1) {
                CheckList item = list[index1];
                return InkWell(
                  onTap: () {
                      item.checkVal = !item.checkVal;
                      list[index1] = item;

                      Map activitiesListItems = state.activitiesListItems;
                      activitiesListItems[key] = list;

                      screenBloc.add(UpdateActivityListItem(activitiesListItems: activitiesListItems));

                  },
                  splashColor: Color(0xFFEFEFEF),
                  highlightColor: Color(0xFFEFEFEF),
                  hoverColor: Color(0xFFEFEFEF),
                  focusColor: Color(0xFFEFEFEF),
                  child: Container(
                    padding: index1 == 0
                        ? EdgeInsets.only(left: 16, right: 16)
                        : EdgeInsets.only(left: 24, right: 16),
                    height: index1 == 0 ? 44 : 36,
                    color: index1 == 0
                        ? Color(0xFFc6e2ff)
                        : Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        index1 == 0
                            ? (item.checkVal ? Icon(Icons.remove) : Icon(Icons.add))
                            : (item.checkVal ? Icon(Icons.check_box, color: Colors.blue,) : Icon(Icons.check_box_outline_blank, )),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                        ),
                        Text(
                          item.title,
                          style: TextStyle(
                            color: index1 == 0 ? Colors.black: Colors.black87,
                            fontSize: index1 == 0 ? 16: 14,
                            fontWeight: index1 == 0 ? FontWeight.w400: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index1) {
                return Divider(height: 0, thickness: 1,);
              },
              itemCount: list[0].checkVal ? list.length: 1,
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(height: 0, thickness: 1,);
        },
        itemCount: state.activitiesListItems.keys.length,
      ),
    );
  }

  Widget goalprogressReview(SessionNoteScreenState state){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
          child: Text(
              'Outcomes: '
          ),
        ),
        Container(
          margin: EdgeInsets.only(left:5,right:5, top: 12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    maintainBottomViewPadding: true,
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 16),
                      itemCount: state.outComesListItems.length,
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                      },
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            state.outComesListItems[index].categoryTextDetail,
                            style: TextStyle(fontSize: 14),
                          ),
                          value: selectedOutComesIndex == index,
                          onChanged: (newValue) {
                            setState(() {
                              selectedOutComesIndex = index;
                            });
                            Navigator.pop(context);
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        );
                      },
                    ),
                  );
                },
              );
            },
            dense: true,
            title: Text(
              selectedOutComesIndex > -1 ? state.outComesListItems[selectedOutComesIndex].categoryTextDetail: 'Select Your Choice',
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
      ],
    );
  }

  Widget _sessionTypeWidget(SessionNoteScreenState state){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 16, top: 8,),
          child: Text(
            'Session Type: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left:5,right:5, top: 12),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: getSessionColor(groupType, selectedSessionTypeIndex),
            border: Border.all(
              color: Colors.black,
              width: 1,
            ),
          ),
          child: ListTile(
            onTap: () {
              print(sessionTypeStrings.length);
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SafeArea(
                    maintainBottomViewPadding: true,
                    child: ListView.separated(
                      padding: EdgeInsets.only(top: 16),
                      itemCount: sessionTypeStrings.length,
                      separatorBuilder: (context, index) {
                        return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                      },
                      itemBuilder: (context, index){
                        return CheckboxListTile(
                          dense: true,
                          title: Text(
                            sessionTypeStrings[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          value: selectedSessionTypeIndex == index,
                          onChanged: (newValue) {
                            setState(() {
                              selectedSessionTypeIndex = index;
                            });
                            Navigator.pop(context);
                          },
                          controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                        );
                      },
                    ),
                  );
                },
              );
            },
            dense: true,
            title: Text(
              selectedSessionTypeIndex > -1 ? sessionTypeStrings[selectedSessionTypeIndex]: sessionTypeStrings[0],
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Icon(Icons.keyboard_arrow_down),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(bottom: 16),
        ),
      ],
    );
  }

  Widget completedActivityReview(SessionNoteScreenState state){
    return Container(
      margin: EdgeInsets.only(left:10 ,right: 10, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: state.cAcheckListItems.map((e) {
          int index = state.cAcheckListItems.indexOf(e);
          return InkWell(
            child: Container(
              height: 110,
              width: 90,
              decoration: BoxDecoration(
                  border: Border.all(color:Colors.grey,width: 0.5)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconsList[index],
                    color: selectedCAIconIndex == index ? Colors.green:Colors.grey,
                    size: 40,
                  ) ,
                  Text('Made',
                    style: TextStyle(
                        color: selectedCAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
                    ),
                  ),
                  Text('Progress',
                    style: TextStyle(
                        color: selectedCAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
                    ),
                  ),
                ],
              ) ,
            ),
            onTap: (){
              setState(() {
                selectedCAIconIndex = index;
              });
            },
          );
        },
        ).toList(),
      ),
    );
  }


  Widget jointAttentionOrEyeContactReview(SessionNoteScreenState state){
    return Container(
      margin: EdgeInsets.only(left:10 ,right: 10, top :16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: state.jAcheckListItems.map((e) {
          int index = state.jAcheckListItems.indexOf(e);
          return InkWell(
            child: Container(
              height: 110,
              width: 90,
              decoration: BoxDecoration(
                  border: Border.all(color:Colors.grey,width: 0.5)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    iconsList[index],
                    color: selectedJAIconIndex == index ? Colors.green:Colors.grey,
                    size: 40,
                  ) ,
                  Text('Made',
                    style: TextStyle(
                        color: selectedJAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
                    ),
                  ),
                  Text('Progress',
                    style: TextStyle(
                        color: selectedJAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
                    ),
                  ),
                ],
              ) ,
            ),
            onTap: (){
              setState(() {
                selectedJAIconIndex = index;
              });
            },
          );
        },
        ).toList(),
      ),
    );
  }

  Widget editWidget(){
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            border: Border.all(color:Colors.grey),
            color: Colors.amber
        ),
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.not_interested,
              color:Colors.grey,
              size: 40,
            ) ,
            Text('No'),
            Text('Progress')
          ],
        )
    );
  }


  Widget firstRowEditWidget(SessionNoteScreenState state){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Painting'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Baking'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Vehicles'),

              ],
            )
        ),
      ],
    );
  }




  Widget secondRowEditWidget(SessionNoteScreenState state){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Excercise'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Glue'),

              ],
            )
        ),
        Container(
            height: 64,
            width: MediaQuery.of(context).size.width/4,
            decoration: BoxDecoration(
                border: Border.all(color:Colors.grey),
                color: Colors.amber
            ),
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.not_interested,
                  color:Colors.grey,
                  size: 40,
                ) ,
                Text('Calender'),
              ],
            )
        ),
      ],
    );
  }

  void addSaveNotesApiCall(SessionNoteScreenState state) async {
    var selectedDate1 = new DateFormat('MM/dd/yy hh:mm:ss');

    String dateFinal =  selectedDate1.format(selectedDate);

    sessionTime = DateFormat.jm().format(selectedDate);

    print('date ::'+dateFinal);
    //String dd = dateFinal.split(' ').toString();
    print('time ::'+pickedTime);

    print('duration'+finalNumber.toString());
    noteText = myNotesController.text.toString();
    sessionDateTime = dateFinal;
    sessionTime=pickedTime;
    duration=finalNumber.toString();

    if(locHomeSelectedButton == true){
      locationHomeOrSchool='Home|Class';
    }else{
      locationHomeOrSchool = 'School|Class';
    }
    print('locationHomeOrSchool :: '+locationHomeOrSchool);
    if(settingGroupSelectedButton == true){
      settingsGroupOrNot = 0;
    }else{
      settingsGroupOrNot = 1;
    }

    print('settingsGroupOrNot => $settingsGroupOrNot');

    if (selectedSessionTypeIndex > -1) {
      sessionType = sessionTypeStrings[selectedSessionTypeIndex];
    } else {
      sessionType = sessionTypeStrings[0];
    }
    print('sessionType :: '+sessionType);
    confirmedVal='1';

    String url =  widget.sessionId != null ? baseURL + 'SessionNote/${widget.sessionId}/CompleteSessionNote': baseURL + 'SessionNote/0/CompleteSessionNote';

    List<Goals> goals = List();
    List<ShortGoalIDs> shortTerms = List();
    for (SelectedShortTermResultListModel model in state.selectedShortTermResultListModel) {
      if (model.checkVal) {
        shortTerms.add(ShortGoalIDs(shortGoalID: model.id));
      }
    }
    var goal = Goals(longGoalID: state.selectedLtGoalId, shortGoalIDs: shortTerms);
    goals.add(goal);
    List<SessionNoteExtrasList> sessionNoteExtrasList = [];

    if (selectedSPIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.socialPragmatics.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.sPcheckListItems[selectedSPIndex].categoryTextID,
              sNESubDetailID: 0));
    }
    if (selectedSIIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.SEITIntervention.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.sIcheckListItems[selectedSIIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    if (selectedOutComesIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.outcomes.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.outComesListItems[selectedOutComesIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    if (selectedCAIconIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.completedActivity.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.cAcheckListItems[selectedCAIconIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    if (selectedJAIconIndex > -1) {
      sessionNoteExtrasList.add(
          SessionNoteExtrasList(sNECategoryID: GlobalCall.jointAttention.categoryData[0].mainCategoryID,
              sNECategoryDetailID: state.jAcheckListItems[selectedJAIconIndex].categoryTextID,
              sNESubDetailID: 0));
    }

    List<Activities> activities = List();
    state.activitiesListItems.forEach((key, alist) {
      for(int j = 1; j < alist.length; j++) {
        if (alist[j].checkVal) {
          activities.add(Activities(activityDetailID: alist[j].id, categoryDetailID: alist[0].id));
        }
      }
    });
    CompleteSessionNotes newPost = new CompleteSessionNotes(
      sessionDate: sessionDateTime,
      sessionTime:sessionTime,
      duration:finalNumber,
      group: settingsGroupOrNot,
      location: locationHomeOrSchool,
      sessionType: sessionType,
      notes: noteText,
      confirmed: 1,
      goals: goals,
      activities: activities,
      sessionID: 0,
      sessionNoteExtrasList: sessionNoteExtrasList,
    );

    screenBloc.add(SaveSessionNoteEvent(url: url, completeSessionNotes: newPost));
  }

}

class CheckList{
  String title;
  bool checkVal;
  int id;
  CheckList({this.title, this.checkVal, @required this.id});
}
