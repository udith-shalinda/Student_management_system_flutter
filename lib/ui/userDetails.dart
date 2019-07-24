import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'login.dart';

class UserDetails extends StatefulWidget {
  @override
  UserDetailsState createState() => UserDetailsState();
}

class UserDetailsState extends State<UserDetails> {

  String id;
  String type;
  var _formKey = GlobalKey<FormState>();
  String name;
  String mobile;


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
          "update Details",
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
                          return "Invalid question";
                        }
                      },
                      onSaved: (value){
                        name = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the name",
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
                          return "Description cannot be empty";
                        }
                      },
                      onSaved: (value){
                        mobile = value;
                      },
                      decoration: InputDecoration(
                        hintText: "Enter the mobile",
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
    String url = 'http://10.0.2.2:3000/userDetails/add';
    String json = '{"name":"'+ name + '","mobile":"'+mobile+'","creater":"'+ id +'"}';
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
      String message = map['message'];
      print(message);



        //go to home page
  }
}