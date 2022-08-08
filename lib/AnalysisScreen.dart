import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stock_analysis_app/DataPoint.dart';

ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue,
  minimumSize: const Size(100, 40),
  padding: const EdgeInsets.symmetric(horizontal: 20),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

Future<List<dynamic>> getAnalysis(String ticker) async {
  final response = await http.get(Uri.parse(
      'https://stockprediction-cnn.herokuapp.com/api/analysis?ticker=$ticker'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    var decode = jsonDecode(response.body);
    var decoded = jsonDecode(decode[0]) as Map<String, dynamic>;
    var newMap = <String, List>{};
    decoded.forEach((key, value) {
      newMap[key] = <dynamic>[];
      value.forEach((k, v) {
        newMap[key]!.add(v);
      });
    });
    return [newMap, decode[1]];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class AnalysisScreen extends StatefulWidget {
  final String ticker;

  const AnalysisScreen({super.key, required this.ticker});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreen(ticker: ticker);
}

class _AnalysisScreen extends State<AnalysisScreen> {
  final String ticker;

  List<dynamic> analysis = <dynamic>[];
  List<DataPoint> datapoint = <DataPoint>[];
  String companyName = "";

  _AnalysisScreen({required this.ticker});

  @override
  void initState() {
    super.initState();
    companyName = "Stock Analysis For ";
  }

  @override
  Widget build(BuildContext context) {
    final tickerController = TextEditingController();
    getAnalysis(ticker).then((value) {
      // print(value[0]["Heading"])
      analysis = value[0]['Heading'];
      List<DataPoint> list = <DataPoint>[];
      int i = 0;
      for (var value1 in analysis) {
        list.add(DataPoint(
            heading: value[0]['Heading'][i],
            description: value[0]['Description'][i],
            point: value[0]['Stock Data Point'][i],
            analysis: value[0]['Analysis'][i],
            finalAnalysis: value[0]['Final Analysis'][i]));
        i++;
      }
      setState(() {
        companyName+= value[1];
        datapoint = list;
      });
    });
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(companyName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: datapoint.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              )
            : Column(children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: datapoint.length - 1,
                    itemBuilder: (BuildContext ctx, int index) {
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: const Text("Description"),
                                  content: Text(datapoint[index].description),
                                );
                              });
                        },
                        child: Card(
                          color: datapoint[index].finalAnalysis
                              ? Colors.green
                              : Colors.redAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: datapoint[index].heading,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            'Value : ${datapoint[index].point}',
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: datapoint[index].analysis,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ]),
      ),
    );
  }
}
