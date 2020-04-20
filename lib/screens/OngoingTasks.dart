import 'package:daily_activity/models/Task.dart';
import 'package:daily_activity/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'NewTask.dart';

class OngoingTasks extends StatefulWidget{
  @override
  _OngoingTasksState createState() => _OngoingTasksState();
}
class _OngoingTasksState extends State<OngoingTasks>{

  TaskModel todayTasks;
  Future<List<TaskModel>> taskList;
  List<TaskModel> tasks;
  bool loadingTasks ;

  @override
  void initState(){
    super.initState();
    getData();
  }

  getData() async{
    setState(() {
      loadingTasks = true;
    });
    tasks =  await TaskService().getAllTasks();
    setState(() {
      loadingTasks = false;
    });
  }

  getTask(id) async{
    TaskModel task = await TaskService().getTask(id);
    return task;
  }

  deleteTask(id) async{
    await TaskService().deleteTask(id);
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
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(task.startTime,style: GoogleFonts.pTSerif(
                    fontSize: 14,
                    color: Color(bold)
                  ),),
                  Text(task.endTime,style: GoogleFonts.pTSerif(
                      fontSize: 14,
                      color: Color(lighter)
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
      return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return task(boldColors[index % boldColors.length],lighterColors[index % lighterColors.length],tasks[index]);
        },
      );
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
              //tasksByDate(),
              //taskLists()
              Container(
                height: MediaQuery.of(context).size.height - 150,
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