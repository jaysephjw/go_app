import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'board_widget.dart';
import 'model.dart';
import 'ogs.dart' as ogs;

class GoGame extends StatefulWidget {
  @override
  _GoGameState createState() => _GoGameState();
}

class _GoGameState extends State<GoGame> {

  Board board;
  Mode mode = Mode.ALTERNATE;

  StoneColor lastPlayed;

  TextEditingController _textController;
  String _gameId;

  StoneColor get nextColor {
    switch (mode) {
      case Mode.ALTERNATE:
        return lastPlayed == StoneColor.Black ? StoneColor.White : StoneColor.Black;
      case Mode.WHITE:
        return StoneColor.White;
      case Mode.BLACK:
        return StoneColor.Black;
      case Mode.ERASE:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    board = GoBoard(9);

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
        Container(
          padding: EdgeInsets.all(20),
          child: BoardWidget(board: board, onTap: _onTapBoard,),
        ),
        ReplayWidget(gameId: _gameId,),
        ControlsWidget(mode: mode, modeChanged: (Mode newMode) {
          setState(() {
            this.mode = newMode;
          });
        },),

        Padding(padding: EdgeInsets.only(top: 20),),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(
              width: 180,
              child: TextField(
                controller: _textController,
                autofocus: false,
              ),
            ),
            IconButton(icon: CircleAvatar(child: Text('>'),
                backgroundColor: mode == Mode.ERASE ? Colors.blue[700] : Colors.blue),
              onPressed: () {
              setState(() {
                _gameId = _textController.text;
              });
              }),
          ],
        ),
        FlatButton(child: Text('Reset'), onPressed: () => setState(()=> board = GoBoard(9)),)
      ],
    );
  }

  void _onTapBoard(Point clicked) {
    bool success = board.play(clicked, nextColor);
    if (success) {
      lastPlayed = nextColor;
      setState(() {}); // Update state
    }
  }
}

enum Mode { BLACK, WHITE, ALTERNATE, ERASE }


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
    return BoardWidget(board: board);
  }
}


class ControlsWidget extends StatelessWidget {

  final Mode mode;
  final Function(Mode mode) modeChanged;

  const ControlsWidget({Key key, @required this.mode, this.modeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return        Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(icon: CircleAvatar(child: Text('A'),
            backgroundColor: mode == Mode.ALTERNATE ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(Mode.ALTERNATE),),
        IconButton(icon: CircleAvatar(child: Text('B'),
            backgroundColor: mode == Mode.BLACK ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(Mode.BLACK),),
        IconButton(icon: CircleAvatar(child: Text('W'),
            backgroundColor: mode == Mode.WHITE ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(Mode.WHITE),),
        IconButton(icon: CircleAvatar(child: Text('E'),
            backgroundColor: mode == Mode.ERASE ? Colors.blue[700] : Colors.blue),
          onPressed: () => modeChanged(Mode.ERASE),),
      ],
    );
  }
}
