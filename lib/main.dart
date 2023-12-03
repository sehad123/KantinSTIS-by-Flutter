import 'package:flutter/material.dart';
import 'package:kantin_stis/Screens/Login/LoginScreens.dart';
import 'package:kantin_stis/routes.dart';
import 'package:kantin_stis/theme.dart';

void main() async {
  runApp(MaterialApp(
    title: "Kantin STIS",
    theme: theme(),
    initialRoute: LoginScreen.routeName,
    routes: routes,
  ));
}
