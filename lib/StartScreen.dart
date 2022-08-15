import 'dart:convert';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'QuestionsScreen.dart';

void main() {
  runApp(const StartScreen());
}

class StartScreen extends StatelessWidget {
  const StartScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter DropDownButton',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  static const String initialLanguageValue = "Pick Language";
  static const String initialDropdownValue = "Pick Currency";

// Initial Selected Value
  String languageDropdownValue = initialLanguageValue;
  String currencyDropdownValue = initialDropdownValue;

  int languageCredits = 0;
  int currencyCredits = 0;
  int credits = 0;

// List of items in our dropdown menu
  var languageDropdownItems = [
    initialLanguageValue
  ];

  var currencyDropdownItems = [
    initialDropdownValue
  ];

  @override
  void initState() {
    super.initState();
    // Do something amazing
    fetchData();
  }

  fetchData() async {
   var currencies = await getCurrencies();
   var languages = await getLanguages();
   languageDropdownItems = languageDropdownItems + languages;
   currencyDropdownItems = currencyDropdownItems + currencies;
  }

  getLanguages() async {
    var jsonText = await rootBundle.loadString('assets/resources/languages.json');
    var jsonResponse = json.decode(jsonText);
    List languages = jsonResponse.toList();
    List<String> languagesList = [];
    for (var i = 0; i < languages.length; i++) {
      languagesList.add(languages[i]["name"] as String);
    }
    return languagesList;
  }

  getCurrencies() async {
    var jsonText = await rootBundle.loadString('assets/resources/currencies.json');
    var jsonResponse = json.decode(jsonText);
    List<String> currencies = jsonResponse.keys.toList();
    currencies = currencies.map((currency)=>currency.toUpperCase()).toList();
    return currencies;
  }

  sendForm() async {
    if (languageDropdownValue == initialLanguageValue ||
        currencyDropdownValue == initialDropdownValue) {
      print("ERROR");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("language", languageDropdownValue);
    await prefs.setString("currency", currencyDropdownValue);

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const QuestionsPage(title: 'Flutter Demo Home Page')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Start Page"),
      ),
      body: Center(
        child: FractionallySizedBox(
          heightFactor: 1,
          widthFactor: 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.only(top: 10.0, bottom: 8.0)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Image.asset(
                    'assets/images/cryptocoin_temporal.png',
                    fit: BoxFit.contain,
                    width: 40),
                  Text(" + $credits", style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 50.0, bottom: 8.0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: DropdownButton(
                    isExpanded:true,

                    // Initial Value
                    value: languageDropdownValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: languageDropdownItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      if (newValue == initialLanguageValue) {
                        languageCredits = 0;
                      } else {
                        languageCredits = 1;
                      }
                      credits = languageCredits + currencyCredits;

                      setState(() {
                        languageDropdownValue = newValue!;
                      });
                    },
                  )),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: DropdownButton(
                    isExpanded:true,

                    // Initial Value
                    value: currencyDropdownValue,

                    // Down Arrow Icon
                    icon: const Icon(Icons.keyboard_arrow_down),

                    // Array list of items
                    items: currencyDropdownItems.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      if (newValue == initialDropdownValue) {
                        currencyCredits = 0;
                      } else {
                        currencyCredits = 2;
                      }
                      credits = languageCredits + currencyCredits;

                      setState(() {
                        currencyDropdownValue = newValue!;
                      });
                    },
                  )),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 50.0, bottom: 50.0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: Text(
                    'Lets Calculate your Wealth Score!',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),),
                  Padding(padding: const EdgeInsets.only(left: 10.0)),
                ],
              ),
              Padding(padding: const EdgeInsets.only(top: 8.0, bottom: 8.0)),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(child: ElevatedButton(
                    style: ButtonStyle(
                      elevation: MaterialStateProperty.resolveWith<double?>(
                              (Set<MaterialState> states) {
                            if (states.contains(MaterialState.pressed))
                              return 16;
                            return null;
                          }),
                    ),
                    onPressed: sendForm,
                    child: Text('Start'),
                  ),),
                  Padding(padding: const EdgeInsets.only(left: 10.0)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

