import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moodle_clone/modle/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


enum SingingCharacter { Student, Lecture }


class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool incorrectPassword  = false;
  var _formKey = GlobalKey<FormState>();
  String _email;
  String _formpassword;
  String newUserKey ="";
  SingingCharacter _character = SingingCharacter.Student;
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(52, 66, 86, .7),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(56, 66, 86, 1),
        title: new Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        centerTitle: true,
      ),
      body: new ListView(
        children: <Widget>[
//          new Center(
//            child: new Image.asset(
//              'images/cover_two.jpg',
//              fit: BoxFit.fill,
//              width: 500,
//              height: 1000,
//            ),
//          ),
          new Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                    ),
                    validator: (value){
                      String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                      RegExp regExp = new RegExp(p);
                      if(value.length == 0 || !regExp.hasMatch(value)){
                        return "Invalid email";
                      }
                    },
                    onSaved: (value){
                      _email = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the email",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
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
                      fontSize: 21,
                    ),
                    obscureText: true,
                    validator: (value){

                      if(value.length == 0){
                        return "Password is empty";
                      }
                    },
                    onSaved: (value){
                      _formpassword = value;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter the password",
                      hintStyle: TextStyle(
                        color: Colors.white,
                      ),
                      errorText: incorrectPassword ? "User email or password is incorrect":null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                RadioListTile<SingingCharacter>(
                title: const Text('Student'),
                value: SingingCharacter.Student,
                groupValue: _character,
                onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('Lecture'),
                  value: SingingCharacter.Lecture,
                  groupValue: _character,
                  onChanged: (SingingCharacter value) { setState(() { _character = value; }); },
                ),
                RaisedButton(
                  onPressed: signupButton ,
                  color: Color.fromRGBO(52, 66, 86, 1),
                  child: Text(
                    'Login',
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
    );
  }

  void signupButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signupwithEmail(_email, _formpassword,_character.index);
     
    }
  }

  signupwithEmail(String email, String password,int _characterIndex) async {
      String json;
      String url = 'http://10.0.2.2:3000/user/signup';
      if(_characterIndex == 0){
        json = '{"email":"'+ email + '","password":"'+password+'","type":"student"}';
      }else{
        json = '{"email":"'+ email + '","password":"'+password+'","type":"lecture"}';        
      }
       
      var response = await http.Client().post(url ,
        headers: {'Content-Type': 'application/json',},
        body: json
        );

      if(response.statusCode == 201){
        userDetailsPage(response.body);
      } 
  }
  void userDetailsPage(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); // import 'dart:convert';
      String id = map['userId'];
      String type = map['type'];

    //save id and type
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", id);
        prefs.setString("type", type);

        //go to home page
  }
}