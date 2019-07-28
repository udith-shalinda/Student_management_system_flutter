import 'package:flutter/material.dart';
import 'package:moodle_clone/ui/coursecreater.dart';
import 'package:moodle_clone/ui/courseprinter.dart';
import 'package:moodle_clone/ui/login.dart';
import 'package:moodle_clone/ui/showLectureCourses.dart';
import 'package:moodle_clone/ui/showStudentCourses.dart';
import 'package:shared_preferences/shared_preferences.dart';

//picking a date to book
class Home extends StatefulWidget {

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
   
    TabController _controller;
    String id;
    String type;
   

   @override
   void initState(){
     super.initState();
     getSharedPreference();
      _controller = new TabController(length: 2, vsync: this);
    //  getProfileImage();
   }


   @override
   void dispose() {
      _controller.dispose();
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(52, 66, 86, 1.0),
        title: new Text("Home"),
        centerTitle: true,
        bottom: TabBar(
            indicatorColor: Colors.redAccent,
//          labelColor: Colors.black,
          controller: _controller,
          tabs: <Tab>[
            new Tab(icon: new Icon(Icons.home),),
            new Tab(icon: new Icon(Icons.flag),)
          ],
        ),
      ),
      body: new TabBarView(
          controller: _controller,
          children: <Widget>[
              new CoursePrinter(),
              homeWidget(),
          ],),
      
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
      setState(() {
        id =  prefs.getString('userId');
        type = prefs.getString('type');
      });
    }
  }
  Widget homeWidget(){
    if(type == "lecture"){
      return ShowLectureCourses();
    }else if(type == "student"){
      return ShowStudentCourses();
    }else{
      return Container();
    }
  }
}