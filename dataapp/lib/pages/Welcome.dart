import 'dart:io';

import 'package:dataapp/CRUD.dart';
import 'package:dataapp/pages/Home.dart';
import 'package:dataapp/pages/Login.dart';
import 'package:dataapp/pages/Register.dart';
import 'package:dataapp/styles/colors.dart';
import 'package:dataapp/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  var _isLoading = true;
  var _loggedIn = false;
  var name;


  checkIfLoggedIn(){
    userManagement().checkIfLoggedIn().then((loggedIn){
      setState(() {
        _loggedIn = loggedIn;
        _isLoading = false;
      });
      if(_loggedIn){
        userManagement().getCurrentUser().then((user){
          if(user!=null){
            userManagement().getUserDetails(user.email).then((userData){
              setState(() {
                name = userData.data["name"];
              });
            });
          }
        });
      }
    });
  }

  @override
  void initState() {
    checkIfLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30,),
                SizedBox(height: 30,),
                Text(
                    "Attendance",
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                    "Easy way yo record & track attendance",
                  style: TextStyle(
                    color: grey
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Image.asset(
                  "assets/images/welcomeImage.png",
                  height: 300,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 50,),

                name!=null?Text(
                  "Welcome back $name",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ):SizedBox(),
                SizedBox(height: 20,),
                Text(
                  "Mark Attendance",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Fast & easy way to record and track attendance of your trainings",
                  style: TextStyle(
                      color: grey
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30,),
                _isLoading?Center(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: Platform.isIOS?CupertinoActivityIndicator(animating: true,):CircularProgressIndicator(strokeWidth: 4,backgroundColor: white,),
                  ),
                ):SizedBox(),
                SizedBox(height: 20,),
                !_loggedIn?Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              side: BorderSide(color: Colors.blueGrey)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
                            },
                            disabledColor: veryLightGrey,
                            color: white,
                            textColor: Colors.blueGrey,
                            child: Center(
                              child: Text("Log in", style: TextStyle(
                                  fontFamily: fontName,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.center,),
                            )
                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              // side: BorderSide(color: Colors.blueGrey)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                            },
                            disabledColor: veryLightGrey,
                            color: Colors.blueGrey,
                            textColor: white,
                            child: Center(
                              child: Text("Sign Up", style: TextStyle(
                                  fontFamily: fontName,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.center,),
                            )
                        ),
                      ),
                    ),
                  ],
                ):
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50.0,
                        width: double.infinity,
                        child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(25.0),
                              // side: BorderSide(color: Colors.blueGrey)
                            ),
                            onPressed: (){
                              Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                            },
                            disabledColor: veryLightGrey,
                            color: Colors.blueGrey,
                            textColor: white,
                            child: Center(
                              child: Text("Get Started", style: TextStyle(
                                  fontFamily: fontName,
                                  fontWeight: FontWeight.bold
                              ),textAlign: TextAlign.center,),
                            )
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
