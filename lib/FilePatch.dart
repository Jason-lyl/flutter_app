
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(
    new MaterialApp(
      theme: new ThemeData(primarySwatch: Colors.yellow),
      home: new FilePathApp(),
    )
  );
}

class FilePathApp extends StatefulWidget {
  FilePathApp({Key key}) : super(key: key);
  @override
  _FilePathState createState() => new _FilePathState();
}

class _FilePathState extends State<FilePathApp> {

  int _counter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });

  }

  Future<File> _getLocalFile() async {
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/counter.txt');
  }

  Future<int> _readCounter() async {
    try {
      File file = await _getLocalFile();
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  Future<Null> _inCrementCounter() async {
    setState(() {
      _counter ++;
    });
    await (await _getLocalFile()).writeAsStringSync('$_counter');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(title: new Text('File Path readWrite')),

      body: new Center(
        child: new Text('Button tapped $_counter time${
        _counter == 1 ? '': 's'
        }.'),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _inCrementCounter,
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}