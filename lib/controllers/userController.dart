


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

Future<bool> locateUser(String name, String userId,String location) async {
  try{
    CollectionReference trainees = FirebaseFirestore.instance.collection('user Location');
  await trainees.add({
      'Event name':name,
      'User ID':userId,
      'location':location,
      
    }).then((value) => {
      print("Location added")
    });
    return true;
  }catch(e){
  print(e.toString());
    return false;
  }
}

Future<bool> attend(String userId, String documentId) async{
  
 CollectionReference _attendance = FirebaseFirestore.instance.collection('events');
 
 
    _attendance.doc('Farmers Empowerment')
    .update({'attendees': FieldValue.arrayUnion([userId])})
    .then((value) => Fluttertoast.showToast(
        msg: "Attedance confirmed successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0
    )
    )
    .catchError((error) => Fluttertoast.showToast(
        msg: "Attedance Booking Failed",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0
    )
    );
    
 

}