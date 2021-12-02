import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:music/animation/FadeAnimation.dart';
import 'package:music/database/Data.dart';
import 'package:music/model/AddingProduct.dart';
import 'package:music/model/User.dart';
import 'package:music/model/config.dart';
import 'package:music/model/database.dart';
import 'package:music/model/question_model.dart';
import 'package:music/ui/create_quiz.dart';
import 'package:music/ui/quiz_play.dart';


class Shop extends StatefulWidget {
  final User user;
  final String quizTitle, quizDesc, quizImgUrl;
  const Shop({Key key, this.user, this.quizTitle, this.quizDesc, this.quizImgUrl}) : super(key: key);

  @override
  State createState() {
    return Shopping(user);
  }
}

List randomImages =
[
  'https://cdn.pixabay.com/photo/2014/09/30/22/50/sandstone-467714_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/06/15/15/34/fog-5302291_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/23/14/41/forest-5855196_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/10/21/09/49/beach-5672641_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/18/15/29/mountains-5842346_960_720.jpg',
  'https://cdn.pixabay.com/photo/2021/01/28/03/13/person-5956897_960_720.jpg',
  'https://cdn.pixabay.com/photo/2020/12/10/08/44/mountains-5819651_960_720.jpg',
  'https://cdn.pixabay.com/photo/2021/01/29/09/33/beach-5960371_960_720.jpg',
  'https://cdn.pixabay.com/photo/2021/01/21/09/58/swan-5936863_960_720.jpg',
];
int min = 0;
int max = randomImages.length-1;
Random rnd = new Random();
int r = min + rnd.nextInt(max - min);
String image_to_print  = randomImages[r].toString();

Future<List<DocumentSnapshot>> getData() async {
  var firestore = FirebaseFirestore.instance;
  QuerySnapshot qn = await firestore
      .collection("Quiz")
      .get();
  return qn.docs;
}

class Shopping extends State<Shop> {
  CollectionReference collectionReference  = FirebaseFirestore.instance.collection('Quiz');
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final myController = TextEditingController();
  bool searchstate = false;
  final User user;
  List images_collection = [];
  List<Data> dataList = [];//тут будет список виджетов данных для виджетов, котрый создастся при чтении данных с бд
  List<QuestionModel> questionList = [];
  DatabaseReference databaseReference = FirebaseDatabase.instance.reference();// инициализация бд
  Shopping(this.user);
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    getDataFromFirebaseAndBuildCarousel(1);
    getDataFromFirebaseAndBuildList();
    //вызываем функцию, которая создаст список виджетов и отрисует их
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
  }



  int _value = 1;
  @override
  Widget build(BuildContext context) {
    getDataFromFirebaseAndBuildCarousel(0);
    getDataFromFirebaseAndBuildList();
    CollectionReference db = FirebaseFirestore.instance.collection("Quiz");
    Stream quizStream;
    DatabaseService databaseService = new DatabaseService();
    setState(() {});
    String imageUrl;
    bool view = false;
    int min = 1, max = 99999999;
    Random rnd = new Random();
    int HASHT = min + rnd.nextInt(max - min);
    int _current = 0;
    String image, tag, descript; //context;
    setState(() {

      user.profilePictureURL;
    });
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
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
                      'Find Your\nSwag',
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
                            backgroundImage: NetworkImage('$image_to_print'),
                            backgroundColor: Colors.white,
                          ))) : InkWell(
                          child: Padding(
                              padding: EdgeInsets.only(top:20),
                              child:CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage('${user.profilePictureURL}'),
                            backgroundColor: Colors.white,
                          ))),
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
                  CarouselSlider(
                          options: CarouselOptions(
                            height: 240.0,
                            initialPage: 0,
                            autoPlay: true,
                            reverse: false,
                            enableInfiniteScroll: true,
                            autoPlayInterval: Duration(seconds: 5),
                            autoPlayAnimationDuration: Duration(
                                milliseconds: 3500),
                            scrollDirection: Axis.horizontal,
                          ),
                          items: images_collection.map((imgUrl) {
                            return Builder(
                              builder: (BuildContext context) {
                                return InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => CreateQuiz()
                                    ));
                                  },
                                    child:Container(
                                  width: MediaQuery
                                      .of(context)
                                      .size
                                      .width,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                                  child: ClipRRect(
                                   borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                );
                              },
                            );
                          }).toList(),
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
              new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: displayHeight(context) * 0.95,
              child:new FutureBuilder(
                    future: getData(),
                    builder: (_, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              return /*SingleChildScrollView(
                                child:Text("${snapshot.data[index].data()['quizTitle']}", style: TextStyle(color:Colors.black)),
                              );*/
                              QuizTile(
                                noOfQuestions: snapshot.data.length,
                                imageUrl:
                                snapshot.data[index].data()['quizImgUrl'],
                                title:
                                snapshot.data[index].data()['quizTitle'],
                                description:
                                snapshot.data[index].data()['quizDesc'],
                                quizId: snapshot.data[index].data()["quizId"],

                              );
                            }
                        );
                      }
                      return Text("Loading... Please wait");
                    }
                ),),
            ],
         ),
            ],
          ),
        ),
      ),
    );
  }

  void getDataFromFirebaseAndBuildList() {
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
  }

  void getDataFromFirebaseAndBuildCarousel(int d) {
    databaseReference.once().then((DataSnapshot snapshot) { //получаем данные
      var keys = snapshot.value['PromoToday'].keys; //получаем ключи
      var values = snapshot.value['PromoToday']; //получаем значения
      for (var key in keys) {
        images_collection.add(values[key]);
      }
      d == 1 ? setState(() {}) : print(d);
    }
    );
  }

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

}



