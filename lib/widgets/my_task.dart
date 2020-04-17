import 'package:daily_activity/screens/OngoingTasks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTask extends StatefulWidget{
  @override
  _MyTaskState createState() => new _MyTaskState();
}

class _MyTaskState extends State<MyTask>{

  Widget cardItem(){
    return  Container(
      decoration: BoxDecoration(
        color: Colors.white
      ),
      child: ListTile(
        leading: Icon(Icons.album, size: 30),
        title: Text('Heart Shaker'),
        subtitle: Text('TWICE'),
      ),
    );
  }

  Widget itemCard(BuildContext context){
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,

          children: <Widget>[
            Container(
              child: CircleAvatar(
                radius: 15,
                child: Icon(Icons.star,color: Colors.white,size: 12,),
                backgroundColor: Colors.black26,
              ),
            ),
            SizedBox(width: 12,),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('High Prioriteis',style: GoogleFonts.pTSerif(
                    fontSize: 14
                  ),),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('12 Completed',style: GoogleFonts.pTSerif(
                            fontSize: 10,
                            color: Colors.grey
                    ),),
                        SizedBox(width: 4,child: Text(','),),
                        Text('2 Not yet',style: GoogleFonts.pTSerif(
                            fontSize: 10,
                            color: Colors.grey
                        ),),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget header(){
    return Container(
      child: new Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'My Tasks',
                        style: GoogleFonts.pTSerif(
                            fontSize: 18
                        ),),
                    ),
                    Container(
                      child: Text(
                        'Ongoing Tasks',
                        style: GoogleFonts.pTSerif(
                            fontSize: 12,
                            color: Colors.grey
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 22,
                    child: IconButton(icon: Icon(Icons.calendar_today,size: 18,), onPressed: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OngoingTasks()),
                      );
                    })),
              )
            ],
          )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        header(),
        SizedBox(
          height: 4,
        ),
        Container(
          child: Column(
            children: <Widget>[
              itemCard(context),
              SizedBox(height: 2,),
              itemCard(context),
              SizedBox(height: 2,),
              itemCard(context)
            ],
          ),
        )
      ],
    );
  }

}