import 'package:flutter/material.dart';
import 'package:moodle_clone/ui/coursecreater.dart';
import 'package:moodle_clone/ui/courseprinter.dart';
import 'package:moodle_clone/ui/showStudentCourses.dart';

//picking a date to book
class Home extends StatefulWidget {

   String userEmail='';

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with SingleTickerProviderStateMixin {
   
    TabController _controller;
   

   @override
   void initState(){
     super.initState();
    //  getSharedPreference();
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
              new ShowStudentCourses()
          ],),
      
    );
  }
}