class QuizTile extends StatelessWidget {
  final String imageUrl, title, quizId, description;
  final int noOfQuestions;

  QuizTile(
      {@required this.title,
        @required this.imageUrl,
        @required this.description,
        @required this.quizId,
        @required this.noOfQuestions,});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => QuizPlay(quizId)
        ));
      },
      child: new Card(
        color: Colors.white,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment
                .stretch,
            children: <Widget>[
              InkWell(
                borderRadius: BorderRadius
                    .circular(20),
          child: new ClipRect(        //блюр карточки не работает
                child: new BackdropFilter(
                  filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                  child:Container(
                  alignment: Alignment.center,
                  height: 250,
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.only(
                      bottom: 20),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius
                          .circular(20),
                      image: DecorationImage(
                          image: NetworkImage(
                              '${imageUrl}'),
                          fit: BoxFit.cover
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors
                                .white,
                            blurRadius: 10,
                            offset: Offset(0,
                                10)
                        )
                      ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .stretch,
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween,
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .start,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment
                                  .start,
                              children: <
                                  Widget>[
                                FadeAnimation(
                                    1, Text(
                                  '${title}',
                                  style: TextStyle(
                                      color: Colors
                                          .black,
                                      fontSize: 30,
                                      fontWeight: FontWeight
                                          .bold),)),
                                SizedBox(
                                  height: 10,),
                                FadeAnimation(
                                    1.1, Text(
                                  '$description',
                                  style: TextStyle(
                                      color: Colors
                                          .black,
                                      fontSize: 20),)),

                              ],
                            ),
                          ),
                          FadeAnimation(
                              1.2, Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                                shape: BoxShape
                                    .circle,
                                color: Colors
                                    .white
                            ),
                            child: InkWell(
                              child: Center(
                                child: Icon(
                                    Icons
                                        .favorite_border,
                                    color: Colors
                                        .red,
                                    size: 20),
                              ),
                            ),
                          ))
                        ],
                      ),
                      // пример карточки и визуала
                    ],
                  ),
                ),
                ),
          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
