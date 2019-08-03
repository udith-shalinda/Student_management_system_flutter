import 'package:flutter/material.dart';
import 'package:moodle_clone/ui/home.dart';
import 'package:moodle_clone/ui/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';





class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {


  bool incorrectPassword  = false;
  bool incorrectEmail = false;
  var _formKey = GlobalKey<FormState>();
  String _email;
  String _formpassword;
  String userKey;


  @override
  void initState() {
    super.initState();
    
  }

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
              icon: Icon(Icons.person_add),
              onPressed: signUp,
              )
        ],
      ),
      body: new Stack(
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
                      fontSize: 16,
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
                        ),
                      ),
                      errorText: incorrectEmail ? "User email is incorrect":null,
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
                      errorText: incorrectPassword ? "password is incorrect":null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: loginButton ,
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

  // void getTheUser(Event event){
  //    User user = User.fromSnapshot(event.snapshot);
  //    if(_email == user.email){
  //      userKey = user.key;
  //      print(user.email);
  //    }
    
  // }

  void signUp(){
    var router = new MaterialPageRoute(
        builder: (BuildContext context){
          return new SignUp();
        });
    Navigator.of(context).push(router);
  }

  void loginButton(){
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      signInWithCredentials(_email, _formpassword);
    }
  }

  void signInWithCredentials(String email, String password) async {
      String url = 'http://10.0.2.2:3000/user/login';
      String json = '{"email":"'+ email + '","password":"'+password+'"}';
       
      var response = await http.Client().post(url ,
        headers: {'Content-Type': 'application/json',},
        body: json
        );

      if(response.statusCode == 201){
        homePage(response.body);
      }else if(response.statusCode ==401){
        errorHandle(response.body); 
      }     
  }
  void homePage(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); // import 'dart:convert';
      String id = map['userId'];
      String type = map['type'];
      String userDetailsId = map['userDetailsId'];
      print(userDetailsId);

    //save id and type
        final prefs = await SharedPreferences.getInstance();
        prefs.setString("userId", id);
        prefs.setString("type", type);
        prefs.setString("userDetailsId",userDetailsId);

        //go to home page
        var router = new MaterialPageRoute(
            builder: (BuildContext context){
              return new Home();
            });
        Navigator.of(context).push(router);
  }
  void errorHandle(String responseBody) async{
    Map<String, dynamic> map = jsonDecode(responseBody); 
    String message = map['message'];
    if("Password" == message){
      setState(() {
        incorrectPassword = true;
      });
    }else if("Email" == message){
      setState(() {
       incorrectEmail = true; 
      });
    }
  }

}