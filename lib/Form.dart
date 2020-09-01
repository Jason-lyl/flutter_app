

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/NavigatorView.dart';

void main() => runApp(new FormApp());

class _MyFormState extends State {

  final myController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          return showDialog(
              context: context,
            builder: (context) {
                return AlertDialog(
                  content: Text(myController.text),
                );
            }
          );
        },
        tooltip: 'show me the value!',
        child: Icon(Icons.text_fields),
      ),
    );
  }
}


class FormApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FormAppPage(),
    );
  }
}

class FormAppPage extends StatefulWidget {
  FormAppPage({Key key}) : super(key: key);

  @override
  _FormAppPageState createState() => _FormAppPageState();

}

class _FormAppPageState extends State<FormAppPage> {
  String _errorText;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Form example'),
      ),
      body: Center(
        child: TextField(
          onSubmitted: (String text){
            setState(() {
              if (! isEmail(text)) {
                _errorText = 'Error: This is not an email';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: InputDecoration(hintText: 'This is a hint', errorText: _getErrorText()),
        ),
      ),
    );
  }

  _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);
    return regExp.hasMatch(em);
  }

}
