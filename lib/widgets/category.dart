import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Category extends StatefulWidget{
//  final String name;
//  final int percent;
//  final int todayTasks;

  //Category({Key key, this.name, this.percent,this.todayTasks}) : super(key: key);

  @override
  _CategoryState createState() => new _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 160,
      margin: EdgeInsets.only(left: 5, right: 5, top: 15, bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 15, offset: Offset(0, 5)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
            height: 10,
            ),
            Center(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(70.0),
                  border: Border.all(color: Colors.white,width: 4.0)
                ),
                child: Center(
                  child: Text('75%',style: GoogleFonts.pTSerif(
                    fontSize: 16,
                  color: Colors.white
                ),),),
              ),
            ),
            SizedBox(
                height:70
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 5),
              decoration: BoxDecoration(

              ),
              child: Text(
                'Sport',
                style: GoogleFonts.pTSerif(
                    fontSize: 18,
                    color: Colors.white
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 1,horizontal: 5),
              decoration: BoxDecoration(

              ),
              child: Text(
                '4 tasks for tod',
                style: GoogleFonts.pTSerif(
                    fontSize: 14,
                    color: Colors.white70
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}