import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music/anims/FadeAnimation.dart';
import 'package:music/services/helper.dart';
import 'package:music/ui/testModule/TestPage.dart';

Widget testCard({String testName, String img, BuildContext context, String description, String id}) {
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