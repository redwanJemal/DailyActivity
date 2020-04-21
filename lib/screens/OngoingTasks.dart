import 'package:daily_activity/models/Task.dart';
import 'package:daily_activity/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'NewTask.dart';

class DayName{
  String name;
  int value;

  DayName({this.name,this.value});
}
class OngoingTasks extends StatefulWidget{
  @override
  _OngoingTasksState createState() => _OngoingTasksState();
}
class _OngoingTasksState extends State<OngoingTasks>{

  TaskModel todayTasks;
  final int page = 1;
  final int pageSize = 10;
  Future<List<TaskModel>> taskList;
  List<TaskModel> tasks;
  bool loadingTasks ;
  DateTime _selectedDate;
  String selectedDate;
  List<DayName> daysOfTheWeek = [
      DayName(name: "MON", value: 1),
      DayName(name: "TUE", value: 2),
      DayName(name: "WED", value: 3),
      DayName(name: "THU", value: 4),
      DayName(name: "FRI", value: 5),
      DayName(name: "SAT", value: 6),
      DayName(name: "SAN", value: 7),
  ];

  @override
  void initState(){
    super.initState();
    setTodayDate();
    getTodayTasks();
  }

  getData() async{
    setState(() {
      loadingTasks = true;
      _selectedDate = DateTime.now();
      selectedDate = DateFormat("MMMM,yyyy").format(DateTime.now());
    });
    tasks =  await TaskService().getAllTasks();
    setState(() {
      loadingTasks = false;
    });
  }


  setTodayDate(){
    setState(() {
      _selectedDate = DateTime.now();
      selectedDate = DateFormat("MMMM,yyyy").format(DateTime.now());
    });
  }
  getTask(id) async{
    TaskModel task = await TaskService().getTask(id);
    return task;
  }
  getTodayTasks() async{
    String today = DateFormat.yMMMMd().format(_selectedDate).toString();
    setState(() {
      loadingTasks = true;
    });
    tasks =  await TaskService().getAllTodayTasks(today,page,pageSize);
    setState(() {
      loadingTasks = false;
    });
  }
  deleteTask(id) async{
    await TaskService().deleteTask(id);
  }
  deleteAllTask() async{
    await TaskService().deleteAll();
  }

