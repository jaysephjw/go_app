import 'package:flutter/material.dart';

import 'model.dart';



class BoardWidget extends StatelessWidget {

  final Key keyForChild;
  final Square highlighted;

  const BoardWidget({this.keyForChild, this.highlighted});

  @override
  Widget build(BuildContext context) {

    final double inset = 20; // TODO: Calculate more elegeantly (e.g. 1 cell-size)

    return Material(
      elevation: 10,
      child: CustomPaint(
        painter: _BackgroundPainter(),
        child: Padding(
          padding: EdgeInsets.all(inset),
          child: InnerBoardWidget(key: keyForChild, highlighted: highlighted,),
        ),
      ),
    );
  }
}


/// A widget that draws a go board :) Does not include any of the padding around the board.
///
/// Uses all available width; provide at least that much height.
class InnerBoardWidget extends StatelessWidget {

  final Square highlighted;

  const InnerBoardWidget({key, this.highlighted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(size: Size.infinite, painter: _BoardPainter(highlighted));
  }
}

/// Paints the background of the board.
class _BackgroundPainter extends CustomPainter {

  static Paint boardPaint = Paint()..color = Color(0xFF404040);

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
  
  final Square highlighted;

  static Paint blackOutline = Paint()..color = Colors.black..strokeWidth = 1..style = PaintingStyle.stroke;
  static Paint light = Paint()..color = Color(0xFFD0D0E0);
  static Paint dark = Paint()..color = Color(0xFF7080A0);
  static Paint highlightPaint = Paint()
                                  ..color = (Colors.green[300])
                                  ..style = PaintingStyle.fill
                                  ..strokeWidth = 10
  ;

  _BoardPainter(this.highlighted);

  @override
  void paint(Canvas canvas, Size size) {
    final squareSize = _squareSizeForBoard(size); // Length between each line

    // Draw the squares, one by one
    Paint paint = light; // start with light square
    List.generate(8*8, (i) => i).forEach((i) {
      Square square = _squareForIndex(i);
      Offset topLeft = _topLeftForSquare(square, squareSize);
      canvas.drawRect(
          Rect.fromPoints(topLeft,topLeft.translate(squareSize, squareSize)),
          paint);

      if (square.x != 7) {
        // Alternate paint, except for new rows
        paint = (paint == light) ? dark : light;
      }

    });
    
    // Draw the highlighted square
    if (highlighted != null) {
      final double fontSize = squareSize * .6;
      final topLeft = _topLeftForSquare(highlighted, squareSize);
      final rect = Rect.fromPoints(topLeft,topLeft.translate(squareSize, squareSize));


      if (!highlighted.reveal) {
        // Highlight in green with border and shadow
        canvas.drawShadow(Path()..addRect(rect), Colors.black, 6, false);
        canvas.drawRect(rect, blackOutline);
        canvas.drawRect(rect, highlightPaint);
      } else {
        // Paint on the answer
        TextSpan span = TextSpan(text: highlighted.name(), style: TextStyle(color: Colors.black, fontSize: fontSize, fontWeight: FontWeight.bold));
        TextPainter tp = TextPainter(text: span, textDirection: TextDirection.ltr, maxLines: 1);
        tp.layout();
        canvas.drawRect(rect, highlightPaint);
        tp.paint(canvas, topLeft.translate(squareSize*.1, (squareSize - fontSize ) / 2));
      }
    }
  }

  Square _squareForIndex(int i) {
    return Square(i % 8, (i / 8).floor());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: For some reason equality isn't working here. Oh well.
    return true;
  }
}

double _squareSizeForBoard(Size boardSize) {
  return boardSize.shortestSide / 8;
}

Offset _topLeftForSquare(Square square, double squareSize) {
  final xOffset = square.x * squareSize;
  final yOffset = square.y * squareSize;
  return Offset(xOffset, yOffset);
}