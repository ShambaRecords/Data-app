import 'package:dataapp/pages/Home.dart';
import 'package:dataapp/pages/Welcome.dart';
import 'package:dataapp/styles/colors.dart';
import 'package:dataapp/styles/text_styles.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          textTheme: TextTheme(
              title: AppbarStyle
          ),
          color: white,
        ),

          textTheme: TextTheme(
              title: TitleTextStyle,
              body1: Body1TextStyle
          ),
          primaryColor: white,
          accentColor: accentColor
      ),
      home: Welcome(),
      routes: <String, WidgetBuilder>{
        '/welcome': (BuildContext context) => new Welcome(),
        '/home': (BuildContext context) => new Home(),
      },
    );
  }
}
