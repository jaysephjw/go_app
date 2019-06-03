import 'package:dio/dio.dart';

import 'model.dart';

Dio _dio;

/// Init our http client stuffs.
Future<void> init() {
  _dio = Dio();
}

Future<GameRecord> getGame(String gameID) async {
  final result = await _dio.get(
    'https://online-go.com/api/v1/games/$gameID',
  );
  return GameRecord.fromJson(result.data);
}


















class GameRecord {

  final int width;
  final List<Point> moves;
  final int white;
  final int black;

  GameRecord(this.width, this.moves, this.white, this.black);

  static GameRecord fromJson(dynamic json) {

    // Parse moves
    List<Point> moves = json['gamedata']['moves'].map<Point>((js) => Point(js[0], js[1], null)).toList();

    return GameRecord(
      json['width'],
      moves,
      json['white'],
      json['black'],
    );
  }
}

class Move {
  int x;
  int y;
  int time;
}



