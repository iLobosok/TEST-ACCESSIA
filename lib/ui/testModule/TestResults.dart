import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music/database/score.dart';
import 'package:music/services/helper.dart';
import 'package:provider/src/provider.dart';
class TestResults extends StatelessWidget {
  final String id;
  TestResults({@required this.id});

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _resultStream = FirebaseFirestore.instance.collection('Quiz').doc(id).snapshots();
    return Scaffold(
      body: Stack(
        children: [ 
          Center(
            child: LottieBuilder.asset('assets/74694-confetti.json',
                fit: BoxFit.fill),
          ),
          Container(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                  height: getHeight(context: context, factor: 0.4),
                  child:  Align(
                      alignment: Alignment.center,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: _resultStream,
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
                                  color: Colors.black
                              ),
                            );
                          }
                      )
                  )
              ),
              Column(
                children: [
                  Container(
                    height: getHeight(context: context, factor: 0.1),
                    child: Align(
                        alignment: Alignment.center,
                        child: Text('Congratulations!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                          ),),
                    )
                  ),
                ],
              ),
              Container(
                  height: getHeight(context: context, factor: 0.1),
                  child:  Align(
                      alignment: Alignment.center,
                      child: StreamBuilder<DocumentSnapshot>(
                          stream: _resultStream,
                          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            print(context.watch<Score>().getScore);
                            if (snapshot.hasError) {
                              return Text('Something went wrong');
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text("Loading");
                            }
                            if(context.watch<Score>().getScore >= int.parse(snapshot.data['prof3'][1])){
                              return Text(
                                'You are ${snapshot.data['prof3'][0]}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              );

                            }
                            if(context.watch<Score>().getScore >= int.parse(snapshot.data['prof2'][1])){
                              return Text(
                                'You are ${snapshot.data['prof2'][0]}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              );

                            }
                            
                              return Text(
                                'You are ${snapshot.data['prof1'][0]}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black
                                ),
                              );





                          }
                      )
                  )
              ),
            ]
          )
        ),
      ]
      ),
    );
  }
}
