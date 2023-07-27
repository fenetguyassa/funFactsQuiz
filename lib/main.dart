
import 'package:facts_quiz/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

Future <void> main() async {
  runApp(MaterialApp(home: MyApp()));

} 

class MyApp extends StatelessWidget {

  @override 
  Widget build (BuildContext context){
    return MaterialApp(
      home: MyHomePage()
    ,);
  }
}

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
  
}
  
class MyHomePageState extends State <MyHomePage>{

  late String name;
  final TextControllers textControllers = Get.put(TextControllers());

  bool firstpage = true;

  var questionIndex_ = 0;
  var maxIndex = 4;
  var resultScore_ = 0;

  void update_(int score) {  
    resultScore_ += score;

    setState(() {
      questionIndex_++;
      });
  
  } 

@override
Widget build(BuildContext context) {
  return Scaffold(
      body: Container(
        //padding: const EdgeInsets.fromLTRB(275, 60, 275, 500),
        decoration: const BoxDecoration(color: Color.fromRGBO(164, 164, 164, 0.4)),
        child: 
          firstpage ?
          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80, right: 80, top: 10, bottom: 10),
              child: TextField(
              style: TextStyle(fontSize: 40.0, color: Colors.black),
              keyboardType: TextInputType.name,
              controller: textControllers.userName.value,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(width: 0, style: BorderStyle.none)),
                hintText: 'Enter Your Name',
                hintStyle: TextStyle(fontSize: 40.0, color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                //contentPadding: EdgeInsets.only(left: 5, right: 5, bottom: 30, top: 30), 
                //border: InputBorder.none
              ),
            )),
            SizedBox(height: 30),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                minimumSize: MaterialStateProperty.all(Size(350, 125)),
                foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.yellow),
                elevation: MaterialStateProperty.resolveWith<double>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.hovered))
                    return 5.0;
                    return 0;
                  }
                )
              ),
              onPressed:() {
                  setState(() {
                    firstpage = false;
                  });
              },
            child: const Text('Start Quiz', style: TextStyle(fontSize: 40.0, color: Colors.black),)),          ],
          )
          :
          Center(
            child: questionIndex_ <= maxIndex ? 
              Quiz(
                update: update_, 
                currentScore: resultScore_, 
                questionIndex: questionIndex_,) 
              : Result(resultScore: resultScore_,)
            )
          )
        );
  }

}

class Quiz extends StatelessWidget {
  
  final Function update;
  final int currentScore;
  final int questionIndex;

  Quiz ({
    Key? key, 
    required this.update,
    required this.currentScore,
    required this.questionIndex}) : super (key: key);

  
  @override
  Widget build(BuildContext context){
    return Column( //start here
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
          Question(
            questionText: questions[questionIndex]['questionText'].toString(), 
            title: questions[questionIndex]['title'].toString(), 
            ),
            SizedBox(height: 10),
            ...(questions[questionIndex]['answers'] as List<Map<String, Object>>)
            .map((answer) {
            return Answer(
              selectHandler: () => update(answer['score']), answerText: answer['text'].toString());
            }).toList(),
            SizedBox(height: 70),
            Container(
            height: 35,
            width: 200,
            child:
              RichText(
                text: TextSpan(
                  text: 'Score: ',
                  style: TextStyle(color: Colors.red, fontSize: 35),
                  children: <TextSpan> [
                    TextSpan(
                      text: '$currentScore/$questionIndex',
                      style: TextStyle(color: Colors.red, fontSize: 35),
                    )
                  ]
                ),),),
        ],);
  }

  final List<Map<String, Object>> questions = [
    {'title': 'Question 1', 
    'questionText': '1. What is the capital city of Ethiopia?', 
    'answers': [
      {'text': 'A. Paris', 'score': 0}, 
      {'text': 'B. Addis Ababa', 'score': 1},
      {'text': 'C. Nairobi', 'score': 0}, 
      {'text': 'D. None', 'score': 0}]},
    {'title': 'Question 2',
    'questionText': 'Which one of the following is the largest country in the world',
    'answers': [
      {'text': 'A. Russia', 'score': 1}, 
      {'text': 'B. USA', 'score': 0},
      {'text': 'C. Canada', 'score': 0}, 
      {'text': 'D. China', 'score': 0}]},
    {'title': 'Question 3',
    'questionText': 'What is the highest mountain in the world',
    'answers': [
      {'text': 'A. Entoto Mountain', 'score': 0}, 
      {'text': 'B. Kanchenjunga', 'score': 0},
      {'text': 'C. Tossa Mountain', 'score': 0}, 
      {'text': 'D. Mount Everest', 'score': 1}]},
    {'title': 'Question 4',
    'questionText': 'How many bones does the average adult have?',
    'answers': [
      {'text': 'A. 300', 'score': 0}, 
      {'text': 'B. 270', 'score': 0},
      {'text': 'C. 325', 'score': 0}, 
      {'text': 'D. 206', 'score': 1}]},
    {'title': 'Question 5',
    'questionText': 'Who was the first US President?',
    'answers': [
      {'text': 'A. Thomas Edison', 'score': 0}, 
      {'text': 'B. George Washington', 'score': 1},
      {'text': 'C. Benjamin Franklin', 'score': 0}, 
      {'text': 'D. Barack Obama', 'score': 0}]},
  ];
}

class Question extends StatelessWidget{
  
  final String questionText;
  final String title;

  Question({
    Key? key, 
    required this.title,
    required this.questionText,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 50, color: Colors.black)
          ),
          SizedBox(height: 70,),
          Text(
            questionText,
            style: TextStyle(fontSize: 45, color: Colors.black)
          )
          ]
    );
  }
}

class Answer extends StatelessWidget {
  final Function selectHandler;
  final String answerText;
  
  const Answer({required this.selectHandler, required this.answerText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Center(
        child: Container(
        //alignment: AlignmentDirectional(-0.3, 0),
        child: OutlinedButton(
          style: ButtonStyle(
            side: MaterialStateProperty.all(BorderSide.none),
            minimumSize: MaterialStateProperty.all(Size(150, 30)),
          ),
          onPressed: () {
            selectHandler();
          },
          child: Text(answerText, style: TextStyle(fontSize: 40, color: Colors.black), textAlign: TextAlign.left, textDirection: TextDirection.ltr) 
        )
        )
    );
  }

}

class Result extends StatelessWidget {

  final int resultScore;
  final TextControllers textControllers = Get.put(TextControllers());

  Result({Key? key, required this.resultScore}) : super (key: key);

  String get status {
    String text;
    if(resultScore >= 3){
      text = 'Passed';
    } else {
      text = 'Failed';
    }
    return text;
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Thank you,', style: TextStyle(color: Colors.black, fontSize: 35)),
        Text(textControllers.userName.value.text, style: TextStyle(color: Colors.black, fontSize: 35)),
        SizedBox(height: 30),
        Text('Questions: 5', style: TextStyle(color: Colors.red, fontSize: 35)),
        Container(
            height: 35,
            width: 200,
            child:
              RichText(
                text: TextSpan(
                  text: '  Correct: ',
                  style: TextStyle(color: Colors.red, fontSize: 35),
                  children: <TextSpan> [
                    TextSpan(
                      text: '$resultScore',
                      style: TextStyle(color: Colors.red, fontSize: 35),
                    )
                  ]
                ),),),
        SizedBox(height: 15),
        Text(status, style: TextStyle(color: Colors.red, fontSize: 35)),
      ],
    );
  }
}