import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:moodle_clone/modle/course.dart';
import 'package:moodle_clone/ui/lecture/showStudentsInCourse.dart';
import 'package:moodle_clone/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ShowLectureCourses extends StatefulWidget {
  @override
  ShowLectureCoursesState createState() => ShowLectureCoursesState();
}

class ShowLectureCoursesState extends State<ShowLectureCourses> {

  String id;
  String type;
  String userDetailsId;
  List<Course> courseList = new List();

  @override
  void initState() {
      super.initState();
      getSharedPreference();
      
      // print(type);
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
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
                            RaisedButton(
                              child: Text("Students results"),
                              onPressed: (){
                                studentResultPage(courseList[index].id);
                              }
                            ),
                            RaisedButton(
                              child: Text("upload Notes"),
                              onPressed: (){
                                uploadPdf();
                              },
                            ),
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
      userDetailsId = prefs.getString('userDetailsId');
      getStudentCourses();
    }
  }
  
  void searchKeyPressed(){

  }
  Future getStudentCourses() async{
    
    String url = "http://10.0.2.2:3000/lectureCourse/get/$userDetailsId";
    
    var response = await http.Client().get(url ,
        headers: {'Content-Type': 'application/json',},
        );

        if(response.statusCode ==201){
          decodeResponse(response.body);
        }
  }
  void decodeResponse(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); // import 'dart:convert';
      // String message = map['message'];
      // print(message);
        // go to home page
       
        for(int i =0;i< map['courses'].length;i++){
          setState(() {
            courseList.add(new Course(
              map['courses'][i]['courseDetails'][0]['_id'],
              map['courses'][i]['courseDetails'][0]['name'],
              map['courses'][i]['courseDetails'][0]['credit'],
              map['courses'][i]['courseDetails'][0]['hours'],
              map['courses'][i]['courseDetails'][0]['courseCode']
              )); 
          });
        }
  }
  void studentResultPage(String courseId){
    var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new ShowStudentsInCourse(courseId:courseId);
            });
        Navigator.of(context).push(router);
  }
  void uploadPdf() async{
    try{
      // File file = await FilePicker.getFile(type: FileType.ANY);
      File file = await ImagePicker.pickImage(source: ImageSource.gallery);

      if(file != null){
        print("file is not null and call the back end");
        //update course notes
        String url = 'http://10.0.2.2:3000/lectureCourse/update/$userDetailsId';
        // String json = '{"file":"'+ base64Encode(file.readAsBytesSync()) + '"}';
        String json = '{"file":"'+  base64Encode(file.readAsBytesSync()) + '"}';
        var response = await http.Client().post(url ,
            headers: {'Content-Type': 'application/json',},
            body: json
            );

          if(response.statusCode == 201){
            print(response.body);
          }    
      }
    }catch(e){
      print(e);
    }
  }
}


                              