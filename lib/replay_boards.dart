import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'board_widget.dart';
import 'model.dart';
import 'ogs.dart' as ogs;

class ReplayScreen extends StatefulWidget {
  @override
  _ReplayScreenState createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {

  TextEditingController _textController;
  int _gameId;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController()
      ..value = TextEditingValue(text: '1000')
      ..addListener(() {
      });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        ReplayWidget(gameId: (_gameId + 0).toString(),),
        ReplayWidget(gameId: (_gameId + 1).toString(),),
        ReplayWidget(gameId: (_gameId + 2).toString(),),
        ReplayWidget(gameId: (_gameId + 3).toString(),),

        Padding(padding: EdgeInsets.only(top: 20),),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 180,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _textController,
                autofocus: false,
              ),
            ),
            IconButton(
              icon: CircleAvatar(child: Text('>')),
              onPressed: () {
              setState(() {
                _gameId = int.parse(_textController.text)
              });
              }),
          ],
        ),
      ],
    );
  }
}

class ReplayWidget extends StatefulWidget {

  final String gameId;

  const ReplayWidget({Key key, @required this.gameId}) : super(key: key);

  @override
  _ReplayWidgetState createState() => _ReplayWidgetState();
}

class _ReplayWidgetState extends State<ReplayWidget> {

  GoBoard board;

  @override
  void initState() {
    super.initState();
    board = GoBoard(19); // Default size
    start();
  }

  void start() async {
    final ogs.GameRecord resp = await ogs.getGame(widget.gameId);

    setState(() {
      setState(() {
        board = GoBoard(resp.width);
      });
    });

    Queue<Point> moves = Queue()..addAll(resp.moves);
    bool isBlack = true;
    Timer.periodic(Duration(milliseconds: 75), (Timer timer) {
      if (moves.isEmpty) {
        timer.cancel();
        return;
      }

      // Play the move
      setState(() {
        board.play(moves.removeFirst(), isBlack ? StoneColor.Black : StoneColor.White);
        isBlack = !isBlack;
      });
    });
  }

  @override
  void didUpdateWidget(ReplayWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.gameId != widget.gameId) {
      start();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 300,
      child: BoardWidget(board: board)
    );
  }
}