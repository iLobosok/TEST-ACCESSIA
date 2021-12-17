import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:music/services/helper.dart';


class TestPage extends StatelessWidget {
  final String id;

  TestPage({@required this.id});

  @override
  Widget build(BuildContext context) {

    Stream<QuerySnapshot> _userStream = FirebaseFirestore.instance.collection('Quiz').snapshots();
    Stream<DocumentSnapshot> _testStream = FirebaseFirestore.instance.collection('Quiz').doc(id).snapshots();

    return Scaffold(
      body: Container(
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
                          return Text('${snapshot.data.docs[int.parse(id)-1]['name']}', textAlign: TextAlign.center, style: TextStyle(fontSize: 20),);
                        }
                      )
                  )
                ),
              Container(
                child: Text('there will be answers'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