  Future selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2016),
        lastDate: new DateTime(2022),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        }
    );
    if(picked != null) setState(() {
      _selectedDate = picked;
      selectedDate = DateFormat("MMMM, yyyy").format(picked);
      getTodayTasks();
    });
  }

  changeWeekDay(DayName day){
    DateTime todayDate = _selectedDate;
    int newDay = _selectedDate.day - (_selectedDate.weekday - day.value);
    todayDate = DateTime(todayDate.year,todayDate.month,newDay);
    setState(() {
      _selectedDate = todayDate;
    });
    getTodayTasks();
  }
  Widget dayItem(DayName day){
    int dayValue = _selectedDate.day - (_selectedDate.weekday - day.value);
    if(_selectedDate.day == dayValue){
      return InkWell(
        splashColor: Colors.grey,
        onTap: (){
          changeWeekDay(day);
        },
        child: Container(
          color: Colors.grey,
          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(day.name,style: GoogleFonts.pTSerif(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),),
              ),
              Container(
                child: Text(dayValue.toString(),style: GoogleFonts.pTSerif(
                    fontSize: 12,
                    color: Colors.white
                ),),
              )
            ],
          ),
        ),
      );
    }
    else{
      return InkWell(
        onTap: (){
          changeWeekDay(day);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Text(day.name,style: GoogleFonts.pTSerif(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey
                ),),
              ),
              Container(
                child: Text(dayValue.toString(),style: GoogleFonts.pTSerif(
                    fontSize: 12,
                    color: Colors.grey
                ),),
              )
            ],
          ),
        ),
      );
    }

  }
  Widget back(BuildContext context){
    return Container(
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Color(0xff37474F),size: 18,),
          onPressed: (){
            Navigator.pop(context);
          },
        )
    );
  }
  Widget newTask(BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Text('Today',style: GoogleFonts.pTSerif(
                        fontSize: 28,
                        color: Colors.black54
                    ),),
                  ),
                  SizedBox(height: 2,),
                  Container(
                    child: Text('Welcome Redwan',style: GoogleFonts.pTSerif(
                        fontSize: 14,
                        color: Colors.grey
                    ),),
                  )
                ],
              )
          ),
          Container(
            child: Container(
              child: RaisedButton(

                  color: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    child: Center(
                        child:Row(
                          children: <Widget>[
                            Icon(Icons.add,size: 16,color: Colors.white,),
                            SizedBox(width: 4,),
                            Text('Add Task',style: GoogleFonts.pTSerif(
                                color: Colors.white,
                                fontSize:16
                            ),),
                          ],
                        )),
                  ),
                  onPressed: ()async{
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewTask(isTaskCreate: true,))
                    );
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget weekDays(){

    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(5, 0, 0, 10),
            child: GestureDetector(
              onTap: (){
                selectDate();
              },
              child: Text(selectedDate,style: GoogleFonts.pTSerif(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
              ),),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: daysOfTheWeek.map((day) => dayItem(day)).toList()
          ),
        ],
      ),
      
    );
  }
  Widget task(bold,lighter,TaskModel task){
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(5),
              width: 80,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(task.startTime,style: GoogleFonts.pTSerif(
                    fontSize: 14,
                    color: Colors.grey
                  ),),
                  Text(task.endTime,style: GoogleFonts.pTSerif(
                      fontSize: 14,
                      color: Colors.grey
                  ),)
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                decoration: BoxDecoration(
                  color:Color(bold)
                ),
                child: InkWell(
                  splashColor: Color(bold),
                  onTap: (){
                    getTask(task.id);
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(builder: (context) => NewTask(isTaskCreate: false,))
//                    );
                  },
                  child: Container(
                    color: Color(lighter),
                    padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                    child: Text(task.description,maxLines: 3,overflow: TextOverflow.ellipsis, style: GoogleFonts.pTSerif(
                      color: Color(bold),
                      fontSize: 16,
                    ),),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskLists(){

    final List<int> boldColors = <int>[0xff263238, 0xffFF6F00, 0xff01579B,0xff4A148C,0xff263238, 0xffFF6F00, 0xff01579B,0xff4A148C,0xff263238, 0xffFF6F00, 0xff01579B,0xff4A148C];
    final List<int> lighterColors = <int>[0xffCFD8DC, 0xffFFECB3, 0xffB3E5FC,0xffE1BEE7,0xffCFD8DC, 0xffFFECB3, 0xffB3E5FC,0xffE1BEE7,0xffCFD8DC, 0xffFFECB3, 0xffB3E5FC,0xffE1BEE7];

    if(!loadingTasks){
      if(tasks.length == 0){
        return Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: (){
                  getTodayTasks();
                },
                icon: Icon(Icons.refresh,size: 20,color: Colors.grey),
              ),
              SizedBox(height: 10,),
              Text('No Tasks for Today',style: GoogleFonts.pTSerif(
                fontSize: 24,
                color: Colors.grey
              ),)
            ],
          ),
        );
      }
      else{
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Dismissible(
                key: Key(tasks[index].id.toString()),
                onDismissed: (direction){
//                  deleteTask(tasks[index].id);
//                  setState(() {
//                    tasks.removeAt(index);
//                  });
                },
                background: Container(
                  color: Colors.grey,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 150,
                      child: Row(
                        children: <Widget>[
                          IconButton(
                            onPressed: (){

                            },
                            icon: Icon(Icons.delete),),
                          IconButton(
                            onPressed: (){

                            },
                            icon: Icon(Icons.access_time),)
                        ],
                      ),
                    )
                  ),
                ),
                child: task(boldColors[index % boldColors.length],lighterColors[index % lighterColors.length],tasks[index])
            );
          },
        );
      }
    }
    else {
      return Center(child: CircularProgressIndicator());
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              back(context),
              newTask(context),
              weekDays(),
              Container(
                height: MediaQuery.of(context).size.height - 220,
                padding: EdgeInsets.symmetric(vertical: 5,horizontal: 0),
                child: taskLists(),
              )
            ],
          ),
        ),
      ),
    );
  }

}