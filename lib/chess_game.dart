import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'chess_board.dart';
import 'model.dart';

class ChessGame extends StatefulWidget {
  @override
  _ChessGameState createState() => _ChessGameState();
}

class _ChessGameState extends State<ChessGame> {

  FocusNode _node = FocusNode();
  Square highlighted;
  bool printAsBlack = false;

  Queue<Square> _queue = Queue();

  TextEditingController _controller;

  Square get _nextSquare {
    if (_queue.isEmpty) {
      // Generate squares from 3 chess boards, shuffle, add to queue
      final oneBoard = List.generate(64, (i) {
        return Square((i / 8).floor(), i % 8); // x y
      });
      final List<Square> items = []
        ..addAll(oneBoard)..addAll(oneBoard)..addAll(oneBoard)..shuffle();
      _queue.addAll(items);
    }
    return _queue.removeFirst()
      ..reveal = false
      ..printAsBlack = printAsBlack;
  }

  @override
  void initState() {
    super.initState();

    Timer(Duration(milliseconds: 200), () {
      _node.requestFocus();
    });

    _controller = TextEditingController();
    _controller.addListener(_next);
  }

  void _next() {
    setState(() {
      if (highlighted != null && !highlighted.reveal) {
        highlighted.reveal = true;
      } else {
        highlighted = _nextSquare;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final Size size = MediaQuery.of(context).size;

    final double boardSize = size.shortestSide - 89;

    return GestureDetector(
      onTap: _next,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(20),
            child: SizedBox(
                width: boardSize,
                height: boardSize,
                child: BoardWidget(highlighted: highlighted)
            ),
          ),
	  FlatButton(child: _getButtonLabel(), onPressed: _press),

        // Invisible tiny text input as a hACKy way to listen to the keyboard
          SizedBox(
            width: 1,
            height: 1,
            child: Opacity(
              opacity: 0,
              child: TextField(
                autofocus: true,
                controller: _controller,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _getButtonLabel() {
    final ts = TextSpan(
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: printAsBlack ? 'black ' : 'white ',
            style: TextStyle(color: printAsBlack ? Colors.black : Colors.white, fontWeight: FontWeight.bold)
          ),
          TextSpan(text: 'coordinates. ( -> FLIP TABLE )'),
    ]);
    return RichText(text: ts);
  }

	_press() {
		setState(() {
      printAsBlack = !printAsBlack;
      highlighted?.printAsBlack = printAsBlack;
		});
	}
}