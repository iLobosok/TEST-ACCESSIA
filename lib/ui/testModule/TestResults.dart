import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:music/database/score.dart';
import 'package:music/services/helper.dart';
import 'package:music/ui/MainPage.dart';
import 'package:provider/src/provider.dart';
class TestResults extends StatelessWidget {
  final String id;
  TestResults({@required this.id});

  @override
  Widget build(BuildContext context) {
    Stream<DocumentSnapshot> _resultStream = FirebaseFirestore.instance.collection('Quiz').doc(id).snapshots();
    return Scaffold(
      backgroundColor: Colors.blue[600],
      body: Stack(
        children: [ 
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: LottieBuilder.asset('assets/74694-confetti.json',
                fit: BoxFit.fill, repeat: false),
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
                                  color: Colors.white
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
                              color: Colors.white
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
                                'Check this jobs: ${snapshot.data['prof3'][0]}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              );

                            }
                            if(context.watch<Score>().getScore >= int.parse(snapshot.data['prof2'][1])){
                              return Text(
                                'Check this jobs: ${snapshot.data['prof2'][0]}!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              );

                            }
                            
                              return Text(
                                'Check this jobs: ${snapshot.data['prof1'][0]}!',
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
              SizedBox(height: 70,),
              /*Container(
                padding: EdgeInsets.symmetric(horizontal: getHorizontalPadding(context: context, factor: 0.2)),
                child: TextButton(
                  child: Center(child:Text('Go to home',
                      style: TextStyle(color: Colors.white)
                  ),),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                      shape:  MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          side: BorderSide(width: 2.0, style: BorderStyle.solid, color: Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                      )
                  ),
                  onPressed: (){
                    pushReplacement(context, MainPage());
                  },
                ),
              )*/
            ]
          )
        ),
      ]
      ),
    );
  }
}
