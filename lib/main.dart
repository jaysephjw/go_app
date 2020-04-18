// Desktop support
import 'package:flutter/material.dart';
import 'package:goban/themes/gobanTheme.dart';
import 'go_game.dart';

void main() {

//  getGame();

  runApp(MyApp());
}
//
//void getGame() async {
//  await ogs.init();
//  final resp = await ogs.getGame('');
//  debugPrint('got responsez: ${resp.moves.length}');
//}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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



class HikaruPage extends StatefulWidget {
  @override
  _HikaruPageState createState() => _HikaruPageState();
}

class _HikaruPageState extends State<MyHomePage> {

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
