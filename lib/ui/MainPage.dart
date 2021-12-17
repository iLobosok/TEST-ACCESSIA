import "package:flutter/material.dart";
import 'package:music/model/User.dart';
import 'package:music/services/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music/ui/widgets/widgets.dart';


class MainPage extends StatelessWidget {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Quiz').snapshots();
  final User user;
  MainPage({@required this.user});
  final firestoreInstance = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  SingleChildScrollView(
          child: Column(
            children: [
              Container( //задизайнишь по нормальному
                height: getHeight(context: context, factor: 0.2),
                child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Find your profession",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 26
                      ),
                    )
                ),
              ),
              //тут должна быть карусель, ее вставлю позже

      Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: _usersStream,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  print(ds['id']);
                  return testCard(
                    context: context,
                    testName: ds['name'],
                    id: ds['id'],
                    img: ds['img'],
                    description: ds['description']
                  );
                }
              );
            },
        ),
      )
            ],
          ),
        )
    );

  }
}
