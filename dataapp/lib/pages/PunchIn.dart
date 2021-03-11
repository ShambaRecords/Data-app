import 'dart:io';

import 'package:dataapp/styles/colors.dart';
import 'package:dataapp/styles/constants.dart';
import 'package:dataapp/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../CRUD.dart';

class PunchIn extends StatefulWidget {
  var _isNew,_data;
  PunchIn(this._isNew,this._data);
  @override
  _PunchInState createState() => _PunchInState(_isNew,_data);
}

class _PunchInState extends State<PunchIn> {
  var _isNew,_data;
  _PunchInState(this._isNew,this._data);
  var _lctn,_location;
  var _isLoading = false;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        return Future.error(
            'Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    getCurrLocation();
    super.initState();
  }

  getCurrLocation() async {
    _determinePosition().then((location){
      setState(() {
        _location = location;
        _lctn = "${location.latitude} - ${location.longitude}";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: accentColor,
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.all(30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    color: white
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          SafeArea(
            child: Container(
              margin: EdgeInsets.only(top: 100,left: 30,right: 30),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: (){
                      _determinePosition();
                    },
                    child: Text(
                      "Find Me",
                      style: TextStyle(
                          color: white.withOpacity(0.5),
                          fontWeight: FontWeight.w900,
                          fontSize: 45
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    _lctn!=null?"Location found : $_lctn":"",
                    style: TextStyle(
                      color: white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 440,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(bigRadious), topRight: Radius.circular(bigRadious),)
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline,color: accentColor,),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Location",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                              SizedBox(height: 8,),
                              Text(
                                "The app will automatically attempt to locate you, if it fails ensure you have your GPS enabled and tap Find Me above.",
                                style: TextStyle(
                                    color: Colors.grey[500]
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 40,),
                    _isNew?SizedBox():Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Punch In",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "${getTime(_data["punchinTime"])}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: green
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Punch Out",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15
                                ),
                              ),
                              SizedBox(height: 10,),
                              Text(
                                "${_data["punchoutTime"]!=null?getTime(_data["punchoutTime"]):"--:--"}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.red
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40,),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: _isNew?green:_data["punchinTime"]!=null&&_data["punchoutTime"]==null?accentColor:white,
                        borderRadius: BorderRadius.all(Radius.circular(smallRadious))
                      ),
                      child: _isNew?Row(
                        children: [
                          SizedBox(
                            height: 50.0,
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(smallRadious),
                                    // side: BorderSide(color: Colors.blueGrey)
                                ),
                                onPressed: _location==null||_isLoading?null:(){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if(_location!=null){
                                    savePunchIn();
                                  }else{
                                    _determinePosition().then((location){
                                      setState(() {
                                        _location = location;
                                      });
                                      savePunchIn();
                                    });
                                  }
                                },
                                disabledColor: veryLightGrey,
                                color: white,
                                textColor: Colors.blueGrey,
                                child: Center(
                                  child: Text("Punch in", style: TextStyle(
                                      fontFamily: fontName,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.center,),
                                )
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: _isLoading?Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Platform.isIOS?CupertinoActivityIndicator(animating: true,):CircularProgressIndicator(strokeWidth: 4,backgroundColor: white,),
                              ),
                            ):Text(
                              "Tap Button to Punch In",
                              style: TextStyle(
                                color: white.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 15
                              ),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      ):
                      _data["punchinTime"]!=null&&_data["punchoutTime"]==null?Row(
                        children: [
                          Expanded(
                            child: _isLoading?Center(
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Platform.isIOS?CupertinoActivityIndicator(animating: true,):CircularProgressIndicator(strokeWidth: 4,backgroundColor: white,),
                              ),
                            ):Text(
                              "Tap Button to Punch Out",
                              style: TextStyle(
                                  color: white.withOpacity(0.8),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 10,),
                          SizedBox(
                            height: 50.0,
                            child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(smallRadious),
                                  // side: BorderSide(color: Colors.blueGrey)
                                ),
                                onPressed: _location==null||_isLoading?null:(){
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  if(_location!=null){
                                    savePunchOut(_data.documentID);
                                  }else{
                                    _determinePosition().then((location){
                                      setState(() {
                                        _location = location;
                                      });
                                      savePunchOut(_data.documentID);
                                    });
                                  }
                                },
                                disabledColor: veryLightGrey,
                                color: white,
                                textColor: Colors.blueGrey,
                                child: Center(
                                  child: Text("Punch out", style: TextStyle(
                                      fontFamily: fontName,
                                      fontWeight: FontWeight.bold
                                  ),textAlign: TextAlign.center,),
                                )
                            ),
                          ),
                        ],
                      ):
                      SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  savePunchIn(){
    var _timeStamp = DateTime.now().millisecondsSinceEpoch;
    userManagement().getCurrentUser().then((user){
      dataManagemnt().punchInAttendance(_timeStamp, user.email, _location.latitude,_location.longitude).then((data){
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    });
  }
  savePunchOut(id){
    var _timeStamp = DateTime.now().millisecondsSinceEpoch;
    dataManagemnt().punchOutAttendance(id,_timeStamp).then((doc){
      print(doc);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    });
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
