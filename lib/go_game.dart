import 'package:flutter/material.dart';

import 'board_widget.dart';
import 'model.dart';

class GoGame extends StatefulWidget {
  @override
  _GoGameState createState() => _GoGameState();
}

class _GoGameState extends State<GoGame> {

  Board board;
  Mode mode = Mode.ALTERNATE;

  StoneColor lastPlayed;

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
        ControlsWidget(mode: mode, modeChanged: (Mode newMode) {
          setState(() {
            this.mode = newMode;
          });
        },),
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
