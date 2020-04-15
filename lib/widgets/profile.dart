import 'package:flutter/material.dart';

class Profile extends StatefulWidget{
  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20,
        ),
        Container(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(
                width: 100,
                height: 100,
                child: CircleAvatar(
                    backgroundImage: NetworkImage('https://avatars3.githubusercontent.com/u/21096972?s=400&u=8fa8b641440a0d3fa9da6f163cdf5cfe91ba73b1&v=4'),
                ),
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Redwan Jemal',
              style: Theme.of(context).textTheme.subhead,
            ),
            SizedBox(
              width: 6,
            ),
            GestureDetector(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Icon(Icons.edit,size: 12,),
              ),
              onTap: (){
                debugPrint('edit Profile');
              },
            )
          ],
        ),
        Text(
          'Addis Ababa',
          style: Theme.of(context).textTheme.caption,
        ),
      ],
    );
  }

}