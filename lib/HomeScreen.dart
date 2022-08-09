import 'package:flutter/material.dart';
import 'package:stock_analysis_app/AnalysisScreen.dart';

ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: Colors.blue,
  minimumSize: const Size(100, 40),
  padding: const EdgeInsets.symmetric(horizontal: 20),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(2)),
  ),
);

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var tickerController = TextEditingController();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Stock Analysis Application"),
        ),
        body: Center(
          child: Column(
            children: [
              const Image(
                  width: 400,
                  height: 200,
                  image: AssetImage(
                    'assets/images/cryptoshare.png',
                  )),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                    child: Text("Enter Stock Ticker Symbol"),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                child: TextField(
                    controller: tickerController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                        hintText: "Ticker Symbol eg:AAPL",
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ))),
              ),
              ElevatedButton(
                style: raisedButtonStyle,
                onPressed: () {
                  if (tickerController.text.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AnalysisScreen(ticker: tickerController.text),
                      ),
                    );
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext ctx) {
                          return const AlertDialog(
                            title: Text("Error Message"),
                            content: Text("Ticker Symbol can not be empty"),
                          );
                        });
                  }
                },
                child: const Text('Get Analysis'),
              )
            ],
          ),
        ));
  }
}
