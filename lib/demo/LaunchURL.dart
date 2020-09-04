import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {runApp(LaunchURLApp());}

class LaunchURLApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      title: 'file',
      theme: new ThemeData(primarySwatch: Colors.blueGrey),
      home: new DemoPage(),
    );
  }
}

class DemoPage extends StatelessWidget {
  void launchUrl() {
    launch('https://flutter.io');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('jump webPage'),

      ),
      body: new Center(
        child: new RaisedButton(
          onPressed: launchUrl,
          child: new Text('show flutter webPage'),
        ),
      ),
    );
  }

}