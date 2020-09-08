
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  final String errorMessage;
  final FlutterErrorDetails details;

  ErrorPage(this.errorMessage, this.details);

  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class ErrorPageState extends State<ErrorPage> {

  static List<Map<String, dynamic>> sErrorStack = new List<Map<String, dynamic>>();

  static List<String> sErrorName = new List<String>();

  final TextEditingController textEditingController = new TextEditingController();


  // addError(FlutterErrorDetails details) {
  //   try {
  //     var map = Map<String, dynamic>();
  //     map["error"] = details.toString();


  //   }
  // }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
  }
}