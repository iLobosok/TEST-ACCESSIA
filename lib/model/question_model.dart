class QuestionModel{

  String question;
  String option1;
  String option2;
  String option3;
  String middleOption;
  String correctOption;
  bool answered;
  QuestionModel({this.answered, this.middleOption, this.question, this.correctOption, this.option1, this.option2, this.option3});
}