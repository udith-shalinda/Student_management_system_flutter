import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_clone/modle/student.dart';
import 'package:moodle_clone/ui/lecture/addresultToStudent.dart';
import 'package:moodle_clone/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShowStudentsInCourse extends StatefulWidget {
  
  final String courseId;
  ShowStudentsInCourse({Key  key, @required this.courseId}):super(key:key);
  
  @override
  ShowStudentsInCourseState createState() => ShowStudentsInCourseState();
}

class ShowStudentsInCourseState extends State<ShowStudentsInCourse> {

  String id;
  String type;
  List<Student> studentList = new List();

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
        title: Text("Students' in course"),
        backgroundColor: Color.fromRGBO(52, 66, 86, 1.0),
      ),
      body: ListView.builder(
          itemCount: studentList.length,
          itemBuilder: (BuildContext ctxt, int index) {
              return new Card(
                  elevation: 8.0,
                  margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: new Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: new ListTile(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                     leading: Container(
                                       padding: EdgeInsets.only(right: 12.0),
//                                        decoration: new BoxDecoration(
//                                            border: new Border(
//                                                right: new BorderSide(width: 1.0, color: Colors.white24))),
                                       child: CircleAvatar(
                                         radius: 30.0,
                                         backgroundColor: Colors.blue,
                                         child: new Text("fsf"),
                                       ),
                                     ),
                      title: Text(studentList[index].name),
                      subtitle: Container(
                        alignment: FractionalOffset.topLeft,
                        padding: EdgeInsets.only(top: 30),
                        child:Column(
                          children: <Widget>[
                            Text(studentList[index].result),
                            // buttonSet(snapshot,index),
                          ],
                        ),
                      ),
                      trailing: new Icon(Icons.arrow_right, color: Colors.grey, size: 50.0),

                      onTap: (){
                        addResultToStudent(studentList[index].id);
                      },
                    ),
                  )
              );
            
          }
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
      getStudentsInCourses();
    }
  }
  
  void searchKeyPressed(){

  }
  Future getStudentsInCourses() async{
    
    String url = "http://10.0.2.2:3000/studentcourse/studentsInCourse";
    String json = '{"courseId":"'+ widget.courseId + '"}';
    var response = await http.Client().post(url ,
        headers: {'Content-Type': 'application/json',},
        body: json
        );
        if(response.statusCode ==201){
          decodeResponse(response.body);
        }
  }
  void decodeResponse(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); // import 'dart:convert';
      String message = map['message'];
      print(message);
        
       
        for(int i =0;i< map['students'].length;i++){
          setState(() {
            studentList.add(new Student(
              map['students'][i]['_id'],
              map['students'][i]['studentDetails'][0]['name'],
              map['students'][i]['result']
              )); 
          });
        }
        print(map['students'].length.toString());
  }
  void addResultToStudent(String studentCourseId){
    var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new AddResult(studentCourseId:studentCourseId);
            });
        Navigator.of(context).push(router);
  }
  
}


                              