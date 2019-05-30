// Desktop support
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show debugDefaultTargetPlatformOverride;

import 'package:flutter/material.dart';
import 'model.dart';
import 'board_widget.dart';


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
          child: GoGame(),
        ),
      ),
    );
  }
}

class GoGame extends StatefulWidget {
  @override
  _GoGameState createState() => _GoGameState();
}

class _GoGameState extends State<GoGame> {

  Board board;
  StoneColor currentTurn;

  @override
  void initState() {
    super.initState();
    board = GoBoard(9);
    currentTurn = StoneColor.Black;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: AspectRatio(
          aspectRatio: 1,
          child: BoardWidget(board: board, onTap: _onTap,)
      ),
    );
  }

  void _onTap(Point clicked) {
    debugPrint('Play at $clicked');
    bool success = board.play(clicked, currentTurn);
    if (success) {
      currentTurn = (currentTurn == StoneColor.Black) ? StoneColor.White : StoneColor.Black;
    }
  }

}


