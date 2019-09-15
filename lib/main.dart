// Desktop support
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;

import 'package:flutter/material.dart';
import 'package:go_app/replay_boards.dart';
import 'go_game.dart';
import 'model.dart';

import 'ogs.dart' as ogs;

void main() {
  // Use fuchsia as any desktop platform.
  // See https://github.com/flutter/flutter/wiki/Desktop-shells#target-platform-override
  if (!Platform.isIOS || !Platform.isAndroid) {
    debugDefaultTargetPlatformOverride = TargetPlatform.fuchsia;
  }

  getGame();

  runApp(MyApp());
}

void getGame() async {
  await ogs.init();
  final resp = await ogs.getGame('');
  debugPrint('got responsez: ${resp.moves.length}');
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Board board = GoBoard(9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        child: Center(
//          child: GoGame(),
        child: ReplayScreen(),
        ),
      ),
    );
  }
}


