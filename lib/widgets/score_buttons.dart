import 'package:flutter/material.dart';

class ScoreButtons extends StatelessWidget {
  final Function(int) onRun;
  final Function onWide;
  final Function onNoBall;
  final Function onOut;
  final Function onUndo;

  ScoreButtons({
    required this.onRun,
    required this.onWide,
    required this.onNoBall,
    required this.onOut,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 10,
          children: [0,1,2,3,4,6].map((r) {
            return ElevatedButton(
              child: Text("$r"),
              onPressed: () => onRun(r),
            );
          }).toList(),
        ),
        Wrap(
          spacing: 10,
          children: [
            ElevatedButton(onPressed: () => onWide(), child: Text("Wide")),
            ElevatedButton(onPressed: () => onNoBall(), child: Text("No Ball")),
            ElevatedButton(onPressed: () => onOut(), child: Text("Out")),
            ElevatedButton(onPressed: () => onUndo(), child: Text("Undo")),
          ],
        )
      ],
    );
  }
}