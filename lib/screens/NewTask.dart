import 'package:daily_activity/database/Database.dart';
import 'package:daily_activity/models/Category.dart';
import 'package:daily_activity/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:math' as math;

class NewTask extends StatefulWidget{
  @override
  _NewTaskState createState() => new _NewTaskState();
}

class _NewTaskState extends State<NewTask>{

  final _formKey = GlobalKey<FormState>();
  List<CategoryModel> categories;
  bool loadingCategories;
  TextEditingController _dateController = new TextEditingController();
  TextEditingController _startTimeController = new TextEditingController();
  TextEditingController _endTimeController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  // data for testing
  List<CategoryModel> testCategories = [
    CategoryModel(id:1,name: "Tefsir", count: 1),
    CategoryModel(id:2,name: "Seera", count: 2),
    CategoryModel(id:3,name: "Sport", count: 3),
    CategoryModel(id:4,name: "Hifz", count: 2),
    CategoryModel(id:5,name: "Subhi", count: 3),
  ];

  @override
  void initState(){
    super.initState();
    getData();
  }

  getData() async{
    setState(() {
      loadingCategories = true;
    });
    categories =  await DBProvider.db.getAllCategories();
    setState(() {
      loadingCategories = false;
    });
  }

  processData() async{
    var data = {
      'date': _dateController.text,
      'startTime': _startTimeController.text,
      'endTime': _endTimeController.text,
      'description': _descriptionController.text
    };
    print(data);
    // Insert new Category
    CategoryModel rnd = testCategories[math.Random().nextInt(testCategories.length)];
     await DBProvider.db.newCategory(rnd);
  }

