import 'dart:core';
import 'package:firebase_counter/matchApp.dart';
import 'package:flutter/material.dart';


class MatchDisplay extends StatefulWidget {
  final FootballMatch Match;
   MatchDisplay({super.key, required this.Match});



  @override
  State<MatchDisplay> createState() => _MatchDisplayState();
}

class _MatchDisplayState extends State<MatchDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Match Display'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text('Match: ${widget.Match.match}'),
            Text('Team A: ${widget.Match.team_a} - ${widget.Match.team_a_score}'),
            Text('Team B: ${widget.Match.team_b} - ${widget.Match.team_b_score}'),
            Text('Time: ${widget.Match.time}'),
            Text('Total Time: ${widget.Match.totaltime}'),
          ],
        ),
      ),
    );
  }
}