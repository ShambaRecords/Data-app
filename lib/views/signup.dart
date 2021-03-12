import 'package:data/controllers/authenticate.dart';
import 'package:data/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool btnActive = true;
  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
        body: SingleChildScrollView(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text(
                      'Signup',
                      style:
                          TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(260.0, 125.0, 0.0, 0.0),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 80.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.green),
                    ),
                  )
                ],
              ),
            ),
            Container(
                padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Form
                (
                  key: _formKey,
                                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailField,
                        validator: (value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  },
  keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                            labelText: 'EMAIL',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            // hintText: 'EMAIL',
                            // hintStyle: ,
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                      ),
                      SizedBox(height: 10.0),
                      TextFormField(
                        controller: _passwordField,
                        key: ValueKey('password'),
  validator: (value) {
    if (value.isEmpty || value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  },
                        decoration: InputDecoration(
                            labelText: 'PASSWORD ',
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green))),
                        obscureText: true,
                      ),
                      SizedBox(height: 10.0),
              
                      SizedBox(height: 50.0),
                      Container(
                          height: 40.0,
                          child: btnActive ? GestureDetector(
                            onTap: () async{
                                if(_formKey.currentState.validate()){
                                  setState(() {
                                    btnActive=false;
                                  });
                                bool success = await register(_emailField.text, _passwordField.text);
                                if(success){
                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.setString('email', _emailField.text);
                                  _formKey.currentState.reset();
                                  setState(() {
                                    btnActive=true;
                                  });
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()),);
                                }else{
                                 
                                  setState(() {
                                    btnActive=true;
                                  });
                                }
                              }},
                                                      child: Material(
                              borderRadius: BorderRadius.circular(20.0),
                              shadowColor: Colors.greenAccent,
                              color: Colors.green,
                              elevation: 7.0,
                              child: Center(
                                child: Text(
                                  'Register ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ),
                          ) :Center(child:CircularProgressIndicator(backgroundColor: Colors.green,)),
                          ),
                      SizedBox(height: 20.0),
                      Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: 
                            
                                Center(
                                  child: Text('Go Back',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat')),
                                ),
                            
                            
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}