  Widget header(BuildContext context){
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(5),
      color: Color(0xff37474F),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          back(context),
          SizedBox(
            height: 10,
          ),
          newTask(),
        ],
      ),
    );
  }
  Widget back(BuildContext context){
    return Container(
        child: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white,size: 16,),
          onPressed: (){
            Navigator.pop(context);
          },
        )
    );
  }
  Widget newTask(){
    return Container(
      margin: EdgeInsets.fromLTRB(5, 0, 0, 0),
      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
      decoration: BoxDecoration(

      ),
      child: Text('Create New Task',style: GoogleFonts.pTSerif(
          color: Colors.white,
          fontSize: 25
      ),),
    );
  }

  Widget createTaskButton(BuildContext context){
    return Container(
      child: RaisedButton(
          color: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(18.0),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.all(10),
            child: Center(
                child:Text('Create Task',style: GoogleFonts.pTSerif(
                    color: Colors.white,
                    fontSize:14
                ),)),
          ),
          onPressed: (){
            if (_formKey.currentState.validate()) {
              // If the form is valid, display a snackbar. In the real world,
              // you'd often call a server or save the information in a database.
              processData();
              Scaffold
                  .of(context)
                  .showSnackBar(SnackBar(content: Text('Processing Data')));
            }
          }
      ),
    );
  }
  Widget createNewTask(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        header(context),
        formInput(context),
      ],
    );
  }

  Widget formInput(BuildContext context){
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),

              color: Color(0xff37474F),
              child: darkBgFormFields(),
            ),
            SizedBox(height: 4,),
            Container(
              width:MediaQuery.of(context).size.width,
              margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
              padding: EdgeInsets.all(20),
              child: lighterBgFormFields(context),
            )
          ],
        ),
      ),
    );
  }
  Widget darkBgFormFields(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          cursorColor: Colors.grey,
          style: GoogleFonts.pTSerif(
            color: Colors.white,
          ),
          decoration: const InputDecoration(
            labelText: 'Task Title',
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey)
            ),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color:Colors.white)
            ),
            labelStyle: TextStyle(
                color: Colors.grey
            ),
            errorStyle: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter title';
            }
            return null;
          },
        ),
        datePickerWidget(context),
      ],
    );
  }
  Widget lighterBgFormFields(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        timePickerWidget(),
        SizedBox(height:5),
        TextFormField(
          controller: _descriptionController,
          keyboardType: TextInputType.multiline,
          maxLines: 2,
          cursorColor: Colors.grey,
          style: GoogleFonts.pTSerif(
            color: Colors.black,
          ),
          decoration: new InputDecoration(
            labelText: 'Description',
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color:Colors.black)
            ),
            labelStyle: TextStyle(
                color: Colors.grey
            ),
            errorStyle: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Please enter description';
            }
            return null;
          },
        ),
        SizedBox(height: 10,),
        categoryList(context),

      ],
    );
  }

  Future _endTime() async{
    TimeOfDay end = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
    );
    if(end != null) setState(() {
      String period = end.period == DayPeriod.pm?" Pm":" Am";
      _endTimeController.text = end.hour.toString() + " : " + end.minute.toString() + period;
    });
  }
  Future _startTime() async{
    TimeOfDay start = await showTimePicker(
      initialTime: TimeOfDay.now(),
      context: context,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark(),
            child: child,
          );
        }
    );
    if(start != null) setState(() {
      String period = start.period == DayPeriod.pm?" Pm":" Am";
      _startTimeController.text = start.hour.toString() + " : " + start.minute.toString() + period;
    });
  }
  Future _selectDate() async {
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
    if(picked != null) setState(() => _dateController.text = DateFormat.yMMMMd().format(picked));
  }

  Widget timePickerWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          width:80,
          child: InkWell(
            onTap: () {
              _startTime();   // Call Function that has showDatePicker()
            },
            child: IgnorePointer(
              child: new TextFormField(
                controller: _startTimeController,
                decoration: new InputDecoration(
                    hintText: 'Start',
                    labelText: 'Start',
                    labelStyle: TextStyle(color: Colors.grey)
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Select Start Time';
                  }
                  return null;
                },
                // validator: validateDob,
                onSaved: (String val) {},
              ),
            ),
          ),
        ),
        SizedBox(width:30),
        Container(
          width:80,
          child: InkWell(
            onTap: () {
              _endTime();   // Call Function that has showDatePicker()
            },
            child: IgnorePointer(
              child: new TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(
                    hintText: 'End',
                    labelText: 'End',
                    labelStyle: TextStyle(color: Colors.grey)
                ),

                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please Select Start Time';
                  }
                  return null;
                },
                // validator: validateDob,
                onSaved: (String val) {},
              ),
            ),
          ),
        )
      ],
    );
  }
  Widget datePickerWidget(BuildContext context){

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width:(MediaQuery.of(context).size.width / 2) - 40,
          child: InkWell(
            onTap: (){
              _selectDate();
            },
            child: IgnorePointer(
              child: TextFormField(
                controller: _dateController,
                showCursor: false,
                style: GoogleFonts.pTSerif(
                color: Colors.white,
                ),
                decoration: const InputDecoration(
                labelText: 'DATE',

                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color:Colors.white)
                  ),
                labelStyle: TextStyle(
                color: Colors.grey
                ),
                errorStyle: TextStyle(
                color: Colors.redAccent,
                ),
                ),
                validator: (value) {
                if (value.isEmpty) {
                return 'Please enter title';
                }
                return null;
                },
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomRight,
          child: InkWell(
              child: Icon(
                Icons.calendar_today,color: Colors.white,size: 20,
              ),
              onTap: (){
                _selectDate();
              }
          ),
        ),
      ],
    );
  }
  Widget categoryList(BuildContext context){

    final List<int> colorCodes = <int>[0xff27454F, 0xff5F5F5F, 0xff37474F,0xff37474F,0xff37474F];
    int i = 0;

    if(!loadingCategories){
      return Container(
        width: (MediaQuery.of(context).size.width) - 20,
        decoration: BoxDecoration(
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Category',style: GoogleFonts.pTSerif(
                fontSize: 18
            ),),
            SizedBox(height: 10,),
            Wrap(
              direction: Axis.horizontal,
              children: categories.map((item) => categoryItem(context,item,colorCodes[i++ % categories.length])).toList().cast<Widget>(),
            )
          ],
        ),
      );
    }
    else {
    return CircularProgressIndicator();
    }
  }
  Widget categoryItem(BuildContext context, CategoryModel category, int color){

    return InkWell(
        onTap: () {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text(category.name),
            backgroundColor: Color(color),
          ));
        },
        child: Container(
          width: 90,

          margin: EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Color(color),
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),

          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
            child: Center(
              child: Text(category.name,style: TextStyle(color:Colors.white,),overflow: TextOverflow.ellipsis,),
            ),
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints){
            return new SingleChildScrollView(
              child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Container(
                  width:MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      createNewTask(context),
                      Positioned(

                          bottom: 20,
                          left: 10,
                          child: createTaskButton(context)
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}