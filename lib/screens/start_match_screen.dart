import 'package:flutter/material.dart';
import 'match_screen.dart';

class StartMatchScreen extends StatefulWidget {
  @override
  _StartMatchScreenState createState() => _StartMatchScreenState();
}

class _StartMatchScreenState extends State<StartMatchScreen> {
  final teamA = TextEditingController();
  final teamB = TextEditingController();
  final bat1 = TextEditingController();
  final bat2 = TextEditingController();

  int overs = 5;
  int players = 11;
  String batting = "A";

  void start() {
    if (teamA.text.isEmpty ||
        teamB.text.isEmpty ||
        bat1.text.isEmpty ||
        bat2.text.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MatchScreen(
          teamA: teamA.text,
          teamB: teamB.text,
          strikerName: bat1.text,
          nonStrikerName: bat2.text,
          totalOvers: overs,
          totalPlayers: players,
          battingFirst: batting,
        ),
      ),
    );
  }

  Widget counter(String label, int value, Function inc, Function dec) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$label: $value"),
        Row(
          children: [
            IconButton(icon: Icon(Icons.remove), onPressed: () => dec()),
            IconButton(icon: Icon(Icons.add), onPressed: () => inc()),
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Start Match")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: teamA, decoration: InputDecoration(labelText: "Team A")),
            TextField(controller: teamB, decoration: InputDecoration(labelText: "Team B")),

            DropdownButton(
              value: batting,
              items: [
                DropdownMenuItem(value: "A", child: Text("Team A Batting")),
                DropdownMenuItem(value: "B", child: Text("Team B Batting")),
              ],
              onChanged: (v) => setState(() => batting = v!),
            ),

            counter("Overs", overs,
                () => setState(() => overs++),
                () => setState(() { if (overs > 1) overs--; })),

            counter("Players", players,
                () => setState(() { if (players < 11) players++; }),
                () => setState(() { if (players > 2) players--; })),

            TextField(controller: bat1, decoration: InputDecoration(labelText: "Striker")),
            TextField(controller: bat2, decoration: InputDecoration(labelText: "Non-Striker")),

            SizedBox(height: 20),
            ElevatedButton(onPressed: start, child: Text("Start Match"))
          ],
        ),
      ),
    );
  }
}