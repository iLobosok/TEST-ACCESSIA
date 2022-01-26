/*
LICENSES

 */

import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
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
  @override
  MainPageState createState() => MainPageState();
}
List randomImages =
[
  'https://api.multiavatar.com/Protagonist.png',
  'https://api.multiavatar.com/Tuco.png',
  'https://api.multiavatar.com/Rhett%20James.png',
];
final List<String> imgList = [
  'https://firebasestorage.googleapis.com/v0/b/moodly-b5ef0.appspot.com/o/Carousel%2F20211212_173548_0000.png?alt=media&token=4dfb91b8-c9a9-4ddc-9203-07114112427d',
  'https://firebasestorage.googleapis.com/v0/b/moodly-b5ef0.appspot.com/o/Carousel%2F%D0%A0%D0%BE%D0%B7%D0%BE%D0%B2%D1%8B%D0%B9_%D0%B8_%D0%A2%D0%B5%D0%BC%D0%BD%D0%BE_%D1%81%D0%B8%D0%BD%D0%B8%D0%B9_%D0%96%D0%B5%D0%BD%D1%89%D0%B8%D0%BD%D1%8B_%D0%92%D0%B4%D0%BE%D1%85%D0%BD%D0%BE%D0%B2%D0%B5%D0%BD%D0%B8%D0%B5_%D0%9F%D1%83%D0%B1%D0%BB%D0%B8%D0%BA%D0%B0%D1%86%D0%B8%D1%8F_%D0%B2_Instagram.png?alt=media&token=ac13f793-abbb-4ca1-9953-69254db31ae3',
  ];
int min = 0;
int max = randomImages.length-1;
Random rnd = new Random();
int r = min + rnd.nextInt(max - min);
String image_to_print  = randomImages[r].toString();
class MainPageState extends State<MainPage> {
  File imageFile;

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
              padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
              child: Text('What do you \nwant to \nlearn today?', style: TextStyle(
                  fontSize: 25,
                  height: 1.3,
                  fontWeight: FontWeight.w700
              ),),),
            SizedBox(width: MediaQuery
                .of(context)
                .size
                .width * 0.40,),
            Align(
              alignment: FractionalOffset(3, 3),
              child: InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(top:20),
                      child:CircleAvatar(
                        //circle avatar
                        radius: 30.0,
                        backgroundImage: NetworkImage('$image_to_print'),
                        backgroundColor: Colors.white,
                      )))
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
          padding: EdgeInsets.only(left: 25),
          child:Text(
            'Monthly news',
            style:
            TextStyle(fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black),
          ),),
      SizedBox(height: 5,),
       /* Center(
        child:Container(
          height: getHeight(context: context, factor: 0.2),
          width: getWidth(context: context, factor: 0.9),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.1,
                  1,
                ],
                colors: [
                  Colors.blue[900],
                  Colors.blue[500]
                ],
              )
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
          Padding(
          padding: EdgeInsets.fromLTRB(15, 20, 20, 20),
                child: Text('Welcome dear ${user.firstName}!', style: TextStyle(color: Colors.white, fontSize:20),),
          ),
                user.profilePictureURL == "" ? InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(left:10),
                        child:CircleAvatar(
                          //circle avatar
                          radius: 30.0,
                          backgroundImage: NetworkImage('$image_to_print'),
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
                ]
          ),
        )
      ),*/
      CarouselSlider(
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 240.0,
          initialPage: 0,
          autoPlay: true,
          reverse: false,
          enableInfiniteScroll: true,
          autoPlayInterval: Duration(seconds: 5),
          autoPlayAnimationDuration: Duration(
              milliseconds: 2000),
          scrollDirection: Axis.horizontal,
        ),
        items: imgList
            .map((item) => Container(

            child: Center(
              child:ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
              child:
              Image.network(item, fit: BoxFit.cover, width: 1000)),),
        ))
            .toList(),
      ),
      SizedBox(height: 20,),
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
                    testName: ds.data()['name'],
                    id: ds.data()['id'],
                    img: ds.data()['img'],
                    description: ds.data()['description']
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
