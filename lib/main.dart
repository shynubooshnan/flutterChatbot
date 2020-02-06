import 'package:flutter/material.dart';
import 'package:item_look_up/ChatAssistHomePage.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Chat Assistant',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: new ChatAssistHomePage(),
    );
  }
}



