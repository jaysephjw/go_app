import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:goban/goban.dart';

import 'ogs.dart' as ogs;

/// A screen for replaying games from OGS.
class ReplayScreen extends StatefulWidget {
  @override
  _ReplayScreenState createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {

  TextEditingController _textController;
  int _gameId = 124567;

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
        ReplayBoard(gameId: (_gameId + 0).toString(),),
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
                    _gameId = int.parse(_textController.text);
                  });
                }),
          ],
        ),
      ],
    );
  }
}

/// A goban that replays an OGS game.
class ReplayBoard extends StatefulWidget {

  final String gameId;

  const ReplayBoard({Key key, @required this.gameId}) : super(key: key);

  @override
  _ReplayBoardState createState() => _ReplayBoardState();
}

class _ReplayBoardState extends State<ReplayBoard> {

  GobanController board;

  @override
  void initState() {
    super.initState();
    board = GobanController(boardSize: 19); // Default size
    start();
  }

  void start() async {
    final ogs.GameRecord resp = await ogs.getGame(widget.gameId);

    setState(() {
      setState(() {
        board = GobanController(boardSize: resp.width);
      });
    });

    Queue<Move> moves = Queue()..addAll(resp.moves);

    StoneColor nextColor = StoneColor.Black;

    Timer.periodic(Duration(milliseconds: 75), (Timer timer) {
      if (moves.isEmpty) {
        timer.cancel();
        return;
      }
      // Play the move
      setState(() {
        final move = moves.removeFirst();
        board.model.play(move.copy(color: nextColor));
        nextColor = nextColor.flipped();
      });
    });
  }

  @override
  void didUpdateWidget(ReplayBoard oldWidget) {
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
        child: Goban(
          controller: board,
        )
    );
  }
}