import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CoursePrinter extends StatefulWidget {
  @override
  _CoursePrinterState createState() => _CoursePrinterState();
}

class _CoursePrinterState extends State<CoursePrinter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
            "Login",
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
      body: ListView(

      ),
    );
  }

  void searchKeyPressed(){

  }
  void getAllCourses() async{
    String url = 'http://10.0.2.2:3000/course/getAll';
    var response = await http.Client().get(url ,
        headers: {'Content-Type': 'application/json',},
        );

        if(response.statusCode ==201){
          print(response.body);
        }
  }
}