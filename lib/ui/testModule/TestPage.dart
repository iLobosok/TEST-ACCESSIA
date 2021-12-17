import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music/services/helper.dart';
import 'package:music/ui/widgets/widgets.dart';


class TestPage extends StatelessWidget {
  final String id;

  TestPage({@required this.id});

  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('Quiz').snapshots();
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
                  height: getHeight(context: context, factor: 0.2),
                  child:  Align(
                    alignment: Alignment.center,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _userStream,
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

                          //DocumentSnapshot ds = snapshot.data.docs[0]['name'];
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text("Loading");
                          }
                          return Text(
                            '${snapshot.data.docs[int.parse(id)-1]['name']}',
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
              Expanded(child: Container()),
              Container(
                padding: EdgeInsets.symmetric(horizontal: getWidth(context: context, factor: 0.04)),
                width: getWidth(context: context, factor: 1),
                height: getHeight(context: context, factor: 0.65),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(
                            getHeight(context: context, factor: 0.03)
                        ),
                        child: Align(
                            alignment: Alignment.topCenter,
                            child: Text(
                                'new block',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,

                                ),
                            )
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: getWidth(context: context, factor: 0.03)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(height: getHeight(context: context, factor: 0.08),),
                            SizedBox(
                                height: getHeight(context: context, factor: 0.08),
                                child: AnswerButton(name: '1',),
                            ),
                            SizedBox(height: getHeight(context: context, factor: 0.02),),
                            SizedBox(
                              height: getHeight(context: context, factor: 0.08),
                              child: AnswerButton(name: '2',),
                            ),
                            SizedBox(height: getHeight(context: context, factor: 0.02),),
                            SizedBox(
                              height: getHeight(context: context, factor: 0.08),
                              child: AnswerButton(name: '3',),
                            ),
                            SizedBox(height: getHeight(context: context, factor: 0.02),),
                            SizedBox(
                              height: getHeight(context: context, factor: 0.08),
                              child: AnswerButton(name: '4',),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                )
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
