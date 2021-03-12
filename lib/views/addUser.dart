
import 'package:data/controllers/userController.dart';
import 'package:data/views/home.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';



class AddUser extends StatefulWidget {
  @override
  _AddUserState createState() => new _AddUserState();
}

class _AddUserState extends State<AddUser> {
@override
 void initState(){
  super.initState();
  _determinePosition();
}

  TextEditingController _email = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _date = TextEditingController();
  String _location;
   final _formKey = GlobalKey<FormState>();
   bool btnActive = true;


 _determinePosition() async {
   bool isLocationServiceEnabled  = await Geolocator.isLocationServiceEnabled();
   if(isLocationServiceEnabled){
  Position position = await Geolocator.getCurrentPosition();
  _location =position==null ? "Uknown" : position.toString();
  
  }
  else{
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission==LocationPermission.denied || permission ==LocationPermission.deniedForever){
    
      _location="Unkown";
    }else{
     Position position = await Geolocator.getCurrentPosition();
     _location =position==null ? "Uknown" : position.toString();
  
     }
    }
  }


  @override
  Widget build(BuildContext context) {
    
    return new Scaffold(
       appBar: AppBar( title:Title(color: Colors.white, child: Text("Add user")),backgroundColor: Colors.green,),
        body: SingleChildScrollView(
                  child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                  child: Text('Add User',
                      style:
                          TextStyle(fontSize: 50.0, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
              child: Form(
                key: _formKey,
                              child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _name,
                       validator: (value) {
    if (value.isEmpty) {
      return 'Full name cannot be blank.';
    }
    return null;
  },
                      decoration: InputDecoration(
                          labelText: 'Full name',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _email,
                       validator: (value) {
    if (value.isEmpty) {
      return 'Email cannot be empty';
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
                      controller: _phone,
                       validator: (value) {
    if (value.isEmpty ) {
      return 'Phone cannot be empty';
    }
    return null;
  },
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: false,
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
       controller: _date,
        validator: (value) {
    if (value.isEmpty) {
      return 'Date cannot be empty';
    }
    return null;
  },
       decoration: InputDecoration(
       labelText: "Date of Training",
       hintText: "Select date",
       hintStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
       labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),),
       
       onTap: () async {
      DateTime date = DateTime(1900);
      FocusScope.of(context).requestFocus(new FocusNode());

date = await showDatePicker(
                context: context, 
                initialDate:DateTime.now(),
                firstDate:DateTime(1900),
                lastDate: DateTime(2100));

_date.text = date.toString();},),
  
                    SizedBox(height: 20.0),
                    


                    SizedBox(height: 5.0),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,
                      child: btnActive ? GestureDetector(
                        onTap: () async{
                              if(_formKey.currentState.validate()){
                                setState(() {
                                  btnActive = false;
                                });

                               bool success = false;//await createUser(_name.text, _email.text, _phone.text, _date.text, _location, null);
                               if(success){
                                 Navigator.pop(context);
                                 _formKey.currentState.reset();  
                                 
                               }else{
                                 setState(() {
                                  btnActive = false;
                                });
                                 print("Not created");
                               }
                              }
                            },
                                              child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          shadowColor: Colors.greenAccent,
                          color: Colors.green,
                          elevation: 7.0,
                          child: Center(
                            child: Text(
                              'Add user',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ): Center(child:CircularProgressIndicator(backgroundColor: Colors.green,)),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              )),
       
         
      ],
    ),
        ));
  }
}
