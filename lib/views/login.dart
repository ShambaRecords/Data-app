import 'package:data/controllers/authenticate.dart';
import 'package:data/views/home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool btnActive = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        
        body: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                                      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Welcome',
                        style:
                            TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(16.0, 175.0, 0.0, 0.0),
                    child: Text('Login',
                        style:
                            TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold)),
                ),
                Container(
                    padding: EdgeInsets.fromLTRB(220.0, 175.0, 0.0, 0.0),
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                )
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                    TextFormField(
                      controller: _email,
                       validator: (value) {
    if (value.isEmpty || !value.contains('@')) {
      return 'Please enter a valid email address.';
    }
    return null;
  },
                      decoration: InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _password,
                       validator: (value) {
    if (value.isEmpty || value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  },
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    SizedBox(height: 5.0),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,
                      child: btnActive ? GestureDetector(
                        onTap: () async{
  
                              if(_formKey.currentState.validate()){
                                 setState(() {
                                btnActive=false;
                              });
                              bool success = await signIn(_email.text, _password.text);
                            if (success){
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('email', _email.text);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()),);
                              _formKey.currentState.reset();
                              print(prefs.getString('email'));
                              setState(() {
                                btnActive=true;
                              });
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
                              'LOGIN',
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
                    
                ],
              )),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'New to Data App ?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                },
                child: Text(
                    'Register',
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                ),
              )
            ],
          )
      ],
    ),
                  ),
        ));
  }
}
