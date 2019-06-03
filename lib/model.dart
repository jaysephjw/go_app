import 'dart:collection';

/// A single square on the chess board.
import 'dart:math';

class Square {
  final int x;
  final int y;

  // SUPER hacky way to pass flag in to highlighted board cell
  bool reveal = false;

  // SUPER hacky way to pass flag in to reverse the board to show as black
  bool printAsBlack = false;

  Square(this.x, this.y);

  static String cols = 'abcdefgh';
  static String rows = '87654321';

  String name() {
    if (printAsBlack) {
      return '${cols[7 - x]}${rows[7 - y]}';
    }
    return '${cols[x]}${rows[y]}';
  }

  @override
  bool operator ==(other) {
    return
      other != null &&
      other.x == x &&
      other.y == y &&
      other.reveal == reveal
    ;
  }

  @override
  int get hashCode => (x * 8) + y + (reveal ? 100 : 0);
}
