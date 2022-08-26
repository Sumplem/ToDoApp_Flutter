
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todoapp/reponsive/login.dart';
import 'package:todoapp/reponsive/register.dart';
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyLogin(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
    },
  ));
}