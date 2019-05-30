enum StoneColor {
  White, Black
}

/// A single point on the board, potentially set to a current color stone.
class Point {
  final int x;
  final int y;
  final StoneColor color;

  Point(this.x, this.y, this.color);

  @override
  String toString() {
    return 'Point($x,$y,$color)';
  }
}

/// A go board.
///
/// // TODO: Determine mutability: is our board stateful, or stateless?
abstract class Board {
  /// Size of one side of the board, e.g. 9
  int size();

  /// Every point on the board, in rows, starting from the top left corner.
  List<Point> points();

  /// The point at the given offset
  Point pointAt(int x, int y);

  // Group groupAt(int x, int y);

  /// Play a stone to the board.
  ///
  /// This updates the board accordingly:
  /// * assert the spot is empty
  /// * check opposite color neighboring groups for kills
  /// * check for suicide
  /// * update friendly neighboring groups
  ///
  /// TODO: For now, this assumes the play is legal.
  /// Consider passing back a result here instead.
  bool play(Point point, StoneColor color);

  /// Calculate the score for a given color.
  ///
  /// TODO: Let's write this last :)
//  score(Color color);
}

class GoBoard extends Board {

  final int _size;
  List<Point> _points;

  /// Constructor.
  GoBoard(this._size) {
    _points = List.generate(_size * _size, (i) {
      final x = i % _size;
      final y = (i / _size).floor();
      return Point(x, y, null);
    }, growable: false);
  }

  @override
  int size() => _size;

  @override
  List<Point> points() {
    return _points;
  }

  @override
  Point pointAt(int x, int y) {
    assert( x >= 0 && x < _size);
    assert( y >= 0 && y < _size);

    return _points[(y * _size) + x];
  }

  @override
  bool play(Point point, StoneColor color) {
    assert(point.color == null, 'ILLEGAL MOVE : Cant play at an occupied point');


    // TODO: Check for kills
    // TODO: Check against suicide
    // Add the stone
    _points[(point.y * _size) + point.x] = Point(point.x, point.y, color);

    // TODO: Update groups
    return true;
  }

  List<Point> _neighbors(Point p) {
    return [
      if (p.y != 0) pointAt(p.x, p.y - 1), // Top
      if (p.y != _size - 1) pointAt(p.x, p.y + 1), // Bottom
      if (p.x != 0) pointAt(p.x - 1, p.y), // Left
      if (p.x != _size - 1) pointAt(p.x + 1, p.y), // Right
    ];
  }
}
