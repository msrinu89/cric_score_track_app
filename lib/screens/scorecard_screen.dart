import 'package:flutter/material.dart';
import '../models/player.dart';

class ScorecardScreen extends StatelessWidget {
  final List<Player> players;

  ScorecardScreen({required this.players});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scorecard")),
      body: SingleChildScrollView(
        child: DataTable(
          columns: [
            DataColumn(label: Text("Player")),
            DataColumn(label: Text("R")),
            DataColumn(label: Text("B")),
            DataColumn(label: Text("4s")),
            DataColumn(label: Text("6s")),
            DataColumn(label: Text("Status")),
          ],
          rows: players.map((p) {
            return DataRow(cells: [
              DataCell(Text(p.name)),
              DataCell(Text("${p.runs}")),
              DataCell(Text("${p.balls}")),
              DataCell(Text("${p.fours}")),
              DataCell(Text("${p.sixes}")),
              DataCell(Text(p.out ? "Out" : "Not Out")),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}