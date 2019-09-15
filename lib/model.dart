import 'dart:collection';

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

  Point kill() {
    return Point(x, y, null);
  }

  Point as(StoneColor color) {
    return Point(x, y, color);
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
  /// * check against Ko
  /// * check opposite color neighboring groups for kills
  /// * check for suicide
  /// * update friendly neighboring groups
  ///
  /// TODO: For now, this assumes the play is legal.
  /// Consider passing back a result here instead.
  bool play(Point point, StoneColor color);


  /// Helper to set the given point onto the board, using its x,y coordinate.
  ///
  /// Private, as this does not check any conditions.
  void _set(Point point);

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

//
//  @override
//  // TODO: implement hashCode
//  int get hashCode() {
//
//    // TODO https://en.wikipedia.org/wiki/Zobrist_hashing
//
//  }
//
//  @override
//  bool operator ==(other) {
//    // TODO: implement ==
//    return super.==(other);
//  }

  @override
  bool play(Point point, StoneColor color) {

    // Create new point.
    final Point newPoint = Point(point.x, point.y, color);

    // Special case :: no color.  Allow this to implement an 'eraser' tool.
    // This can cause no kills and is always legal.
    if (newPoint.color == null) {
      _set(newPoint);
      return true;
    }

    // Can't play at an occupied space.
    if (point.color != null) {
      print('ILLEGAL MOVE : Cant play at an occupied point');
      return false;
    }

    // Check for kills.
    // -- Get neighboring, opposing groups.
    final List<Set<Point>> neighborEnemyGroups = _neighbors(newPoint)
        .where((p) => p.color != null && p.color == flip(newPoint.color))
        .map((p) => _getGroup(p))
        .toList();

//    print('Got ${neighborEnemyGroups.length} enemy neighbors');

    // -- Check their liberty. Kill any in atari (the new stone will remove this last liberty)
    bool killedAny = false;
    neighborEnemyGroups.forEach((group) {
      int liberty = _calcLiberty(group);
//      print('Neighbor has $liberty liberty');
      if (liberty == 1) {
        print('Killing group $group');
        group.forEach((p) => _set(p.kill()));
        killedAny = true;
      }
    });

    // Check against suicide.
    if (!killedAny && _calcLiberty(_getGroup(newPoint)) == 0) {
      print('ILLEGAL MOVE : Suicide is forbidden.');
      return false;
    }

    // Add the stone
    _set(newPoint);

    // Print neighbors
    print('New point in group size ${_getGroup(newPoint).length}');

    return true;
  }

  @override
  void _set(Point newPoint) {
    _points[(newPoint.y * _size) + newPoint.x] = newPoint;
  }

  List<Point> _neighbors(Point p) {
    return [
      if (p.y != 0) pointAt(p.x, p.y - 1), // Top
      if (p.y != _size - 1) pointAt(p.x, p.y + 1), // Bottom
      if (p.x != 0) pointAt(p.x - 1, p.y), // Left
      if (p.x != _size - 1) pointAt(p.x + 1, p.y), // Right
    ];
  }

  Set<Point> _getGroup(Point p) {
    assert(p.color != null, 'Cannot get groups for an empty point');

    Set<Point> stones = {p}; // One-stone group
    Set<Point> seen = {};
    Queue<Point> neighbors = Queue();
    neighbors.addAll(_neighbors(p));

    while(neighbors.isNotEmpty) {
      Point neighbor = neighbors.removeFirst();

      if (seen.contains(neighbor)) continue;
      seen.add(neighbor);

      if (neighbor.color == p.color) {
        stones.add(neighbor);
        neighbors.addAll(_neighbors(neighbor));
      }
    }
    return stones;
  }

  /// Count up the liberty for a given group.
  ///
  /// Each unique empty neighbor of any stone in the group counts as a liberty.
  _calcLiberty(Set<Point> group) =>
        group.expand((p) => _neighbors(p))            // get all neighbors
        .toSet()                                      // filter out duplicate ones
        .where((neighbor) => neighbor.color == null)  // count only empty ones
        .length;                                      // get the length.
}

StoneColor flip(StoneColor color) {
  return color == StoneColor.Black ? StoneColor.White : StoneColor.Black;
}