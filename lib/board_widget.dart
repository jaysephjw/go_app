import 'package:flutter/material.dart';

import 'model.dart';


class BoardWidget extends StatelessWidget {

  final Board board;
  final void Function(Point clicked) onTap;

  const BoardWidget({Key key, this.board, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final double inset = 20; // TODO: Calculate more elegantly (e.g. 1 cell-size)

    final double size = MediaQuery.of(context).size.shortestSide - 220;

    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        elevation: 10,
        child: CustomPaint(
          painter: _BackgroundPainter(),
          child: Padding(
            padding: EdgeInsets.all(inset),
            child: _InnerBoardWidget(board: board, onTap: onTap),
          ),
        ),
      ),
    );
  }
}


/// A widget that draws a go board :) Does not include any of the padding around the board.
///
/// Uses all available width; provide at least that much height.
class _InnerBoardWidget extends StatefulWidget {

  final Board board;
  final void Function(Point clicked) onTap;


  _InnerBoardWidget({key, @required this.board, this.onTap}) : super(key: key);

  @override
  _InnerBoardWidgetState createState() => _InnerBoardWidgetState();
}

class _InnerBoardWidgetState extends State<_InnerBoardWidget> {

  // State
  BuildContext _context;
  Offset _hover;

  @override
  Widget build(BuildContext context) {
    this._context = context;

    return Listener(
      onPointerHover: (event) {
        final localPosition = _localPosition(event.position);
        setState(() {
          _hover = localPosition;
        });
      },
      onPointerDown: (event) {
        setState(() {
          _hover = null;
        });
      },
      child: GestureDetector(
          child: CustomPaint(painter: _BoardPainter(widget.board, _hover)),
          onTapUp: _onTapUp,
      ),
    );
  }

  /// Called when the user has tapped somewhere on the board; triggers [widget.onTap].
  void _onTapUp(TapUpDetails details)
  {
    final localPosition = _localPosition(details.globalPosition);
    final nearest = pointForOffset(widget.board, _context.size, localPosition);

    if (widget.onTap != null) {
      widget.onTap(nearest);
    }
  }

  Offset _localPosition(Offset globalPosition) {
    final RenderBox renderBox = _context.findRenderObject() as RenderBox;
    return renderBox.globalToLocal(globalPosition);
  }
}

/// Paints the background of the board.
class _BackgroundPainter extends CustomPainter {

  static Paint boardPaint = Paint()..color = Color(0xFFDDB06C);

  @override
  void paint(Canvas canvas, Size size) =>
      canvas.drawRect(Rect.fromPoints(
          size.topLeft(Offset.zero),
          size.bottomRight(Offset.zero)),
          boardPaint);

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Paints the lines and stones of the board.  Does not paint the background.
class _BoardPainter extends CustomPainter {
  
  final Board board;
  final Offset hover; // Position of the cursor. May be null.

  static Paint linePaint = Paint()..color = Colors.black..strokeWidth = 1.1;
  static Paint blackStonePaint = Paint()..color = Colors.grey[900];
  static Paint whiteStonePaint = Paint()..color = Colors.grey[100];
  static Paint hoverPaint = Paint()..color = (Colors.grey[600].withOpacity(.5));

  _BoardPainter(this.board, this.hover);

  @override
  void paint(Canvas canvas, Size size) {

    assert(size.height >= size.width, '_BoardPainter needs at least its width in height.');

    final lines = board.size();
    final cellSize = size.width / (lines - 1); // Length between each line
    final stoneSize = cellSize / 2;

    // Draw the grid lines
    List.generate(lines, (i) => i).forEach((i) { // For each line...
      final offset = i * cellSize;
      final edge = cellSize * (board.size() - 1);
      canvas.drawLine(
          size.topLeft(Offset(offset, 0)),
          size.topLeft(Offset(offset, edge)),
          linePaint); // Draw column
      canvas.drawLine(
          size.topLeft(Offset(0, offset)),
          size.topLeft(Offset(edge, offset)),
          linePaint); // Draw row
    });

    // Draw the dots and stones :)
    board.points().forEach((p) {
      final Offset offset = Offset(p.x * cellSize, p.y * cellSize);
      if (p.color == null) {
        canvas.drawCircle(offset, 1, linePaint);
      } else {
        canvas.drawCircle(offset, stoneSize, _paintForStone(p.color));
      }
    });

    // Draw the hover cursor
    if (hover != null) {
      final nearest = pointForOffset(board, size, hover);
      final Offset offset = Offset(nearest.x * cellSize, nearest.y * cellSize);
      canvas.drawCircle(offset, stoneSize, hoverPaint);
    }
  }

  Paint _paintForStone(StoneColor color) {
    return color == StoneColor.White ? whiteStonePaint : blackStonePaint;
  }

//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) {
//    return (oldDelegate as _BoardPainter).board != board;
//  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

Point pointForOffset(Board board, Size boardSize, Offset localPosition) {
  final double cellSize = boardSize.width / (board.size() - 1);
  final int x = (localPosition.dx / cellSize).round();
  final int y = (localPosition.dy / cellSize).round();
  final Point nearest = board.pointAt(x,y);
  return nearest;
}