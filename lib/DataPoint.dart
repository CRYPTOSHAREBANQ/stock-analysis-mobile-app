// ignore: file_names
class DataPoint {
  final String heading;
  final String description ;
  final dynamic point;
  final String analysis;
  final bool finalAnalysis;

  DataPoint({ required this.heading,required this.description, required this.point, required this.analysis,required this.finalAnalysis});

  String getHeading() {
    return heading;
  }

  void setHeading(String heading) {
    heading = heading;
  }
}
