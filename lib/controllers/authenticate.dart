import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';


Future<bool> signIn(String email, String password)async{
try{
await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
return true;
}catch(e){
  Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  return false;
}

}
Future<bool> register(String email, String password)async{
  
   try{
     await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      return true;

   } on FirebaseAuthException catch(e){
     Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
   }
   catch(e){
     Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
     
     return false; 
   }
   return false;
}