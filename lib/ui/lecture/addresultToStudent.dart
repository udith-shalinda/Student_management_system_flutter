import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_clone/modle/course.dart';
import 'package:moodle_clone/modle/student.dart';
import 'package:moodle_clone/ui/home.dart';
import 'package:moodle_clone/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SingingCharacter { A ,B,C,D,E }

class AddResult extends StatefulWidget {
  
  final String studentCourseId;
  AddResult({Key  key, @required this.studentCourseId}):super(key:key);
  
  @override
  AddResultState createState() => AddResultState();
}

class AddResultState extends State<AddResult> {

  String id;
  String type;
  SingingCharacter _character = SingingCharacter.A;

  

  @override
  void initState() {
      super.initState();
      getSharedPreference();
      
      // print(type);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add result"),
        backgroundColor: Color.fromRGBO(52, 66, 86, 1.0),
      ),
      body: ListView(
        children: <Widget>[
          RadioListTile<SingingCharacter>(
                title: const Text('A'),
                value: SingingCharacter.A,
                groupValue: _character,
                onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('B'),
                  value: SingingCharacter.B,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('C'),
                  value: SingingCharacter.C,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('D'),
                  value: SingingCharacter.D,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('E'),
                  value: SingingCharacter.E,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RaisedButton(
                  onPressed: addResult ,
                  color: Color.fromRGBO(52, 66, 86, 1),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  textColor: Colors.white70,
                )
        ],
      ),
    );
    
    
  }

  void getSharedPreference() async{
    final prefs = await SharedPreferences.getInstance();   //save username
    if(prefs.getString('userId') == null){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
            (Route<dynamic> route) => false,
      );
    }else{
      id =  prefs.getString('userId');
      type = prefs.getString('type');
      }
  }
  
  Future addResult() async{
    
    print(_character.toString().split('.').last);
    String url = "http://10.0.2.2:3000/studentcourse/addResult";
    String json = '{"studentCourseId":"'+ widget.studentCourseId + '" , "Result" : "'+ _character.toString().split('.').last +'"}';
    var response = await http.Client().post(url ,
        headers: {'Content-Type': 'application/json',},
        body: json
        );
        if(response.statusCode ==201){
          var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new Home();
            });
          Navigator.of(context).push(router);
        }
  }
  
  
}


                              