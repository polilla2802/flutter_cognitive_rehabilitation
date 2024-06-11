class Game {
  int? progress;

  Game({this.progress});

  Game.fromJson(Map<String, dynamic> json) {
    progress = json['progress']["value"];
  }
}
