
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class userManagement{
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore firestore = Firestore.instance;

  getCurrentUser() async{
    return await auth.currentUser();
  }

  checkIfLoggedIn()async{
    return await auth.currentUser()!=null;
  }

  logout() async{
    await FirebaseAuth.instance.signOut();
    return await auth.currentUser();
  }

  saveUserDetails(email,name) async{
    var data = {
      "name": name,
      "email": email,
    };
    return await firestore.collection("users").document(email).setData(data);
  }
  getUserDetails(email) async{
    return await firestore.collection("users").document(email).get();
  }
}
class dataManagemnt{
  Firestore firestore = Firestore.instance;

  punchInAttendance(time,user,lat,long) async{
    var data = {
      "punchinTime": time,
      "user": user,
      "lat": lat,
      "lng": long,
    };
    return await firestore.collection("attendance").document().setData(data);
  }

  punchOutAttendance(id,punchOutTime) async{
    return await firestore.collection("attendance").document(id).updateData({
      "punchoutTime": punchOutTime,
    });
  }
}