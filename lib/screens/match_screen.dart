import 'package:flutter/material.dart';
import '../models/player.dart';
import '../models/bowler.dart';
import '../widgets/score_buttons.dart';
import './scorecard_screen.dart';

class MatchScreen extends StatefulWidget {
  final String teamA, teamB, strikerName, nonStrikerName;
  final int totalOvers, totalPlayers;
  final String battingFirst;

  MatchScreen({
    required this.teamA,
    required this.teamB,
    required this.strikerName,
    required this.nonStrikerName,
    required this.totalOvers,
    required this.totalPlayers,
    required this.battingFirst,
  });

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  late String battingTeam, bowlingTeam;

  late Player striker, nonStriker;
  late Bowler bowler;

  List<Player> outPlayers = [];
  List<Player> allPlayers = [];
  List<List<String>> oversTimeline = [[]];

  int score = 0, wickets = 0, balls = 0, overs = 0;
  int innings = 1, target = 0;

  int firstScore = 0, firstWkts = 0;

  List history = [];

  @override
  void initState() {
    super.initState();

    battingTeam = widget.battingFirst == "A" ? widget.teamA : widget.teamB;
    bowlingTeam = widget.battingFirst == "A" ? widget.teamB : widget.teamA;

    striker = Player(name: widget.strikerName);
    nonStriker = Player(name: widget.nonStrikerName);
    allPlayers.add(striker);
    allPlayers.add(nonStriker);
    bowler = Bowler(name: "Bowler 1");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("$battingTeam Batting"),
            actions: [
                IconButton(
                  icon: Icon(Icons.table_chart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScorecardScreen(players: allPlayers),
                      ),
                    );
                  },
                )
            ],
      
      ),

      body: Column(
            children: [

              // ================= HEADER =================
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(12),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // LINE 1
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          battingTeam,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "$score/$wickets",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),

                    SizedBox(height: 4),

                    // LINE 2
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Overs: $overs.$balls / ${widget.totalOvers}"),
                        if (innings == 2)
                          Text("Target: $target"),
                      ],
                    ),

                    if (innings == 2)
                      Text("1st Innings: $firstScore/$firstWkts"),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: oversTimeline.map((over) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        over.join("  "),
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }).toList(),
                ),
              ),
              // ================= BODY =================
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [  
                      // ===== OUT PLAYERS (TOP) =====
                      if (outPlayers.isNotEmpty)
                        Card(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: outPlayers.map((p) {
                              return Padding(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(p.name),
                                    Text("${p.runs}(${p.balls})"),
                                    Text("4s:${p.fours} 6s:${p.sixes}"),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                      // ===== CURRENT BATSMEN =====
                      Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(striker.name),
                              subtitle: Text("${striker.runs} (${striker.balls})"),
                              trailing: Icon(Icons.sports_cricket),
                            ),
                            Divider(),
                            ListTile(
                              title: Text(nonStriker.name),
                              subtitle: Text("${nonStriker.runs} (${nonStriker.balls})"),
                            ),
                          ],
                        ),
                      ),

                      // ===== BOWLER =====
                      Card(
  child: ListTile(
    title: Text("Bowler: ${bowler.name}"),
    subtitle: Text(
      "Overs: ${bowler.balls ~/ 6}.${bowler.balls % 6} | Runs: ${bowler.runs} | Wkts: ${bowler.wickets}",
    ),
  ),
),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= BUTTONS =================
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.grey[100],
                child: ScoreButtons(
                  onRun: (r) => setState(() => addRun(r)),
                  onWide: () => setState(() => extra()),
                  onNoBall: () => setState(() => extra()),
                  onOut: () => setState(() => wicket()),
                  onUndo: () => setState(() => undo()),
                ),
              ),
            ],
          ),
    );
  }

void newBatsman() {
  TextEditingController c = TextEditingController();

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text("New Batsman"),
      content: TextField(
        controller: c,
        decoration: InputDecoration(hintText: "Enter batsman name"),
      ),
      actions: [
        ElevatedButton(
          child: Text("OK"),
          onPressed: () {
            setState(() {
              striker = Player(name: c.text);   // ✅ NEW batsman
              allPlayers.add(striker);          // ✅ ADD to scorecard list
            });
            Navigator.pop(context);
          },
        )
      ],
    ),
  );
}

  void save() {
    history.add([score, wickets, balls, overs, striker, nonStriker]);
  }

  void undo() {
    if (history.isEmpty) return;
    var h = history.removeLast();
    score = h[0];
    wickets = h[1];
    balls = h[2];
    overs = h[3];
    striker = h[4];
    nonStriker = h[5];

    if (oversTimeline.isNotEmpty) {
      if (oversTimeline.last.isNotEmpty) {
        oversTimeline.last.removeLast();
      } else if (oversTimeline.length > 1) {
        oversTimeline.removeLast();
        oversTimeline.last.removeLast();
      }
    }
  }

  void addRun(int r) {
    save();

    striker.runs += r;
    striker.balls++;
    score += r;

    if (r == 4) striker.fours++;
    if (r == 6) striker.sixes++;

    bowler.runs += r;
    bowler.balls++;
    oversTimeline.last.add("$r");

    ball();

    if (r % 2 != 0) swap();
  }

  void extra() {
    save();
    score++;
    bowler.runs++;
    oversTimeline.last.add("Wd");
  }

  void wicket() {
    save();

    wickets++;
    striker.out = true;
    striker.balls++;
    bowler.wickets++;
    bowler.balls++;

    oversTimeline.last.add("W");
    outPlayers.add(striker);

    ball();

    if (wickets < widget.totalPlayers - 1) newBatsman();
  }

  void ball() {
    balls++;
    if (balls == 6) {
      balls = 0;
      overs++;

      // start new over
      oversTimeline.add([]);

      swap();
    }
    checkEnd();

    balls++;
  }

  void swap() {
    var t = striker;
    striker = nonStriker;
    nonStriker = t;
  }

  void checkEnd() {
    if (overs == widget.totalOvers ||
        wickets == widget.totalPlayers - 1) {

      if (innings == 1) {
        firstScore = score;
        firstWkts = wickets;
        target = score + 1;

        innings = 2;
        score = 0;
        wickets = 0;
        overs = 0;
        balls = 0;
        outPlayers.clear();

        var temp = battingTeam;
        battingTeam = bowlingTeam;
        bowlingTeam = temp;

      } else {
        showResult();
      }
    }
  }

  void showResult() {
    String result;

    if (score >= target) {
      result = "$battingTeam won";
    } else if (score == target - 1) {
      result = "Match Tie";
    } else {
      result = "$bowlingTeam won";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Match Finished"),
        content: Text(result),
      ),
    );
  }
}