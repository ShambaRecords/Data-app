import 'package:data/controllers/userController.dart';
import 'package:data/views/addUser.dart';
import 'package:data/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
 void initState(){
  super.initState();
  _determinePosition();
}

 String loggedUser = FirebaseAuth.instance.currentUser.uid; 
 String _location;
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
    
 
    return Scaffold(
      appBar: AppBar(leading: Container(), title:Title(color: Colors.white, child: Text("Upcoming Events")),backgroundColor: Colors.green,
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
        stream:FirebaseFirestore.instance.collection('events').where('attendees',whereNotIn:[loggedUser]).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(child:CircularProgressIndicator(backgroundColor: Colors.green,));
          }else{
           final List<DocumentSnapshot> documents = snapshot.data.docs;
           
            return ListView(
                children: documents
                    .map((doc) {
                      //print(doc.data());
                      return CardEvents(name: doc['name'],date: doc['date'], documentId: doc['name'],uid: loggedUser,location: doc['location'],userLocation: _location);
                    } )
                    .toList());

          }
        },
      ),
      
    );
  }
}

class CardEvents extends StatelessWidget {
 final String name;
  final String documentId;
  final String date;
  final String uid;
  final String location;
  final String userLocation;
  

  CardEvents({this.name,this.documentId,this.date,this.uid,this.location,this.userLocation});
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                      
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
                 
                  ElevatedButton(onPressed: () async{
                    attend(uid,documentId);
                await locateUser(name, uid, userLocation);
                  },child: Text('Attend'),
                  style:ButtonStyle(
                   
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18.0),
      side: BorderSide(color: Colors.green)
    )
  )
),
                  ),
                  
                  
                ],)
            ],
          ),
          ),
        
      ),
    );
  }
}