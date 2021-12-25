import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:music/model/User.dart';
import 'package:music/services/helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:music/ui/widgets/widgets.dart';

Size displaySize(BuildContext context) {
  debugPrint('Size = ' + MediaQuery.of(context).size.toString());
  return MediaQuery.of(context).size;
}

double displayHeight(BuildContext context) {
  debugPrint('Height = ' + displaySize(context).height.toString());
  return displaySize(context).height;
}
double displayWidth(BuildContext context) {
  debugPrint('Width = ' + displaySize(context).width.toString());
  return displaySize(context).width;
}

class MainPage extends StatefulWidget{
  final User user;
  const MainPage({Key key, this.user}) : super(key: key);
  @override
  MainPageState createState() => MainPageState(user);
}

class MainPageState extends State<MainPage> {
  File imageFile;
  final User user;
  MainPageState(this.user);

  //upload user profile picture
  _getFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
    }
  }
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }
  final ImagePicker _imagePicker = ImagePicker();
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Quiz').snapshots();
  final firestoreInstance = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
    child: SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child:Text(
                'Find Your\nVocation',
                style: TextStyle(color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold),
              ),),
            SizedBox(width: MediaQuery
                .of(context)
                .size
                .width * 0.40,),
            Align(
              alignment: FractionalOffset(3, 3),
              child: user.profilePictureURL == "" ? InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(top:20),
                      child:CircleAvatar(
                        //circle avatar
                        radius: 30.0,
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'),
                        backgroundColor: Colors.white,
                      ))) : InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(top:20),
                      child:InkWell(
                        onTap: () {
                         _getFromGallery();
                        },
                          child:CircleAvatar(
                        radius: 30.0,
                        backgroundImage: NetworkImage('${user.profilePictureURL}'),
                        backgroundColor: Colors.white,
                      )))),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Center(
            child:Container(
              width: displayWidth(context) * 0.95,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(244, 243, 243, 1),
                  borderRadius: BorderRadius.circular(15)),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black87,
                    ),
                    hintText: "Search something",
                    hintStyle:
                    TextStyle(color: Colors.grey, fontSize: 15)),
              ),
            )
        ),
        SizedBox(
          height: 10,
        ),
        SizedBox(height:20),
        Padding(
          padding: EdgeInsets.only(left: 20),
          child:Text(
            'Promo Today',
            style:
            TextStyle(fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),),
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
        ),
      )
    );

  }

}
