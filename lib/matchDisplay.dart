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
        title:  Text('${widget.Match.match}'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Text('${widget.Match.match}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.grey),),

            Text('${widget.Match.team_a_score} : ${widget.Match.team_b_score}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,),),
            Text('Time: ${widget.Match.time}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
            Text('Total Time: ${widget.Match.totaltime}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,),),
          ],
        ),
      ),
    );
  }
}