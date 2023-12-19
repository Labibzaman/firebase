import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'matchDisplay.dart';

class firebaseMatchApp extends StatefulWidget {
  const firebaseMatchApp({super.key});

  @override
  State<firebaseMatchApp> createState() => _firebaseMatchAppState();
}

class _firebaseMatchAppState extends State<firebaseMatchApp> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late CollectionReference studentCollectionRef =
      firebaseFirestore.collection('football');
  List<FootballMatch> matchList = [];

  Future<void> fetchData() async {
    matchList.clear();
    final QuerySnapshot result = await studentCollectionRef.get();
    for (QueryDocumentSnapshot element in result.docs) {
      print(element.get('match'));
      print(element.data());
      FootballMatch student = FootballMatch(
        match: element.get('match'),
        id: element.id,
        time: element.get('time'),
        team_a: element.get('team_a'),
        team_a_score: element.get('team_a_score'),
        team_b: element.get('team_b'),
        team_b_score: element.get('team_b_score'),
        totaltime: element.get('total_time'),
      );
      matchList.add(student);
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Football Match App'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: StreamBuilder(
            stream: studentCollectionRef.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                matchList.clear();
                for (QueryDocumentSnapshot element in snapshot.data!.docs) {
                  print(element.get('match'));
                  print(element.data());
                  FootballMatch student = FootballMatch(
                    match: element.get('match'),
                    id: element.id,
                    time: element.get('time'),
                    team_a: element.get('team_a'),
                    team_a_score: element.get('team_a_score'),
                    team_b: element.get('team_b'),
                    team_b_score: element.get('team_b_score'),
                    totaltime: element.get('total_time'),
                  );
                  matchList.add(student);
                }

                return ListView.builder(
                  itemCount: matchList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return MatchDisplay(Match:matchList[index],);
                        }));
                      },
                      leading: const CircleAvatar(),
                      title: Text(matchList[index].match),
                    );
                  },
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }
}

class FootballMatch {
  String match;
  String team_a;
  String team_b;
  String team_a_score;
  String team_b_score;
  String time;
  String totaltime;
  String id;

  FootballMatch({
    required this.match,
    required this.id,
    required this.time,
    required this.team_a,
    required this.team_a_score,
    required this.team_b,
    required this.team_b_score,
    required this.totaltime,
  });
}
