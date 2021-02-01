// import 'package:SimplyNatureUI/sidebar/menu_dashboard_layout.dart';
import 'package:SimplyNatureUI/sidebar/sidebar_layout.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simply Nature',
      theme: ThemeData(
          scaffoldBackgroundColor: Color.fromRGBO(30, 30, 35, 1),
          primaryColor: Color(0Xff52057b)),
      home: SideBarLayout(),
    );
  }
}
