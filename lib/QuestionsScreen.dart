import 'package:conditional_questions/conditional_questions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _key = GlobalKey<QuestionFormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: ConditionalQuestions(
        key: _key,
        children: questions(),
        trailing: [
          MaterialButton(
            color: Colors.lightBlue,
            splashColor: Colors.blueAccent,
            onPressed: () async {
              if (_key.currentState!.validate()) {
                print("validated!");
              }
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
List<Question> questions() {
  return [
    PolarQuestion(
        question: "Do you have 10,000  in Savings? ",
        answers: ["Yes", "No"],
        isMandatory: true),
    PolarQuestion(
        question: "Do you Have a Life Insurance Policy?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Do you have a Will or Trust?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Do You Invest in Stocks?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Do you do your Own Taxes?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Do you Own Cryptocurrency?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Do you own (No Rent or Mortgage) any Land, House, or Apartment?",
        answers: ["Yes", "No"]),
    PolarQuestion(
        question: "Do you Own any Gold or Silver Bars?",
        answers: ["Yes", "No"]),
  ];
}