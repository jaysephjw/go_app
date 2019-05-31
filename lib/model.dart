import 'dart:collection';

/// A single square on the chess board.
class Square {
  final int x;
  final int y;

  // SUPER hacky way to pass flag in to highlighted board cell
  bool reveal = false;

  Square(this.x, this.y);


  static const cols = 'ABCDEFGH';
  static const rows = '87654321';

  String name() {
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