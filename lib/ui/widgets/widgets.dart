import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music/anims/FadeAnimation.dart';
import 'package:music/database/score.dart';
import 'package:music/services/helper.dart';
import 'package:music/ui/testModule/TestPage.dart';
import 'package:provider/src/provider.dart';

Widget testCard({String testName, String img, BuildContext context, String description, String id,}) {
  return Card(
    color: Colors.transparent,
    child: Center(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              alignment: Alignment.center,
              height: getHeight(context: context, factor: 0.3),
              width: double.infinity,
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: NetworkImage('$img'),
                      fit: BoxFit.cover
                  ),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[900],
                        blurRadius: 10,
                        offset: Offset(0, 10)
                    )
                  ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start,
                          children: <Widget>[
                            FadeAnimation(1, Text('$testName',
                              style: TextStyle(color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),)),
                            SizedBox(height: 10,),


                          ],
                        ),
                      ),
                      FadeAnimation(1.2, Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white
                        ),
                        child: InkWell(
                          child:Center(
                            child: Icon(
                              Icons.favorite_border, size: 20,),
                          ),
                        ),
                      ))
                    ],
                  ), // пример карточки и визуала
                ],
              ),
            ),
            onTap: () {
              context.read<Score>().setScore();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                     TestPage(id: id)
                  )
              );
            },
          ),

        ],
      ),
    ),
  );
}




Widget Question({@required BuildContext context, @required String title, @required List<dynamic> a1,  @required List<dynamic> a2,  @required List<dynamic> a3 }){
  bool isAnswered = false;
  StreamController<Color> color1  = new StreamController<Color>();
  StreamController<Color> color2  = new StreamController<Color>();
  StreamController<Color> color3  = new StreamController<Color>();
  final snackBar = SnackBar(content: Text('You already answered for this question!'), backgroundColor: Colors.red, duration: Duration(milliseconds: 500),);
  void addScore(var value, int streamNumber){
    if(isAnswered == true){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    if(isAnswered == false) {
      isAnswered = true;
      context.read<Score>().incrementScore(int.parse(value));
      switch(streamNumber){
        case 1:
          color1.add(Colors.green);
          break;
        case 2:
          color2.add(Colors.green);
          break;
        case 3:
          color3.add(Colors.green);
      }

    }
  }
  return Container(
      padding: EdgeInsets.symmetric(horizontal: getWidth(context: context, factor: 0.00)),
      width: getWidth(context: context, factor: 1.2),
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
                      title,
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
                    StreamBuilder<Object>(
                      stream: color1.stream,
                      builder: (context, snapshot) {
                        return SizedBox(
                          height: getHeight(context: context, factor: 0.08),
                          child: TextButton(

                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(snapshot.data),
                                  shape:  MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(width: 2.0, style: BorderStyle.solid, color: Colors.black),
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                  )
                              ),
                              onPressed: (){
                                    addScore(a1[1], 1);
                                    color1.add(Colors.green);
                              },
                              child: Text(
                                  a1[0],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  )
                              )
                          )
                        );
                      }
                    ),
                    SizedBox(height: getHeight(context: context, factor: 0.02),),
                    StreamBuilder<Color>(
                      stream: color2.stream,
                      builder: (context, snapshot) {
                        return SizedBox(
                          height: getHeight(context: context, factor: 0.08),
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(snapshot.data),
                                  shape:  MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(width: 2.0, style: BorderStyle.solid, color: Colors.black),
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                  )
                              ),

                              onPressed: () => addScore(a2[1], 2),

                              child: Text(
                                  a2[0],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  )
                              )
                          )
                        );
                      }
                    ),
                    SizedBox(height: getHeight(context: context, factor: 0.02),),
                    StreamBuilder<Color>(
                      stream: color3.stream,
                      builder: (context, snapshot) {
                        return SizedBox(
                          height: getHeight(context: context, factor: 0.08),
                          child: TextButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(snapshot.data),
                                  shape:  MaterialStateProperty.all<OutlinedBorder>(
                                    RoundedRectangleBorder(
                                      side: BorderSide(width: 2.0, style: BorderStyle.solid, color: Colors.black),
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                    ),
                                  )
                              ),
                              onPressed: (){
                                addScore(a3[1], 3);
                              },
                              child: Text(
                                  a3[0],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 17,
                                  )
                              )
                          )
                        );
                      }
                    ),
                    SizedBox(height: getHeight(context: context, factor: 0.02),),

                  ],
                ),
              )
            ],
          )
      )
  );
}
