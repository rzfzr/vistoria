import 'package:flutter/material.dart';
import 'RouteGenerator.dart';
import 'home.dart';
import 'login.dart';



void main() {

    runApp(MaterialApp(
      home: Login(),
      theme: ThemeData(
        primaryColor: Color(0xff43439A),
        accentColor:  Color(0xff5862CE),
      ),
      initialRoute: "/",
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    ));

}