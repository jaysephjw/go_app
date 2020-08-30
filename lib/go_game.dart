import 'package:flutter/material.dart';
import 'package:goban/goban.dart';
import 'package:goban/themes/gobanTheme.dart';

import 'controls.dart';

/// A Goban that knows the rules of go.
class GoGame extends StatefulWidget {

  final BoardController controller;

  const GoGame({
    Key key,
    this.controller,
  }) : super(key: key);

  @override
  _GoGameState createState() => _GoGameState();
}

class _GoGameState extends State<GoGame> {

  @override
  initState() {
    super.initState();
    initController();
  }

  @override
  dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  initController() {
    widget.controller.clicks.listen(_onTapBoard);
    widget.controller.hovers.listen(_onHover);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(child: GobanWidget(controller: widget.controller)),
      ],
    );
  }

  bool play(Move move) {
    bool success = widget.controller.model.play(move);
    return success;
  }

  void _onTapBoard(Move position) {
    print('_onTapBoard $position');
    setState(() {
      final move = position.copy(color: widget.controller.model.nextColor);
      bool success = play(move);
    });
  }

  void _onHover(Move position) {
    setState(() {});
  }
}