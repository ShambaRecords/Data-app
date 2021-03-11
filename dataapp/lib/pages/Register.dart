import 'dart:io';

import 'package:dataapp/CRUD.dart';
import 'package:dataapp/styles/colors.dart';
import 'package:dataapp/styles/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  var _isLoading = false;
  var _msg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(height: 30,),
              Text(
                "Create New Account",
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 25
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                "Enter your details to create a new account",
                style: TextStyle(
                    color: grey
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40,),
              CupertinoTextField(
                placeholder: "Full Name",
                controller: _fullNameController,
                placeholderStyle: TextStyle(
                    color: Colors.grey[400]
                ),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1,style: BorderStyle.solid,color: veryLightGrey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                padding: EdgeInsets.all(15.0),
                keyboardType: TextInputType.text,
                onChanged: (value){
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20,),
              CupertinoTextField(
                placeholder: "Valid Email",
                controller: _emailController,
                placeholderStyle: TextStyle(
                    color: Colors.grey[400]
                ),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1,style: BorderStyle.solid,color: veryLightGrey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                padding: EdgeInsets.all(15.0),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value){
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20,),
              CupertinoTextField(
                placeholder: "Password",
                controller: _passController,
                placeholderStyle: TextStyle(
                    color: Colors.grey[400]
                ),
                decoration: BoxDecoration(
                  color: white,
                  border: Border.all(width: 1,style: BorderStyle.solid,color: veryLightGrey),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                padding: EdgeInsets.all(15.0),
                keyboardType: TextInputType.text,
                obscureText: true,
                onChanged: (value){
                  setState(() {

                  });
                },
              ),
              SizedBox(height: 20,),
              _isLoading?Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: Platform.isIOS?CupertinoActivityIndicator(animating: true,):CircularProgressIndicator(strokeWidth: 4,backgroundColor: white,),
                ),
              ):SizedBox(),
              _msg!=null?Text(
                "$_msg",
                style: TextStyle(
                    color: Colors.red
                ),
              ):SizedBox(),
              SizedBox(height: 20,),
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0),
                      // side: BorderSide(color: Colors.blueGrey)
                    ),
                    onPressed: ()async{
                      if(_fullNameController.text.isNotEmpty&&_emailController.text.isNotEmpty&&_passController.text.isNotEmpty){
                        setState(() {
                          _isLoading = true;
                          _msg = null;
                        });
                        FirebaseAuth.instance.createUserWithEmailAndPassword(email: _emailController.text,password: _passController.text).then((user){
                          userManagement().saveUserDetails(_emailController.text,_fullNameController.text).then((data){
                            Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                          });
                        }).catchError((e){
                          setState(() {
                            _isLoading = false;
                            _msg = e.message;
                          });
                        });
                      }else {
                        setState(() {
                          _msg = "All fields are required";
                        });
                      }
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
