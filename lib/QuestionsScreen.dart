import 'dart:convert';
import 'package:conditional_questions/conditional_questions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'StartScreen.dart';

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
      home: QuestionsPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

List<Question> questions(String savingsAmount, String currency) {
  return [
    PolarQuestion(
        question: "Do you have $savingsAmount $currency in Savings? ",
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


class _QuestionsPageState extends State<QuestionsPage> {
  final _key = GlobalKey<QuestionFormState>();

  String savingsAmount = "[loading]";
  String currency = "";
  int credits = 3;

  @override
  void initState(){
    super.initState();
    getInitialData();
  }

  void getInitialData() async {
    // Get currency.
    final prefs = await SharedPreferences.getInstance();
    currency = prefs.getString('currency') ?? 'USD';

    // Get savings amount.
    const double minSavings = 10000;
    double newAmount = await getCurrencyExchange(minSavings, currency.toString());
    savingsAmount = newAmount.toStringAsFixed(2);

    // Force loading.
    setState(() {
      currency;
      savingsAmount;
    });
  }

  getCurrencyExchange(double amount, String currency) async {
    var endpoint = "https://api.exchangerate.host/convert?from=USD&to=" + currency;
    var url = Uri.parse(endpoint);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      var jsonResponse = json.decode(response.body);
      var rate = jsonResponse["info"]["rate"];
      if (rate == null) {
        this.currency = "USD";
        return amount;
      }
      return amount * rate;
    } else {
      // If that response was not OK, throw an error.
      print('Failed to load post');
      return amount;
    }
  }

  validateQuestions () async {
    if (_key.currentState!.validate()) {
      var questionElements = _key.currentState!.getElementList().toList();
      var counter = 0;
      for (int i = 0; i < questionElements.length; i++){
        if (questionElements[i].answer != null && questionElements[i].answer == "Yes") {
          counter += 1;
        }
      }

      if (counter == questionElements.length) {
        credits += 16;
        _alertAllQuestions(context);

      } else {
        credits += 3;
        _alertSomeQuestions(context);
      }
    }
    print(credits);

    // Add the credits widget on top AND bottom.
  }


  _alertAllQuestions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Congrats'),
            content: Text('You have officially started Building Wealth'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));
                },
                child: Text('Return', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        );
      },
    );
  }

  _alertSomeQuestions(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Expanded(
          child: AlertDialog(
            title: Text('Congrats'),
            content: Text('Thanks for taking Our Survey. Now its time to Build Wealth!'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));
                },
                child: Text('Return', style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
            child: FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 0.9,
                          child: ConditionalQuestions(
                            key: _key,
                            children: questions(savingsAmount, currency),
                            trailing: [
                              MaterialButton(
                                color: Colors.lightBlue,
                                splashColor: Colors.blueAccent,
                                onPressed: validateQuestions,
                                child: Text("Submit"),
                              )
                            ],
                          ),
                        ),
                  ),
              );
  }



}