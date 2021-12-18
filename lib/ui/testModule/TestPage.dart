import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music/database/score.dart';
import 'package:music/services/helper.dart';
import 'package:music/ui/widgets/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/src/provider.dart';


class TestPage extends StatelessWidget {
  final String id;

  TestPage({@required this.id});

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('Quiz').snapshots();
    Stream<QuerySnapshot> _questionStream = FirebaseFirestore.instance.collection('Quiz').doc(id).collection('question').snapshots();
    Stream<DocumentSnapshot> _testStream = FirebaseFirestore.instance.collection('Quiz').doc(id).snapshots();

    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [
                  0.1,
                  0.7,
                  1,
                ],
                colors: [
                  Colors.teal[900],
                  Colors.blue[900],
                  Colors.teal[900]
                ],
              )
          ),
        child: Center(
          child: Column(
            children: [
                Container(
                  height: getHeight(context: context, factor: 0.16),
                  child:  Align(
                    alignment: Alignment.center,
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: _testStream,
                        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Loading");
                          }
                          return Text(
                            '${snapshot.data['name']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          );
                        }
                      )
                  )
                ),
              // Container(
              //   height: getHeight(context: context, factor: 0.04),
              //   child: Text(
              //     context.watch<Score>().getScore.toString(),
              //     style: TextStyle(
              //       fontSize: 15,
              //       color: Colors.white
              //     ),
              //   )
              // ),
              SizedBox(
                height: getHeight(context: context, factor: 0.12),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _questionStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return CarouselSlider.builder(
                      itemCount: snapshot.data.docs.length,
                      options: CarouselOptions(
                        viewportFraction: 0.85,
                        enlargeCenterPage: true,
                        height: getHeight(context: context, factor: 0.6)
                      ),
                      itemBuilder: (context, index){
                        DocumentSnapshot ds = snapshot.data.docs[index];
                        return Question(
                          title: ds['title'],
                          a1: ds['a1'],
                          a2: ds['a2'],
                          a3: ds['a3'],
                          context: context,
                        );
                      }
                  );
                  // return ListView.builder(
                  //   shrinkWrap: true,
                  //     itemCount: snapshot.data.docs.length,
                  //     itemBuilder: (context, index){
                  //       DocumentSnapshot ds = snapshot.data.docs[index];
                  //             return Question(
                  //               title: ds['title'],
                  //               a1: ds['a1'],
                  //               a2: ds['a2'],
                  //               a3: ds['a3'],
                  //               context: context,
                  //             );
                  //     }
                  // );
                }
              ),
              SizedBox(
                height: getHeight(context: context, factor: 0.06),
              )

            ],
          ),
        ),
      ),
    );
  }
}
