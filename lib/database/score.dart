import 'package:flutter/widgets.dart';

class Score extends ChangeNotifier{
  int score = 0;
  void incrementScore(int value){
    score = score + value;
  }
  void setScore(){
    score = 0;
  }
  int get getScore => score;
}