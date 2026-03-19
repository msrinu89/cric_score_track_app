// import 'package:flutter/material.dart';

// void main() {
//   runApp(CricketApp());
// }

// class CricketApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: StartMatchScreen(),
//     );
//   }
// }

// // ================= START =================

// class StartMatchScreen extends StatefulWidget {
//   @override
//   _StartMatchScreenState createState() => _StartMatchScreenState();
// }

// class _StartMatchScreenState extends State<StartMatchScreen> {
//   final teamA = TextEditingController();
//   final teamB = TextEditingController();
//   final bat1 = TextEditingController();
//   final bat2 = TextEditingController();

//   int overs = 5;
//   int players = 11;
//   String batting = "A";

//   void start() {
//     if (teamA.text.isEmpty ||
//         teamB.text.isEmpty ||
//         bat1.text.isEmpty ||
//         bat2.text.isEmpty) return;

//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (_) => MatchScreen(
//           teamA: teamA.text,
//           teamB: teamB.text,
//           strikerName: bat1.text,
//           nonStrikerName: bat2.text,
//           totalOvers: overs,
//           totalPlayers: players,
//           battingFirst: batting,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Start Match")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: ListView(
//           children: [
//             TextField(controller: teamA, decoration: InputDecoration(labelText: "Team A")),
//             TextField(controller: teamB, decoration: InputDecoration(labelText: "Team B")),

//             DropdownButton(
//               value: batting,
//               items: [
//                 DropdownMenuItem(value: "A", child: Text("Team A Batting")),
//                 DropdownMenuItem(value: "B", child: Text("Team B Batting")),
//               ],
//               onChanged: (v) => setState(() => batting = v!),
//             ),

//             Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text("Overs: $overs"),
//     Row(
//       children: [
//         IconButton(
//           icon: Icon(Icons.remove),
//           onPressed: () {
//             if (overs > 1) setState(() => overs--);
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.add),
//           onPressed: () {
//             if (overs < 50) setState(() => overs++);
//           },
//         ),
//       ],
//     )
//   ],
// ),

//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("Players: $players"),
//                 Row(
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.remove),
//                       onPressed: () {
//                         if (players > 2) setState(() => players--);
//                       },
//                     ),
//                     IconButton(
//                       icon: Icon(Icons.add),
//                       onPressed: () {
//                         if (players < 11) setState(() => players++);
//                       },
//                     ),
//                   ],
//                 )
//               ],
//             ),

//             TextField(controller: bat1, decoration: InputDecoration(labelText: "Striker")),
//             TextField(controller: bat2, decoration: InputDecoration(labelText: "Non-Striker")),

//             ElevatedButton(onPressed: start, child: Text("Start"))
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ================= PLAYER =================

// class Player {
//   String name;
//   int runs = 0;
//   int balls = 0;
//   bool out = false;

//   Player(this.name);
// }

// // ================= Bowler =================
// class Bowler {
//   String name;
//   int runs = 0;
//   int balls = 0;
//   int wickets = 0;

//   Bowler(this.name);
// }

// // ================= MATCH =================

// class MatchScreen extends StatefulWidget {
//   final String teamA;
//   final String teamB;
//   final String strikerName;
//   final String nonStrikerName;
//   final int totalOvers;
//   final int totalPlayers;
//   final String battingFirst;

//   MatchScreen({
//     required this.teamA,
//     required this.teamB,
//     required this.strikerName,
//     required this.nonStrikerName,
//     required this.totalOvers,
//     required this.totalPlayers,
//     required this.battingFirst,
//   });

//   @override
//   _MatchScreenState createState() => _MatchScreenState();
// }

// class _MatchScreenState extends State<MatchScreen> {
//   late String battingTeam;
//   late String bowlingTeam;

//   late Player striker;
//   late Player nonStriker;
//   late Bowler bowler;

//   List<Player> allPlayers = [];

