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
          child:  new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[/*
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Positioned(
                      right:110,
                      child:CachedNetworkImage(
                        imageUrl: "${user.profilePictureURL}",
                        alignment: Alignment.center,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.account_circle),
                      ),
                    ),
                    Text(
                      'Find Your',
                      style: TextStyle(color: Colors.black87, fontSize: 25),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Swag',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 35,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              SizedBox(
                height: 1,
              ),*/
             CarouselSlider(
                          options: CarouselOptions(
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
                                    //borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imgUrl,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                );
                              },
                            );
                          }).toList(),
                        ),
         new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
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
                child: Container(
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
                                  '$description}',
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
                                    .grey[300]
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
            ],
          ),
        ),
      ),
    );
  }
}
