import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyEvents extends StatefulWidget {
  @override
  _MyEventsState createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  String _userEmail;
  @override
  void initState() {
    super.initState();
    getEmail();
  }
  getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userEmail = prefs.getString('email');
    print(_userEmail);
  }
  @override
  Widget build(BuildContext context) {
    String loggedUser = FirebaseAuth.instance.currentUser.uid; 
    return Scaffold(
      appBar: AppBar(leading: Container(), title:Title(color: Colors.white, child: Text("My events")),backgroundColor: Colors.green,
       actions: [FlatButton.icon(label: Text("Logout",style: TextStyle(
         color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
       ),), icon: Icon(Icons.logout,color: Colors.white,), onPressed: () async{
        SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.remove('email');
          Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
      }), ],
      
      ),
      body: StreamBuilder(
        stream:FirebaseFirestore.instance.collection('events').where('attendees',arrayContains:loggedUser ).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator(backgroundColor: Colors.green,));
          }
          else{
           final List<DocumentSnapshot> documents = snapshot.data.docs;
           print(documents);
            return ListView(
                children: documents
                    .map((doc) =>CardEvent(name: doc['name'],date: doc['date'],location: doc['location'],) )
                    .toList());

          }
        },
      ),
      
    );
  }
}

class CardEvent extends StatelessWidget {
 final String name;
 
  final String date;
  final String location;

  CardEvent({this.name,this.date,this.location});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height*0.4,
      child: Card(
        margin: EdgeInsets.all(15.0),
        
        child: Container(
          child: Column(
            children: [
              Container(
                 height: MediaQuery.of(context).size.height*0.2,
                decoration: BoxDecoration(
                  
                  color: Colors.green
                ),
                child: Center(child: Text("Training event",style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                         ),),),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Container(
                    margin: EdgeInsets.only(left:10,right: 10.0),
                    child: Column(children: [
                      SizedBox(height: 10.0,),
                      Row(children: [
                        Icon(Icons.assessment),
                        Text(name,style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                           ),),
                      ],),
                      SizedBox(height: 5.0,),
                      Row(children: [
                        Icon(Icons.location_on),
                        Text(location,style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                           ),),
                      ],),
                      SizedBox(height: 5.0,),
                      Row(children: [
                        Icon(Icons.calendar_today,),
                        Text(date,style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                           ),),
                      ],),
                      SizedBox(height: 5.0,),
                    ],),
                  ),
                  Row(
                    children: [
                      Icon(Icons.offline_pin, color: Colors.green,),
                      Text("Confirmed",style: TextStyle(
                            color: Colors.green,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                           ),),
                    ],
                  )
                  
                  
                ],)
            ],
          ),
          ),
        
      ),
    );
  }
}