import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Firebase_StudentApp extends StatefulWidget {
  const Firebase_StudentApp({super.key});

  @override
  State<Firebase_StudentApp> createState() => _Firebase_StudentAppState();
}

class _Firebase_StudentAppState extends State<Firebase_StudentApp> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController nameTEcontroller = TextEditingController();
  TextEditingController rollTEcontroller = TextEditingController();

  late CollectionReference studentCollectionRef =
      firebaseFirestore.collection('students');
  List<Student> studentlist = [];

  Future<void> fetchData() async {
    studentlist.clear();
    final QuerySnapshot result = await studentCollectionRef.get();
    for (QueryDocumentSnapshot element in result.docs) {
      print(element.get('name'));
      print(element.data());
      Student student =
          Student(name: element.get('name'), roll: element.get('roll'), id: element.id);
      studentlist.add(student);
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
        title: const Text('FireBase student app'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottom();
        },
        child: const Icon(CupertinoIcons.plus),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: StreamBuilder(
            stream: studentCollectionRef.orderBy('roll').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                studentlist.clear();
                for (QueryDocumentSnapshot element in snapshot.data!.docs) {
                  print(element.get('name'));
                  print(element.data());
                  Student student = Student(
                      name: element.get('name'),
                      roll: int.parse(element.get('roll').toString() ), id: element.id);
                  studentlist.add(student);
                }

                return ListView.builder(
                  itemCount: studentlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(studentlist[index].roll.toString()),
                      ),
                      title: Text(studentlist[index].name),
                      trailing: Wrap(
                        children: [
                          GestureDetector(
                            onTap: (){

                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          TextFormField(
                                            controller: nameTEcontroller,
                                          ),
                                          TextFormField(
                                            controller: rollTEcontroller,
                                          ),
                                          ElevatedButton(
                                              onPressed: () async {
                                                await studentCollectionRef.doc(studentlist[index].id).update({
                                                  'name': nameTEcontroller.text.trim(),
                                                  'roll': int.tryParse(rollTEcontroller.text.trim()),
                                                });
                                                Navigator.pop(context);
                                                nameTEcontroller.clear();
                                                rollTEcontroller.clear();
                                              },
                                              child: const Text('add'))
                                        ],
                                      );
                                    });
                              },
                              child: Icon(Icons.edit)),
                          GestureDetector(
                              onTap: (){
                                studentCollectionRef.doc(studentlist[index].id).delete();
                              },
                              child: Icon(Icons.delete_forever))
                        ],
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            }),
      ),
    );
  }

  void showModalBottom() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            children: [
              TextFormField(
                controller: nameTEcontroller,
              ),
              TextFormField(
                controller: rollTEcontroller,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await studentCollectionRef.add({
                      'name': nameTEcontroller.text.trim(),
                      'roll': int.tryParse(rollTEcontroller.text.trim()),
                    });
                    Navigator.pop(context);
                    nameTEcontroller.clear();
                    rollTEcontroller.clear();
                  },
                  child: const Text('add'))
            ],
          );
        });
  }
}

class Student {
  String name;
  int roll;
  String id;

  Student({required this.name, required this.roll,required this.id});
}
