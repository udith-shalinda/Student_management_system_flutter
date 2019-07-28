import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:moodle_clone/ui/login.dart';
import 'package:shared_preferences/shared_preferences.dart';


class CourseCreater extends StatefulWidget {
  @override
  CourseCreaterState createState() => CourseCreaterState();
}

class CourseCreaterState extends State<CourseCreater> {

  String id;
  String type;
  var _formKey = GlobalKey<FormState>();
  String courseName;
  String hours;
  String credit;
  String courseCode;


  @override
  void initState() {
    super.initState();
    getSharedPreference();  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        centerTitle: true,
        title: new Text(
          "Create course",
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
          ),
        ],
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            new Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      validator: (value){
                        if(value.length == 0){
                          return "Invalid course name";
                        }
                      },
                      onSaved: (value){
                        courseName = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the course name",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      //obscureText: true,
                      validator: (value){

                        if(value.length == 0){
                          return "Course code cannot be empty";
                        }
                      },
                      onSaved: (value){
                        courseCode = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the course code",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        //errorText: incorrectPassword ? "User email or password is incorrect":null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      //obscureText: true,
                      validator: (value){

                        if(value.length == 0){
                          return "course name cannot be empty";
                        }
                      },
                      onSaved: (value){
                        hours = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the no of hours",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        //errorText: incorrectPassword ? "User email or password is incorrect":null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: TextFormField(
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      //obscureText: true,
                      validator: (value){

                        if(value.length == 0){
                          return "Credit cannot be empty";
                        }
                      },
                      onSaved: (value){
                        credit = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the no of credits",
                        hintStyle: TextStyle(
                          color: Colors.white,
                        ),
                        //errorText: incorrectPassword ? "User email or password is incorrect":null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: saveData ,
                    color: Color.fromRGBO(52, 66, 86, 1),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    textColor: Colors.white70,
                  )
                ],
              ),
            )
          ],
        ),
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
  void saveData(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      updateDetails();
    }
  }
  void updateDetails() async {
    String url = 'http://10.0.2.2:3000/course/add';
    String json = '{"courseName":"'+ courseName + '","hours":"'+hours+'","credit":"'+ credit +'","courseCode":"'+ courseCode +'"}';
     var response = await http.Client().post(url ,
        headers: {'Content-Type': 'application/json',},
        body: json
        );

      if(response.statusCode == 201){
        homePage(response.body);
      }    
  }
  void homePage(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); // import 'dart:convert';
      String courseId = map['courseId'];
      print(courseId);
        //go to home page
  }
}