//   int score = 0, wickets = 0, balls = 0, overs = 0;
//   int innings = 1, target = 0;

//   List history = [];

//   @override
//   void initState() {
//     super.initState();

//     battingTeam = widget.battingFirst == "A" ? widget.teamA : widget.teamB;
//     bowlingTeam = widget.battingFirst == "A" ? widget.teamB : widget.teamA;

//     striker = Player(widget.strikerName);
//     nonStriker = Player(widget.nonStrikerName);
//     bowler = Bowler("Bowler 1");

//     allPlayers.add(striker);
//     allPlayers.add(nonStriker);
//   }

//   // ================= UI =================

//   // ================= LOGIC =================

//   void saveState() {
//     history.add([
//       score, wickets, balls, overs,
//       striker, nonStriker
//     ]);
//   }

//   void undo() {
//     if (history.isEmpty) return;

//     var last = history.removeLast();

//     score = last[0];
//     wickets = last[1];
//     balls = last[2];
//     overs = last[3];
//     striker = last[4];
//     nonStriker = last[5];
//   }

//   void addRun(int r) {
//     saveState();

//     striker.runs += r;
//     striker.balls++;
//     bowler.runs += r;
//     bowler.balls++;
//     score += r;

//     ball();

//     if (r % 2 != 0) swap();
//   }

//   void extra() {
//     saveState();
//     bowler.runs += 1;
//     score++;
//   }

//   void wicket() {
//     saveState();

//     wickets++;
//     striker.out = true;
//     striker.balls++;
//     bowler.wickets++;
//     bowler.balls++;

//     ball();

//     if (wickets < widget.totalPlayers - 1) {
//       newBatsman();
//     }
//   }

//   void ball() {
//     balls++;
//     if (balls == 6) {
//       balls = 0;
//       overs++;
//       swap();
//     }
//     checkEnd();
//   }

//   void swap() {
//     var t = striker;
//     striker = nonStriker;
//     nonStriker = t;
//   }

//   void newBatsman() {
//     TextEditingController c = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("New Batsman"),
//         content: TextField(controller: c),
//         actions: [
//           ElevatedButton(
//             child: Text("OK"),
//             onPressed: () {
//               setState(() {
//                 striker = Player(c.text);
//                 allPlayers.add(striker);
//               });
//               Navigator.pop(context);
//             },
//           )
//         ],
//       ),
//     );
//   }

//   void checkEnd() {
//     if (overs == widget.totalOvers ||
//         wickets == widget.totalPlayers - 1) {

//       if (innings == 1) {
//         target = score + 1;

//         innings = 2;
//         score = 0;
//         wickets = 0;
//         overs = 0;
//         balls = 0;

//         // SWITCH TEAMS
//         var temp = battingTeam;
//         battingTeam = bowlingTeam;
//         bowlingTeam = temp;

//       } else {
//         showResult();
//       }
//     }
//   }

//   void showResult() {
//     String result;

//     if (score >= target) {
//       result = "$battingTeam won";
//     } else if (score == target - 1) {
//       result = "Match Tie";
//     } else {
//       result = "$bowlingTeam won";
//     }

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Match Finished"),
//         content: Text(result),
//       ),
//     );
//   }

//   void showScorecard() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("Scorecard"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: allPlayers.map((p) =>
//             Text("${p.name} - ${p.runs} (${p.balls}) ${p.out ? "out" : "not out"}")
//           ).toList(),
//         ),
//       ),
//     );
//   }

//   void changeBowler() {
//     TextEditingController c = TextEditingController();

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: Text("New Bowler"),
//         content: TextField(controller: c),
//         actions: [
//           ElevatedButton(
//             child: Text("OK"),
//             onPressed: () {
//               setState(() {
//                 bowler = Bowler(c.text);
//               });
//               Navigator.pop(context);
//             },
//           )
//         ],
//       ),
//     );
//   }
// }