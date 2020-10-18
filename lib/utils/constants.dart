import 'package:flutter/material.dart';

var kTextFieldDecoration = InputDecoration(
  labelText: 'Title',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
  ),
);
var kInputFieldDecoration = InputDecoration(
    hintText: "",
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ));
var darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.deepOrange,
  accentColor: Colors.deepOrange,
  scaffoldBackgroundColor: Colors.grey.shade900,
  snackBarTheme: SnackBarThemeData(
    backgroundColor: Colors.grey.shade800,
    actionTextColor: Colors.deepOrange,
    contentTextStyle: TextStyle(color: Colors.white),
  ),
);

var lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: Colors.deepOrange.shade600,
    accentColor: Colors.deepOrange.shade600,
    snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.white,
        actionTextColor: Colors.deepOrange,
        contentTextStyle: TextStyle(color: Colors.black)),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.grey.shade300);
