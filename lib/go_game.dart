import 'package:flutter/material.dart';
import 'package:goban/goban.dart';
import 'package:goban/gobanController.dart';

import 'controls.dart';

class GoGame extends StatefulWidget {
  @override
  _GoGameState createState() => _GoGameState();
}

class _GoGameState extends State<GoGame> {

  GobanController controller;
  ControlsMode mode = ControlsMode.ALTERNATE;

  StoneColor lastPlayed;

  StoneColor get nextColor {
    switch (mode) {
      case ControlsMode.ALTERNATE:
        return lastPlayed == StoneColor.Black ? StoneColor.White : StoneColor.Black;
      case ControlsMode.WHITE:
        return StoneColor.White;
      case ControlsMode.BLACK:
        return StoneColor.Black;
      case ControlsMode.ERASE:
        return StoneColor.Empty;
    }
  }

  @override
  initState() {
    super.initState();
    controller = GobanController();

    controller.clicks.listen(_onTapBoard);
    controller.hovers.listen(_onHover);
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: EdgeInsets.all(20),
            child: Goban(
              controller: controller,
            ),
          ),
        ),
        ControlsWidget(mode: mode, modeChanged: (ControlsMode newMode) {
          setState(() {
            this.mode = newMode;
          });
        },),
        FlatButton(child: Text('Reset'), onPressed: () =>
          setState((){
            controller.dispose();
            controller = GobanController();
          }
        ),)
      ],
    );
  }

  void _onTapBoard(Move position) {
    print('_onTapBoard $position');
    setState(() {
      // TODO: Branch on mode!
      bool success = controller.model.play(position.copy(color: nextColor));
      if (success) lastPlayed = nextColor;
    });
  }

  void _onHover(Move position) {
    print('onHover $position');
    setState(() {
      controller.model.ghost = position;
    });
  }
}