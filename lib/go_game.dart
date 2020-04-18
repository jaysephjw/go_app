import 'package:flutter/material.dart';
import 'package:goban/goban.dart';
import 'package:goban/themes/gobanTheme.dart';

import 'controls.dart';

class GoGame extends StatefulWidget {

  final int boardSize;
  final GobanTheme gobanTheme;
  final bool showControls;
  final EdgeInsets padding;

  const GoGame({
    Key key,
    this.boardSize = 19,
    this.gobanTheme = GobanTheme.defaultTheme,
    this.showControls = true,
    this.padding = const EdgeInsets.all(20)
  }) : super(key: key);

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
    initController();
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  initController() {
    controller = GobanController(boardSize: widget.boardSize, theme: widget.gobanTheme);
    controller.clicks.listen(_onTapBoard);
    controller.hovers.listen(_onHover);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Container(
            padding: widget.padding,
              child: BoardWidget(controller: controller),
          ),
        ),
        if (widget.showControls)
        ControlsWidget(mode: mode, modeChanged: (ControlsMode newMode) {
          setState(() {
            this.mode = newMode;
          });
        },),
        if (widget.showControls)
        FlatButton(child: Text('Reset'), onPressed: () =>
          setState((){
            controller.dispose();
            initController();
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