import 'package:flutter/material.dart';


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
}