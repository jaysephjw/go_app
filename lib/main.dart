// Desktop support
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;

import 'package:flutter/material.dart';
import 'chess_game.dart';


void main() {
  // Use fuchsia as any desktop platform.
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  if (!Platform.isIOS || !Platform.isAndroid) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chess For James',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Center(
          child: ChessGame(),
        ),
      ),
    );
  }
}


