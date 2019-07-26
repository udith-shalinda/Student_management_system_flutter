import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:moodle_clone/modle/course.dart';
import 'package:moodle_clone/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CoursePrinter extends StatefulWidget {
  @override
  _CoursePrinterState createState() => _CoursePrinterState();
}

class _CoursePrinterState extends State<CoursePrinter> {

  String id;
  String type;
  List<Course> courseList = new List();

  @override
  void initState() {
      super.initState();
      getSharedPreference();
      getAllCourses();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
            "All courses",
            style: TextStyle(
              fontSize: 25,
            ),
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(
              icon: Icon(Icons.search),
              onPressed: searchKeyPressed,
              )
        ],
      ),
      body: new ListView.builder(
          itemCount: courseList.length,
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
                      title: Text(courseList[index].courseCode),
                      subtitle: Container(
                        alignment: FractionalOffset.topLeft,
                        padding: EdgeInsets.only(top: 30),
                        child:Column(
                          children: <Widget>[
                            Text(courseList[index].name),
                            IconButton(
                              icon: Icon(
                                Icons.add_box,
                                color: Colors.redAccent,
                                ),
                              onPressed: (){
                                addToMyCourses(index);
                              },
                              
                            )
                            // buttonSet(snapshot,index),
                          ],
                        ),
                      ),
                      trailing: new Icon(Icons.arrow_right, color: Colors.grey, size: 50.0),

                      onTap: (){
                        // showQuestion(snapshot.key);
                      },
                    ),
                  )
              );
            
          }
        )
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
  
  void searchKeyPressed(){

  }
  void getAllCourses() async{
    String url = 'http://10.0.2.2:3000/course/getAll';
    var response = await http.Client().get(url ,
        headers: {'Content-Type': 'application/json',},
        );

        if(response.statusCode ==201){
          decodeResponse(response.body);
        }
  }
  void decodeResponse(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); // import 'dart:convert';
      String name = map['message'];
      print(name);
        //go to home page
       
        for(int i =0;i< map['courses'].length;i++){
            setState(() {
              courseList.add(new Course(map['courses'][i]['_id'],map['courses'][i]['name'], map['courses'][i]['credit'],map['courses'][i]['hours'], map['courses'][i]['courseCode'])); 
            });
        }
       
        
        print(map['courses'].length.toString());

  }
  addToMyCourses(int index) async{
    String url;
    if(type == "student"){
      url ="http://10.0.2.2:3000/studentcourse/add";
    }else{
      url ="http://10.0.2.2:3000/lecturecourse/add";
    }
    String json = '{"MyId":"'+ id + '","courseId":"'+courseList[index].id+'"}';
     var response = await http.Client().post(url ,
        headers: {'Content-Type': 'application/json',},
        body: json
        );

      print(response.body);  
  }
}


                              