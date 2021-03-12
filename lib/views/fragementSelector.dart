import 'package:data/views/home.dart';
import 'package:data/views/myEvents.dart';
import 'package:flutter/material.dart';

class Selector extends StatefulWidget {
  @override
  _SelectorState createState() => _SelectorState();
}

class _SelectorState extends State<Selector> {


  int _currentIndex = 0;
  void onTabTapped(int index) {
   setState(() {
     _currentIndex = index;
   });
 }
  final List<Widget> _children = [
    HomePage(),
    MyEvents()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: _children[_currentIndex],
      bottomNavigationBar:  BottomNavigationBar(
        selectedItemColor: Colors.green,
       onTap: onTabTapped, // new
       currentIndex: _currentIndex, // new
       items: [
         new BottomNavigationBarItem(
           icon: Icon(Icons.home,),
           title: Text('Home'),
         ),
         new BottomNavigationBarItem(
           icon: Icon(Icons.assignment),
           title: Text('My Events'),
         ),
        
       ],
     ),
      
    );
  }
}