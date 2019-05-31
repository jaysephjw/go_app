import 'package:flutter/material.dart';

import 'board_widget.dart';
import 'model.dart';

class GoGame extends StatefulWidget {
  @override
  _GoGameState createState() => _GoGameState();
}

class _GoGameState extends State<GoGame> {

  Board board;
  _Mode mode = _Mode.ALTERNATE;

  StoneColor lastPlayed;

  StoneColor get nextColor {
    switch (mode) {
      case _Mode.ALTERNATE:
        return lastPlayed == StoneColor.Black ? StoneColor.White : StoneColor.Black;
      case _Mode.WHITE:
        return StoneColor.White;
      case _Mode.BLACK:
        return StoneColor.Black;
      case _Mode.ERASE:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    board = GoBoard(9);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(20),
          child: AspectRatio(
              aspectRatio: 1,
              child: BoardWidget(board: board, onTap: _onTap,)
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(icon: CircleAvatar(child: Text('A'),
                backgroundColor: mode == _Mode.ALTERNATE ? Colors.blue[700] : Colors.blue),
              onPressed: () => setState(() => mode = _Mode.ALTERNATE),),
            IconButton(icon: CircleAvatar(child: Text('B'),
                backgroundColor: mode == _Mode.BLACK ? Colors.blue[700] : Colors.blue),
              onPressed: () => setState(() => mode = _Mode.BLACK),),
            IconButton(icon: CircleAvatar(child: Text('W'),
                backgroundColor: mode == _Mode.WHITE ? Colors.blue[700] : Colors.blue),
              onPressed: () => setState(() => mode = _Mode.WHITE),),
            IconButton(icon: CircleAvatar(child: Text('E'),
                backgroundColor: mode == _Mode.ERASE ? Colors.blue[700] : Colors.blue),
              onPressed: () => setState(() => mode = _Mode.ERASE),),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: 20),),
        FlatButton(child: Text('Reset'), onPressed: () => setState(()=> board = GoBoard(9)),)
      ],
    );
  }

  void _onTap(Point clicked) {
    bool success = board.play(clicked, nextColor);
    if (success) {
      lastPlayed = nextColor;
      setState(() {}); // Update state
    }
  }
}

enum _Mode { BLACK, WHITE, ALTERNATE, ERASE }