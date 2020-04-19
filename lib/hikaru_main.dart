// Desktop support
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:goban/themes/gobanTheme.dart';
import 'go_game.dart';

void main() async {
  runApp(MyApp());
  WidgetsBinding.instance.addPostFrameCallback((_) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
    SystemChrome.setEnabledSystemUIOverlays([]);
  });
}

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
      home: HikaruPage(),
    );
  }
}

class HikaruPage extends StatefulWidget {
  @override
  _HikaruPageState createState() => _HikaruPageState();
}

class _HikaruPageState extends State<HikaruPage> {

  @override
  void initState() {
//    SystemChrome.setPreferredOrientations([
//      DeviceOrientation.landscapeRight,
//      DeviceOrientation.landscapeLeft
//    ]).then((value) => setState((){}));
  }

  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF9399CD), Color(0xFFBDBCD3),Color(0xFFCBC8E0),Color(0xFFBDBCD3)],
              stops: [.2,.40,.5,.6],
            )
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Container(
                child: Column(
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.only(top: 30.0)),
                    SvgPicture.asset('assets/black_bowl.svg', width: 150,),
                    SvgPicture.asset('assets/black_lid.svg', width: 130,),
                  ],
                ),
              ),
              Spacer(),
              GoGame(
                gobanTheme: _hikaruGobanTheme,
                showControls: false,
                padding: EdgeInsets.symmetric(vertical: height / 25),
              ),
              Spacer(),
              Container(
                child: Column(
                  verticalDirection: VerticalDirection.up,
                  children: <Widget>[
                    Padding(padding: const EdgeInsets.only(top: 30.0)),
                    SvgPicture.asset('assets/white_lid.svg', width: 130,),
                    SvgPicture.asset('assets/white_bowl.svg', width: 150,),
                  ],
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

final _hikaruGobanTheme = GobanTheme(
    lineWidth: 0.7,
    boardGradient: const LinearGradient(
        colors: [Color(0xFFD2BC87), Color(0xFFC3AF8E), Color(0xFFC3AF8E), Color(0xFFEDDCA2)],
        stops: [.2, .33, .44, .75]
    ),
    boardShadow: BoxShadow(
      color: Color(0x57000000),
      blurRadius: 4,
      spreadRadius: -2,
      offset: const Offset(-10, 1)),
    whiteStones: StoneTheme(
        stoneColor: Color(0xFFDFE6F2),
        // TODO: Border thickness is too high.
        // TODO: Stone shadows
    )
);