import 'package:aosny_services/api/add_session_api.dart';
import 'package:aosny_services/api/complete_session_details_api.dart';
import 'package:aosny_services/api/preload_api.dart';
import 'package:aosny_services/api/session_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:aosny_services/models/add_session_response.dart';
import 'package:aosny_services/models/complete_session.dart';
import 'package:aosny_services/models/gp_Listview_model.dart';
import 'package:aosny_services/models/gp_dropdown_model.dart';
import 'package:aosny_services/models/selected_longTerm_model.dart';
import 'package:aosny_services/models/category_list.dart';
import 'package:aosny_services/models/students_details_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:aosny_services/api/env.dart';

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

  SessionApi _sessionApi = SessionApi();
  String noteText="",sessionDateTime="",sessionTime="",duration="",sessionEndTime="",
      locationHomeOrSchool="",settingsGroupOrNot="",sessionType="",sessionIDValue="",confirmedVal="";

  final myNotesController = TextEditingController();

  AddSessionApi addSessionNoteApi = new AddSessionApi();
  CompleteSessionApi completeSessionApi = new CompleteSessionApi();
  CompleteSessionNotes sessionNotes;
  AddSessionResponse responseAddSession;
  bool settingPersonSelectedbutton = true;
  bool settingGroupSelectedButton = false;
  bool locHomeSelectedButton= true;
  bool locBuildingSelectedButton = false;
  String _dropDownValue;
  bool sPSelected = true;
  bool sPmSelected = false;
  bool sASelected = false;
  bool pASelected = false;
  bool sUSelected = false;
  bool checkedValue = false;
  TextEditingController startTimeController = new TextEditingController(text: "9:00 AM");
  TextEditingController showTimeController = new TextEditingController(text: "30");
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
  bool _isLoading = false;

  // jointAttentionOrEyeContactReview completedActivityReview

  int selectedCAIconIndex = 0;
  int selectedJAIconIndex = 0;

  bool colorJAPMadeProgress = true;
  bool colorJApartialProgress = false;
  bool colorJANoProgress = false;

  TimeOfDay selectedTime ;
  int finalNumber= 30;

  List<String> listValue =[
    "Select Long Term Goal",
    "Given the aid of verbal and visual cues",
    "Given the aid of modeling verbal and visual cues",
    "Given the aid of modeling verbal and visual cues",
  ];

  List<LongTermGpDropDownModel> longTermGpDropDownList = new List();
  List<ShortTermGpModel> shortTermGpList = new List();

  List<CheckList> gPcheckListItems =[];
  List<CheckList> sPcheckListItems = [];
  List<CheckList> sIcheckListItems = [];
  List<CheckList> jAcheckListItems = [];
  List<CheckList> cAcheckListItems = [];
  Map<int, List<CheckList>> activitiesListItems = {};

  int selectedLtGoalId = 0;

  List<IconData> iconsList = [
    Icons.check_circle,
    Icons.star_half,
    Icons.not_interested,
  ];

  List<SelectedShortTermResultListModel> selectedShortTermResultListModel = List<SelectedShortTermResultListModel>() ;

  @override
  void initState() {

    // Fetch DropdownList

    setState(() {
      showDate = DateFormat('EEEE, MMMM d').format(DateTime.now()).toString();
      selectedTime = new TimeOfDay.now();
      selectedDate = DateTime.now();
    });

    // GET LongTermGoals and ShortTermGoals
    getLongTermGpDropDownList();

    super.initState();
  }

  getLongTermGpDropDownList() async{
    setState(() {
      _isLoading = true;
    });
    longTermGpDropDownList = await _sessionApi.getLongTermGpDropDownList(widget.student.studentID.toInt());
    longTermGpDropDownList.map((LongTermGpDropDownModel model) {
    } );
    getShortTermGpList();
  }

  getShortTermGpList() async {
    shortTermGpList = await _sessionApi.getShortTermGpList(widget.student.studentID.toInt());
    gPcheckListItems = [];
    shortTermGpList.map((ShortTermGpModel model) {
      gPcheckListItems.add(
          CheckList(title: model.shortgoaltext, checkVal: false)
      );
    });
    if (widget.sessionId != null) {
      callCompleteSessionApi(int.parse(widget.sessionId));
    } else {
      if (GlobalCall.socialPragmatics.categoryData.length > 0) {
        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID){
            sPcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: false, id: data.categoryTextID));
          }

        }

        if (GlobalCall.SEITIntervention.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID){
            sIcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: false, id: data.categoryTextID));
          }
        }

        if (GlobalCall.completedActivity.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.completedActivity.categoryData[0].categoryTextAndID){
            cAcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: false, id: data.categoryTextID));
          }
        }

        if (GlobalCall.jointAttention.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.jointAttention.categoryData[0].categoryTextAndID){
            jAcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: false, id: data.categoryTextID));
          }
        }

        if (GlobalCall.activities.categoryData.length > 0) {
          for (CategoryTextAndID data in GlobalCall.activities.categoryData[0].categoryTextAndID){
            List<CheckList> list = [];
            list.add(
                CheckList(
                  title: data.categoryTextDetail,
                  checkVal: false,
                  id: data.categoryTextID,
                )
            );
            for (SubCategoryData subData in data.subCategoryData) {
              list.add(
                  CheckList(
                    title: subData.subCategoryTextDetail,
                    checkVal: false,
                    id: subData.subCategoryTextID,
                  )
              );
            }
            activitiesListItems[data.categoryTextID] = list;
          }
        }
      }


      setState(() {
        _isLoading = false;
        selectedLtGoalId = longTermGpDropDownList[0].longGoalID;
        for(int i = 0; i < shortTermGpList.length; i++){
          if(shortTermGpList[i].longGoalID == longTermGpDropDownList[0].longGoalID){
            setState(() {
              selectedShortTermResultListModel.add(SelectedShortTermResultListModel(
                  id: shortTermGpList[i].shortgoalid,
                  selectedId: shortTermGpList[i].longGoalID,
                  selectedShortgoaltext: shortTermGpList[i].shortgoaltext,
                  checkVal: false
              ));
            });
          }
        }
      });
    }
  }


  static var  currentTime = DateTime(  DateTime.now().year, DateTime.now().month, DateTime.now().day,  TimeOfDay.now().hour, TimeOfDay.now().minute);

  var pickedTime = DateFormat.jm().format(currentTime);
  var pickedTimedt = currentTime;
  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay response = await showTimePicker(
      context: context,
      initialTime:  TimeOfDay.now(),
    );
    if (response != null && response != pickedTime) {
      final dt = DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, response.hour, response.minute);
      final format = DateFormat.jm();
      setState(() {
        pickedTime = format.format(dt);
        pickedTimedt=dt;
        print("pickedTime :$pickedTime");
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myNotesController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.lightBlue[200],
        title: Text("Add Session Note",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(left:5,right:5, top:25),
              child: SingleChildScrollView(
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
                                    Text("Session Note",
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
                                              //sessionDateTime== "" ? Text(""):
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
                                          initialDate: DateTime.now(),
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
                                        Text("Start Time",
                                            style: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)),
                                        InkWell(
                                          child: Container(
                                            height: 44,
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context).size.width/4,
                                              decoration: BoxDecoration(
                                                  border: Border.all(color:Colors.grey)
                                              ),
                                              //pickedTime.toString()
                                              //sessionTime == "" ? Text(""):Text(sessionTime)
                                              child:  Text(pickedTime.toString())

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
                                        Text("",
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

                                                //duration == "" ? Text("") :  Text(duration)
                                                child:  Text(finalNumber.toString())

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
                                        Text("End Time",
                                            style: TextStyle(
                                              color:Colors.grey,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            )
                                        ),
                                        //sessionEndTime ==""?Text(""):
                                        Text(
                                            DateFormat.jm().format(pickedTimedt.add(new Duration(minutes:30))).toString(),//"10:21 PM",
                                            style: TextStyle(
                                                color:Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                            )
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
                                          Text("Location",
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

                                                  Text("Home",style: TextStyle(fontSize: 11),),
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
                                                              ?Color(0xff4A4A4A):Colors.white,
                                                          border: Border.all(color:Colors.grey,width: 0.5)
                                                      ),
                                                      child: Icon(Icons.school,
                                                        color: locBuildingSelectedButton
                                                            ?Colors.white:Color(0xff4A4A4A),
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      setState(() {
                                                        locBuildingSelectedButton = true;
                                                        locHomeSelectedButton= false;
                                                      });
                                                    },

                                                  ),

                                                  Text("School",style: TextStyle(fontSize: 11),),

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
                                          Text("Setting",
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
                                                            color: settingPersonSelectedbutton
                                                                ?Color(0xff4A4A4A):Colors.white,
                                                            border: Border.all(color:Colors.grey,width: 0.5)
                                                        ),
                                                        child: Icon(Icons.person,
                                                          color: settingPersonSelectedbutton
                                                              ?Colors.white:Color(0xff4A4A4A),
                                                        ),
                                                      ),
                                                      onTap: (){
                                                        setState(() {
                                                          settingPersonSelectedbutton = true;
                                                          settingGroupSelectedButton = false;
                                                        });
                                                      },

                                                    ),
                                                    Text("Individual",style: TextStyle(fontSize: 11),),

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
                                                          color: settingGroupSelectedButton
                                                              ?Color(0xff4A4A4A):Colors.white,
                                                          border: Border.all(color:Colors.grey,width: 0.5)
                                                      ),
                                                      child: Icon(Icons.group,
                                                        color: settingGroupSelectedButton
                                                            ?Colors.white:Color(0xff4A4A4A),
                                                      ),
                                                    ),
                                                    onTap: (){
                                                      setState(() {
                                                        settingGroupSelectedButton = true;
                                                        settingPersonSelectedbutton = false;
                                                      });

                                                    },

                                                  ),

                                                  Text("Group",style: TextStyle(fontSize: 11),),

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
                                Container(
                                  margin: const EdgeInsets.only(left:5,right:5),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: <Widget>[
                                      InkWell(
                                        child: Container(
                                          padding: const EdgeInsets.only(left:10),
                                          alignment: Alignment.centerLeft,
                                          height: 50,
                                          child: Text("Service Provided",
                                            style: TextStyle(
                                              color: sPSelected?Colors.white:Colors.black,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color:Colors.grey,width: 0.5),
                                            color: sPSelected?Colors.blue:Colors.white,
                                          ),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            sPSelected = true;
                                            sPmSelected = false;
                                            sASelected = false;
                                            pASelected = false;
                                            sUSelected = false;
                                          });

                                        },
                                      ),
                                      // Divider(color:Colors.grey),
                                      InkWell(
                                        child: Container(
                                          //  margin: const EdgeInsets.all(5),
                                            padding: const EdgeInsets.only(left:10),
                                            alignment: Alignment.centerLeft,
                                            height: 50,
                                            child: Text("Service Provided, Makeup",
                                              style: TextStyle(
                                                color: sPmSelected?Colors.white:Colors.black,
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(color:Colors.grey,width: 0.5),
                                              color: sPmSelected?Colors.blue:Colors.white,
                                            )
                                        ),
                                        onTap: (){
                                          setState(() {
                                            sPSelected = false;
                                            sPmSelected = true;
                                            sASelected = false;
                                            pASelected = false;
                                            sUSelected = false;
                                          });
                                        },
                                      ),
                                      // Divider(color:Colors.grey),
                                      InkWell(
                                        child: Container(
                                          //  margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.only(left:10),
                                          alignment: Alignment.centerLeft,
                                          height: 50,
                                          child: Text("Student Absent",
                                            style: TextStyle(
                                              color: sASelected?Colors.white:Colors.black,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color:Colors.grey,width: 0.5),
                                            color: sASelected?Colors.blue:Colors.white,
                                          ),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            sPSelected = false;
                                            sPmSelected = false;
                                            sASelected = true;
                                            pASelected = false;
                                            sUSelected = false;
                                          });
                                        },
                                      ),

                                      InkWell(
                                        child: Container(
                                          //  margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.only(left:10),
                                          alignment: Alignment.centerLeft,
                                          height: 50,
                                          child: Text("Provider Absent",
                                            style: TextStyle(
                                              color: pASelected?Colors.white:Colors.black,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color:Colors.grey,width: 0.5),
                                            color: pASelected?Colors.blue:Colors.white,
                                          ),
                                        ),
                                        onTap: (){
                                          setState(() {
                                            sPSelected = false;
                                            sPmSelected = false;
                                            sASelected = false;
                                            pASelected = true;
                                            sUSelected = false;
                                          });
                                        },
                                      ),

                                      InkWell(
                                        child: Container(
                                          //  margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.only(left:10),
                                          alignment: Alignment.centerLeft,
                                          height: 50,
                                          child: Text("Student unavailable",
                                            style: TextStyle(
                                              color: sUSelected?Colors.white:Colors.black,
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(color:Colors.grey,width: 0.5),
                                            color: sUSelected?Colors.blue:Colors.white,
                                          ),
                                        ),
                                        onTap: (){

                                          setState(() {
                                            sPSelected = false;
                                            sPmSelected = false;
                                            sASelected = false;
                                            pASelected = false;
                                            sUSelected = true;
                                          });

                                        },
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(top: 16),
                                      )
                                    ],
                                  ),
                                )
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
                                child: Text("Goals & Progress",
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
                          longTermGpDropDownList.length > 0  ? longTermGpDropDownList[0].longGoalText : '' ,
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
                        items: longTermGpDropDownList.map(
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
                          print("val val val  val val :${val.longGoalID}");
                          selectedShortTermResultListModel.clear();
                          selectedLtGoalId = val.longGoalID;

                          for(int i = 0; i< shortTermGpList.length; i++){
                            if(shortTermGpList[i].longGoalID == val.longGoalID){
                              setState(() {
                                selectedShortTermResultListModel.add(
                                    SelectedShortTermResultListModel(
                                      id: shortTermGpList[i].shortgoalid,
                                    selectedId: shortTermGpList[i].longGoalID,
                                    selectedShortgoaltext: shortTermGpList[i].shortgoaltext,
                                    checkVal: false
                                ));
                              });
                            }
                          }
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
                        itemCount: selectedShortTermResultListModel.length,
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
                                      selectedShortTermResultListModel[index].selectedShortgoaltext,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    value: selectedShortTermResultListModel[index].checkVal,
                                    onChanged: (newValue) {
                                      setState(() {
                                        selectedShortTermResultListModel[index].checkVal = newValue;
                                      });
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
                    goalsAndProgress ? goalprogressReview() : Container(),
                    goalsAndProgress ? Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          //border: Border.all(color:Colors.grey)
                        ),
                        child: CheckboxListTile(
                          title: Text("Regression Noted?",
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
                                child: Text("Activities",
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
                        ), ///Text("Activities",
                      ),
                    ),
                    SizedBox(height:16),
                    isActivities ? activitiesDropdownWidget() : Container(),
//                    isActivities ? firstRowEditWidget() : Container(),
//                    isActivities ? SizedBox(height:16): Container(),
//                    isActivities ? secondRowEditWidget() : Container(),
//                    isActivities ? SizedBox(height:16): Container(),
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
                              child: Text("Social Pragmatics",
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
                      margin: const EdgeInsets.only(left:5,right:5),
                      width: MediaQuery.of(context).size.width,
                      child: ListView.separated(
                          itemCount: sPcheckListItems.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                          },
                          itemBuilder: (context, index){
                            return CheckboxListTile(
                              title: Text(sPcheckListItems[index].title,
                                style: TextStyle(fontSize: 14),
                              ),
                              value: sPcheckListItems[index].checkVal,
                              onChanged: (newValue) {
                                setState(() {
                                  sPcheckListItems[index].checkVal = newValue;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            );
                          }
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
                                child: Text("SEIT Intervention",
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
                        ), ///Text("Activities",

                      ),),
                    seitIntervention ? Container(
                      margin: const EdgeInsets.only(left:5,right:5),
                      width: MediaQuery.of(context).size.width,

                      child: ListView.separated(
                          itemCount: sIcheckListItems.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return Divider(color: Colors.black38, height: 0, thickness: 0.5,);
                          },
                          itemBuilder: (context, index){
                            return CheckboxListTile(
                              title: Text(sIcheckListItems[index].title,
                                style: TextStyle(fontSize: 14),
                              ),
                              value: sIcheckListItems[index].checkVal,
                              onChanged: (newValue) {
                                setState(() {
                                  sIcheckListItems[index].checkVal = newValue;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                            );
                          }
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
                                child: Text("Completed activity",
                                    style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)

                                ),),


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
                        ), ///Text("Activities",


                      ),),
                    competedActivites ? completedActivityReview() : Container(),
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
                                child: Text("Joint Attention / Eye Contact",
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
                        ), ///Text("Activities",


                      ),),
                    /* Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height/25,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff4A4A4A),
                    child: Text("Joint Attention / Eye Contact",
                    style:TextStyle(color: Colors.white,fontWeight: FontWeight.normal)
                    ),
                 ),*/
                    jointAttentionEyeContact? jointAttentionOrEyeContactReview(): Container(),

                    Padding(padding: EdgeInsets.only(top: 16),),
                    Container(
                        alignment: Alignment.bottomLeft,
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.only(left:20,right:20,top:5),
                        child: Text(
                          "Notes: (Optional)",
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
                            hintText: "",
                            // noteText,
                            //widget.noteText == '' ? "Placeholder":widget.noteText,
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
                          addSaveNotesApiCall();
                        },
                        child: Container(
                            color: Colors.blue,
                            alignment: Alignment.center,
                            child: Text("Save",style: TextStyle(color:Colors.white),)
                        ),
                      ),
                    ),
                    // SizedBox(height:10),
                  ],
                ),
              ),
            ),
          )
      ),
    );
  }

  Widget activitiesDropdownWidget() {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          int key = activitiesListItems.keys.toList()[index];
          List<CheckList> list = activitiesListItems[key];
          return Container(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index1) {
                CheckList item = list[index1];
                return InkWell(
                    onTap: () {
                      setState(() {
                        item.checkVal = !item.checkVal;
                        list[index1] = item;
                        activitiesListItems[key] = list;
                      });
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
        itemCount: activitiesListItems.keys.length,
      ),
    );
  }

  Widget goalprogressReview(){
    return Container(
      margin: EdgeInsets.only(left:10 ,right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            child: Container(
              height: 110,
              width: 90,
              decoration: BoxDecoration(
                //border: Border.all(color:Colors.grey,width: 0.5)
              ),
              child:Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.check_circle,
                    color:colorGPMadeProgress?Colors.green:Colors.grey,
                    size: 40,
                  ) ,

                  Container(height: 5),


                  Text("Made",
                    style: TextStyle(
                        color:colorGPMadeProgress?Colors.green:Colors.grey,fontSize: 15
                    ),
                  ),
                  Text("Progress",
                    style: TextStyle(
                        color:colorGPMadeProgress?Colors.green:Colors.grey,fontSize: 15
                    ),
                  ),
                ],
              ) ,
            ),
            onTap: (){
              setState(() {
                colorGPMadeProgress = true;
                colorGPpartialProgress = false;
                colorGPNoProgress = false;
              });
            },
          ),
          InkWell(
            child: Container(
                height: 110,
                width: 90,
                decoration: BoxDecoration(
                  //border: Border.all(color:Colors.grey,width: 0.5)
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.star_half,
                      color:colorGPpartialProgress?Colors.yellow[700]:Colors.grey,
                      size: 40,
                    ) ,

                    Container(height: 5),

                    Text("Partial",
                      style: TextStyle(
                          color:colorGPpartialProgress?Colors.yellow[700]:Colors.grey,fontSize: 15
                      ),
                    ),
                    Text("Progress",
                      style: TextStyle(
                          color:colorGPpartialProgress?Colors.yellow[700]:Colors.grey,fontSize: 15
                      ),
                    )
                  ],
                )
            ),
            onTap: (){
              setState(() {
                colorGPMadeProgress = false;
                colorGPpartialProgress = true;
                colorGPNoProgress = false;
              });
            },
          ),
          InkWell(
            child: Container(
                height: 110,
                width: 90,
                decoration: BoxDecoration(
                  //border: Border.all(color:Colors.grey,width: 0.5)
                ),
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.not_interested,
                      color:colorGPNoProgress?Colors.red:Colors.grey,
                      size: 40,
                    ) ,

                    Container(height: 5),
                    Text("No",
                      style: TextStyle(
                          color:colorGPNoProgress?Colors.red:Colors.grey,fontSize: 15
                      ),
                    ),
                    Text("Progress",
                      style: TextStyle(
                          color:colorGPNoProgress?Colors.red:Colors.grey,fontSize: 15
                      ),
                    )
                  ],
                )
            ),
            onTap: (){
              setState(() {
                colorGPMadeProgress = false;
                colorGPpartialProgress = false;
                colorGPNoProgress = true;
              });
            },
          ),
        ],
      ),
    );
  }


  Widget completedActivityReview(){
    return Container(
      margin: EdgeInsets.only(left:10 ,right: 10, top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: cAcheckListItems.map((e) {
          int index = cAcheckListItems.indexOf(e);
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
                  Text("Made",
                    style: TextStyle(
                        color: selectedCAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
                    ),
                  ),
                  Text("Progress",
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


  Widget jointAttentionOrEyeContactReview(){
    return Container(
      margin: EdgeInsets.only(left:10 ,right: 10, top :16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: jAcheckListItems.map((e) {
          int index = jAcheckListItems.indexOf(e);
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
                  Text("Made",
                    style: TextStyle(
                        color: selectedJAIconIndex == index ? Colors.green:Colors.grey,fontSize: 10
                    ),
                  ),
                  Text("Progress",
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
            Text("No"),
            Text("Progress")
          ],
        )
    );
  }


  Widget firstRowEditWidget(){
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
                Text("Painting"),

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
                Text("Baking"),

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
                Text("Vehicles"),

              ],
            )
        ),
      ],
    );
  }




  Widget secondRowEditWidget(){
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
                Text("Excercise"),

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
                Text("Glue"),

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
                Text("Calender"),
              ],
            )
        ),
      ],
    );
  }

  void callCompleteSessionApi(int id) async {
    setState(() {
      _isLoading = true;
    });
    //String url = "http://aosapi.pdgcorp.com/api/SessionNote/210401/CompleteSessionNote";
    String url = baseURL + "SessionNote/$id/CompleteSessionNote";
    CompleteSessionNotes completeSessionNotes = await completeSessionApi.getSessionDetails(url);

    int codeVal = completeSessionApi.statuscode;

    print("code:"+codeVal.toString());

    if(codeVal == 200){

      setState(() {
        _isLoading = false;
        sessionNotes = completeSessionNotes;
        noteText =  completeSessionNotes.notes;
        myNotesController.text = noteText;
      });

      locationHomeOrSchool = completeSessionNotes.location;
      sessionType =  completeSessionNotes.sessionType;
      if(sessionType ==  "Service Provided"){
        setState(() {
          sPSelected = true;
          sPmSelected = false;
          sASelected = false;
          pASelected = false;
          sUSelected = false;
        });
      }else if(sessionType ==  "Service Provided, Makeup"){
        setState(() {
          sPSelected = false;
          sPmSelected = true;
          sASelected = false;
          pASelected = false;
          sUSelected = false;
        });
      }else if(sessionType ==  "Student Absent"){
        setState(() {
          sPSelected = false;
          sPmSelected = false;
          sASelected = true;
          pASelected = false;
          sUSelected = false;
        });
      }else if(sessionType ==  "Provider Absent"){
        setState(() {
          sPSelected = false;
          sPmSelected = false;
          sASelected = false;
          pASelected = true;
          sUSelected = false;
        });
      }else{

        setState(() {

          sPSelected = false;
          sPmSelected = false;
          sASelected = false;
          pASelected = false;
          sUSelected = true;

        });
      }

      if(locationHomeOrSchool.contains("School")){
        setState(() {
          locHomeSelectedButton = false;
          locBuildingSelectedButton = true;
        });
      }else{
        setState(() {
          locHomeSelectedButton = false;
          locBuildingSelectedButton = true;
        });
      }
      settingsGroupOrNot = completeSessionNotes.group;

      if(settingsGroupOrNot == "1"){

        setState(() {

          settingGroupSelectedButton = true;
          settingPersonSelectedbutton = false;

        });
      }else{
        setState(() {
          settingGroupSelectedButton = false;
          settingPersonSelectedbutton = true;
        });
      }

      setState(() {
        duration =  completeSessionNotes.duration.toString();

        sessionDateTime = completeSessionNotes.sessionDate+" "+completeSessionNotes.sessionTime;
        print("From API datetime:"+sessionDateTime);
        toPassDate = new DateFormat("MM/dd/yy hh:mm:ss").parse(sessionDateTime);
        sessionTime = DateFormat.jm().format(toPassDate);

        print(sessionTime);

        endDateTime =  toPassDate.add(Duration(days: 0, hours:0 ,minutes: int.parse(duration)));

        sessionEndTime = DateFormat.jm().format(endDateTime);

        print(sessionEndTime);
        print("In Datetime format"+toPassDate.toString());
        List<Goals> goals = completeSessionNotes.goals;
        if (goals.length > 0) {
          selectedLtGoalId = goals[0].longGoalID;
        } else {
          selectedLtGoalId = longTermGpDropDownList[0].longGoalID;
        }
        LongTermGpDropDownModel model = longTermGpDropDownList.firstWhere((element) => element.longGoalID == selectedLtGoalId);
        if (model != null) {
          _dropDownValue = model.longGoalText;
        }
        List<SessionNoteExtrasList> sessionNotesExtras = sessionNotes.sessionNoteExtrasList;

        if (GlobalCall.socialPragmatics.categoryData.length > 0) {
          if (GlobalCall.socialPragmatics.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.socialPragmatics.categoryData[0].categoryTextAndID){
              bool isSelect = false;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.socialPragmatics.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      isSelect = true;
                    }
                  }
                });
              }
              sPcheckListItems.add(
                  CheckList(
                    title: data.categoryTextDetail,
                    checkVal: isSelect,
                    id: data.categoryTextID,
                  )
              );
            }
          }

          if (GlobalCall.SEITIntervention.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.SEITIntervention.categoryData[0].categoryTextAndID){
              bool isSelect = false;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.SEITIntervention.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      isSelect = true;
                    }
                  }
                });
              }
              sIcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: isSelect, id: data.categoryTextID));
            }
          }

          if (GlobalCall.completedActivity.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.completedActivity.categoryData[0].categoryTextAndID){
              bool isSelect = false;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.completedActivity.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      isSelect = true;
                    }
                  }
                });
              }
              cAcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: isSelect, id: data.categoryTextID));
            }
          }

          if (GlobalCall.jointAttention.categoryData.length > 0) {
            for (CategoryTextAndID data in GlobalCall.jointAttention.categoryData[0].categoryTextAndID){
              bool isSelect = false;
              if (sessionNotesExtras.length > 0) {
                sessionNotesExtras.forEach((element) {
                  if (element.sNECategoryID == GlobalCall.jointAttention.categoryData[0].mainCategoryID) {
                    if (element.sNECategoryDetailID == data.categoryTextID) {
                      isSelect = true;
                    }
                  }
                });
              }
              jAcheckListItems.add(CheckList(title: data.categoryTextDetail, checkVal: isSelect, id: data.categoryTextID));
            }
          }
        }
      });
      checkAnswers();

    }else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  void checkAnswers() {
    List<Goals> goals = sessionNotes.goals;
    List<Activities> activities = sessionNotes.activities;
    setState(() {
      for(int i = 0; i < shortTermGpList.length; i++){
        if(shortTermGpList[i].longGoalID == selectedLtGoalId){
          bool isSelect = false;
          if (goals.length > 0) {
            goals.forEach((element) {
              element.shortGoalIDs.forEach((element) {
                if (element.shortGoalID == shortTermGpList[i].shortgoalid) {
                  isSelect = true;
                }
              });
            });
          }
          selectedShortTermResultListModel.add(
            SelectedShortTermResultListModel(
              id: shortTermGpList[i].shortgoalid,
              selectedId: shortTermGpList[i].longGoalID,
              selectedShortgoaltext: shortTermGpList[i].shortgoaltext,
              checkVal: isSelect,
            ),
          );
        }
      }
      for (CategoryTextAndID data in GlobalCall.activities.categoryData[0].categoryTextAndID){
        List<CheckList> list = [];
        list.add(
            CheckList(
              title: data.categoryTextDetail,
              checkVal: true,
              id: data.categoryTextID,
            )
        );
        for (SubCategoryData subData in data.subCategoryData) {
          bool isSelect = false;
          if (activities.length > 0) {
            activities.forEach((element) {
              if (element.categoryDetailID == data.categoryTextID && element.activityDetailID == subData.subCategoryTextID) {
                isSelect = true;
              }
            });
          }
          list.add(
              CheckList(
                title: subData.subCategoryTextDetail,
                checkVal: isSelect,
                id: subData.subCategoryTextID,
              )
          );
        }
        activitiesListItems[data.categoryTextID] = list;
      }
      goalsAndProgress = true;
      isActivities = true;
      socialPragmaics = true;
      seitIntervention = true;
      competedActivites = true;
      jointAttentionEyeContact = true;
    });
  }

  void addSaveNotesApiCall() async {
    setState(() {
      _isLoading =true;
    });

    var selectedDate1 = new DateFormat("MM/dd/yy hh:mm:ss");

    String dateFinal =  selectedDate1.format(selectedDate);

    sessionTime = DateFormat.jm().format(selectedDate);

    print("date ::"+dateFinal);
    //String dd = dateFinal.split(" ").toString();
    print("time ::"+pickedTime);

    print("duration"+finalNumber.toString());
    noteText = myNotesController.text.toString();
    sessionDateTime = dateFinal;
    sessionTime=pickedTime;
    duration=finalNumber.toString();

    if(locHomeSelectedButton == true){
      locationHomeOrSchool="Home|Class";
    }else{
      locationHomeOrSchool = "School|Class";
    }
    print("locationHomeOrSchool :: "+locationHomeOrSchool);
    if(settingGroupSelectedButton == true){
      settingsGroupOrNot="0";

    }else{
      settingsGroupOrNot="1";
    }

    print("settingsGroupOrNot"+settingsGroupOrNot);

    if(sPSelected == true){
      sessionType = "Service Provided";
    }else if(sPmSelected == true){
      sessionType="Service Provided, Makeup";
    }else if(sASelected == true){
      sessionType="Student Absent";
    }else if(pASelected == true){
      sessionType="Provider Absent";
    }else{
      sessionType="Student unavailable";
    }

    print("sessionType :: "+sessionType);
    confirmedVal="1";

    //String url = "http://aosapi.pdgcorp.com/api/SessionNote/0/CompleteSessionNote";
    String url =  widget.sessionId != null ? baseURL + "SessionNote/${widget.sessionId}/CompleteSessionNote": baseURL + "SessionNote/0/CompleteSessionNote";

/*
    {
      "sessionID": 0,
    "sessionDate": "string",
    "sessionTime": "string",
    "duration": 0,
    "group": "string",
    "location": "string",
    "sessionType": "string",
    "notes": "string",
    "goals": [
      {
        "longGoalID": 0,
        "shortGoalIDs": [
          {
          "shortGoalID": 0
          }
        ]
      }
    ],
    "activities": [
      {
        "categoryDetailID": 0,
        "activityDetailID": 0
      }
    ],
    "confirmed": 0,
    "sessionNoteExtrasList": [
      {
        "snE_CategoryID": 0,
        "snE_CategoryDetailID": 0,
        "snE_SubDetailID": 0
      }
    ]
    }*/
    List<Goals> goals = List();
    List<ShortGoalIDs> shortTerms = List();
    for (SelectedShortTermResultListModel model in selectedShortTermResultListModel) {
      if (model.checkVal) {
        shortTerms.add(ShortGoalIDs(shortGoalID: model.id));
      }
    }
    var goal = Goals(longGoalID: selectedLtGoalId, shortGoalIDs: shortTerms);
    goals.add(goal);
    List<SessionNoteExtrasList> sessionNoteExtrasList = [];

    sPcheckListItems.forEach((element) {
      if (element.checkVal) {
        sessionNoteExtrasList.add(
            SessionNoteExtrasList(sNECategoryID: GlobalCall.SEITIntervention.categoryData[0].mainCategoryID,
                sNECategoryDetailID: element.id,
                sNESubDetailID: 0));
      }
    });
    sIcheckListItems.forEach((element) {
      if (element.checkVal) {
        sessionNoteExtrasList.add(
            SessionNoteExtrasList(sNECategoryID: GlobalCall.SEITIntervention.categoryData[0].mainCategoryID,
                sNECategoryDetailID: element.id,
                sNESubDetailID: 0));
      }
    });
    List<Activities> activities = List();
    activitiesListItems.forEach((key, alist) {
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

    responseAddSession = await addSessionNoteApi.addSessionDetails(url, body: newPost.toJson());

    int codeVal = addSessionNoteApi.statuscode;

    if(codeVal == 200){

      setState(() {
        _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Session Posted Successfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.pop(context);

    } else{

      setState(() {
       _isLoading = false;
      });

      Fluttertoast.showToast(
          msg: "Some Error Occurred, please try Again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 5,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

}

class CheckList{
  String title;
  bool checkVal;
  int id;
  CheckList({this.title, this.checkVal, @required this.id});
}
