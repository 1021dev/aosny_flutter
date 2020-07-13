import 'package:aosny_services/api/progress_amount_api.dart';
import 'package:aosny_services/helper/global_call.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:aosny_services/models/progress_amount_model.dart';
import 'package:flutter/material.dart';




class ProgressScreen extends StatefulWidget {

  @override
  _ProgressScreenState createState() => _ProgressScreenState();

}

class _ProgressScreenState extends State<ProgressScreen> with AutomaticKeepAliveClientMixin<ProgressScreen> {
  @override
  bool get wantKeepAlive => true;


  var refreshKey = GlobalKey<RefreshIndicatorState>();
  bool isFiltered = false;
  bool isStart = false;
  bool isEnd = false;
  DateTime selectedCurrentDate;
  DateTime selectedStartDate;
  DateTime selectedEndDate;

  String startDate =" ";
  String endDate=" ";
  ProgressAmountApi progressAmountApi = new ProgressAmountApi();
  String durationToString(int minutes) {
    var d = Duration(minutes:minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
  }

  showDateTimePicker(String whichStringType)async{

    if(whichStringType == 'Start Date'){
      final datePick= await showDatePicker(
        context: context,
        initialDate: selectedStartDate ?? DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
      );
      if(datePick != null && datePick != selectedStartDate){
        setState(() {
          selectedStartDate = datePick;
          startDate = DateFormat('MM/dd/yyyy').format(datePick);
          isStart = true;
        });
      }

    }else{
      final datePick= await showDatePicker(
        context: context,
        initialDate: selectedEndDate ?? DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
      );
      if(datePick != null && datePick != selectedEndDate){
        setState(() {
          selectedEndDate = datePick;
          endDate = DateFormat('MM/dd/yyyy').format(datePick);
          isEnd = true;
        });
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(10),
        child: Column(
          children: <Widget>[
            GlobalCall.filterDates ?
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                FlatButton(
                  color: Colors.blue,
                  onPressed: () async {
                    showDateTimePicker('Start Date');
                  },
                  child: isStart ? Text(
                    startDate,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ) : Text("Select Start Date",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                FlatButton(
                  color: Colors.blue,
                  onPressed: (){
                    showDateTimePicker('End Date');
                  },
                  child: isEnd ? Text(
                    endDate,style: TextStyle(
                    color:Colors.white,
                  ),
                  ) : Text("Select End Date",
                    style: TextStyle(
                      color:Colors.white,
                    ),
                  ),
                )
              ],
            )
                :Container(),
            Divider(height: 0, thickness: 0.5,),
            Text("This Week",
              style: TextStyle(color:Colors.grey, fontSize:16),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 10),
                height: MediaQuery.of(context).size.height,
                child: RefreshIndicator(
                  key: refreshKey,
                  child:  FutureBuilder<List<ProgressAmountModel>>(
                      future: progressAmountApi.getProgressAmountList(startDate, endDate),
                      builder: (BuildContext context , AsyncSnapshot<List<ProgressAmountModel>> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        if(snapshot.data.length > 0){

                          return ListView.separated(
                              separatorBuilder: (context, index) {
                                return Divider(height: 0, thickness: 0.5,);
                              },
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index){
                                String  mandatedMins = durationToString(snapshot.data[index].mandatedMins);
                                String  serviceMins = durationToString(snapshot.data[index].serviceMins);
                                String  mandatedNDMins = durationToString(snapshot.data[index].mandatedNDMins);
                                String  nDMins = durationToString(snapshot.data[index].nDMins);

                                var sessionPercentInString= (int.parse(serviceMins.split(':')[0])/int.parse(mandatedMins.split(':')[0])).toString();
                                var sessionPercentResultInString =sessionPercentInString.substring(0,3);
                                var ndPercentInString = (int.parse(nDMins.split(':')[0])/int.parse(mandatedNDMins.split(':')[0])).toString();
                                var ndPercentResultInString =ndPercentInString.substring(0,3);
                                print('sessionPercentInString:$sessionPercentResultInString');
                                print("ndPercentInString:$ndPercentResultInString");

                                return Column(
                                  children: <Widget>[
                                    Container(
                                      padding: const EdgeInsets.fromLTRB(10,10,0,5),
                                      alignment: Alignment.topLeft,
                                      height: MediaQuery.of(context).size.height/5.4,
                                      width:  MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20)
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                                            child:Text('${snapshot.data[index].fname} ${snapshot.data[index].lname}',
                                              style: TextStyle(fontWeight:FontWeight.bold, fontSize: 16),),),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              width: MediaQuery.of(context).size.width,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: <Widget>[

                                                  Container(
                                                      width: MediaQuery.of(context).size.width/2.4,
                                                      height: MediaQuery.of(context).size.height/4.8,
                                                      child: Row(
                                                        children: <Widget>[
                                                          new CircularPercentIndicator(
                                                            radius: MediaQuery.of(context).size.width/8,
                                                            lineWidth: 5.5,
                                                            percent:double.parse(sessionPercentResultInString),
                                                            circularStrokeCap: CircularStrokeCap.round,
                                                            center: new Text('$serviceMins',
                                                              style: TextStyle(fontSize:MediaQuery.of(context).size.height/70.5,
                                                                  color:Colors.grey
                                                              ),
                                                            ),
                                                            progressColor: double.parse(sessionPercentResultInString)>=0.5?Colors.blue
                                                                :double.parse(sessionPercentResultInString)>=0.3 ?Colors.orange:Colors.red,
                                                          ),
                                                          SizedBox(width:5),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text("Sessions",style: TextStyle(fontWeight:FontWeight.bold)),
                                                              SizedBox(height:5),
                                                              Text('of ${mandatedMins.split(':')[0]} Hour',
                                                                style: TextStyle(color:Colors.grey,fontSize: 12),
                                                              ),
                                                              SizedBox(height:5),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width/3.6,
                                                                child: FittedBox(

                                                                  child: Text('${int.parse(mandatedMins.split(':')[0])-int.parse(serviceMins.split(':')[0])} Hour Remaining',
                                                                    style: TextStyle(color:Colors.red,
                                                                        fontSize: MediaQuery.of(context).size.height/60
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                  //------------non-direct----------------
                                                  Container(
                                                      width: MediaQuery.of(context).size.width/2.4,
                                                      child: Row(
                                                        children: <Widget>[
                                                          new CircularPercentIndicator(
                                                              radius:  MediaQuery.of(context).size.width/8,
                                                              lineWidth: 5.5,
                                                              percent:double.parse(ndPercentResultInString),//ndPercent
                                                              circularStrokeCap: CircularStrokeCap.round,
                                                              center: new Text('$nDMins',

                                                                style: TextStyle(fontSize:MediaQuery.of(context).size.height/70.5,
                                                                    color:Colors.grey
                                                                ),
                                                              ),
                                                              progressColor: double.parse(ndPercentResultInString)>=0.5?Colors.blue
                                                                  :double.parse(ndPercentResultInString)>=0.3 ?Colors.orange:Colors.red
                                                          ),
                                                          SizedBox(width:5),
                                                          Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: <Widget>[
                                                              Text("Non-Direct",style: TextStyle(fontWeight:FontWeight.bold)),
                                                              SizedBox(height:5),
                                                              Text('of ${mandatedNDMins.split(':')[0]} Hour',
                                                                style: TextStyle(color:Colors.grey,fontSize: 12),
                                                              ),
                                                              SizedBox(height:5),
                                                              SizedBox(
                                                                width: MediaQuery.of(context).size.width/3.6,
                                                                child: FittedBox(
                                                                  child: Text('${int.parse(mandatedNDMins.split(':')[0])-int.parse(nDMins.split(':')[0])} Hour Remaining',
                                                                    style: TextStyle(color:Colors.red,
                                                                        fontSize: MediaQuery.of(context).size.height/60
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ],
                                                      )
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height:10)
                                  ],
                                );
                              }
                          );

                        }else{

                          return Center(
                            child: Text("Haven't found any data"),
                          );
                        }


                      }



                  ), onRefresh: refreshList,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 4));

    setState(() {
      progressAmountApi.getProgressAmountList(startDate, endDate);
      print("pull api called");
      //list = List.generate(random.nextInt(10), (i) => "Item $i");
    });

    return null;
  }

  @override
  void initState() {

    selectedCurrentDate =  new DateTime.now();
    print("currentDate"+'$selectedCurrentDate');
    startDate =   DateFormat('MM/dd/yyyy').format(DateTime.now()).toString();
    print("DateFormat currentDate:::"+'$startDate');


    DateTime today = new DateTime.now();
    DateTime fiftyDaysAgo = today.subtract(new Duration(days: 7));

    endDate =  DateFormat('MM/dd/yyyy').format(fiftyDaysAgo).toString();

    print("before 7 days::::"+endDate.toString());

    setState(() {
      isStart =  false ;
      isEnd  = false ;
    });
    super.initState();
  }

}