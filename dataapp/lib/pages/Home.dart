import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dataapp/CRUD.dart';
import 'package:dataapp/styles/colors.dart';
import 'package:dataapp/styles/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'PunchIn.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var _dayN, _dayT, _today;
  DateTime now = new DateTime.now();
  Stream collectionStream;


  getPunchStream() {
    userManagement().getCurrentUser().then((user) {
      setState(() {
        collectionStream = Firestore.instance.collection('attendance')
            .orderBy("punchinTime", descending: true)
            .where("user",isEqualTo: user.email)
            .snapshots();
      });
    });
  }

  getDateNow() {
    DateTime date = new DateTime(now.year, now.month, now.day);
    var _timeStamp = DateTime
        .now()
        .millisecondsSinceEpoch;
    var today = DateTime.fromMillisecondsSinceEpoch(_timeStamp);
    var formatedDate = DateFormat.yMMMEd().format(today);
    setState(() {
      _today = "$formatedDate (Today)";
      _dayT = formatedDate.split(",")[0];
      _dayN = formatedDate.split(" ")[2].split(",")[0];
    });
  }


  @override
  void initState() {
    getDateNow();
    getPunchStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            userManagement().logout().then((user) {
              if (user == null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/welcome', (Route<dynamic> route) => false);
              }
            });
          },
        ),
        title: Text(
          "My attendance",
          style: TextStyle(
              color: black,
              fontWeight: FontWeight.bold,
              fontSize: 18
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PunchIn(true,null)));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PunchIn(true,null)));
                },
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(bigRadious)),
                  color: accentColor,
                  child: Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      children: [
                        Material(
                          borderRadius: BorderRadius.all(Radius.circular(
                              mediumRadious)),
                          color: black,
                          elevation: 10,
                          shadowColor: veryVeryLightGrey,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  "$_dayN",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: white
                                  ),
                                ),
                                Text(
                                  "${_dayT.toString().toUpperCase()}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: white
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _today != null ? "$_today" : "",
                                style: TextStyle(
                                  color: white,
                                  fontSize: 15,
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "Punch In",
                                style: TextStyle(
                                    color: white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _punches(),
          ],
        ),
      ),
    );
  }

  Widget _punches() {
    return StreamBuilder<QuerySnapshot>(
      stream: collectionStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("");
        }

        if(snapshot.hasData){
          return new ListView(
            shrinkWrap: true,
            primary: false,
            children: snapshot.data.documents.map((DocumentSnapshot document) {
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PunchIn(false,document)));
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Material(
                    borderRadius: BorderRadius.all(Radius.circular(bigRadious)),
                    color: veryVeryLightGrey,
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Row(
                        children: [
                          Material(
                            borderRadius: BorderRadius.all(
                                Radius.circular(mediumRadious)),
                            color: white,
                            elevation: 10,
                            shadowColor: veryVeryLightGrey,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Text(
                                    "${getDay(document["punchinTime"]).split(" ")[1]}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(
                                    "${getDay(document["punchinTime"]).split(" ")[0].toString().toUpperCase()}",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Punch In",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 15
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "${getTime(document["punchinTime"])}",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 15
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        "Punch Out",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: 15
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(
                                        "${document["punchoutTime"]!=null?getTime(document["punchoutTime"]):"--:--"}",
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: 15
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
        return SizedBox();
      },
    );
  }


  getTime(_timeStamp) {
    var _date = DateTime.fromMillisecondsSinceEpoch(_timeStamp);
    return "${_date.toString().split(" ")[1].split(".")[0].split(":")[0]}:${_date.toString().split(" ")[1].split(".")[0].split(":")[1]}";
  }
  getDay(_timeStamp) {
    var _date = DateTime.fromMillisecondsSinceEpoch(_timeStamp);
    var formatedDate = DateFormat.yMMMEd().format(_date);
    return "${formatedDate.split(",")[0]} ${formatedDate.split(" ")[2].split(",")[0]}";
  }
}
