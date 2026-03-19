class Player {
  String name;
  int runs;
  int balls;
  int fours;
  int sixes;
  bool out;

  Player({
    required this.name,
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.out = false,
  });
}