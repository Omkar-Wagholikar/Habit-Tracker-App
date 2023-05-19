import 'dart:math';
import 'package:flutter/material.dart';
import 'package:habit_monitor/themes/appColors.dart';

class Graph2D extends StatefulWidget {
  // Graph2D({Key key}) : super(key: key);

  @override
  _Graph2DState createState() => _Graph2DState();
}

class _Graph2DState extends State<Graph2D> {
  List<List<Color>> graphPalette = AppColors.graphPalette;
  int index = 0;
  List<double> l = [
    1.0,
    0.3202916865537976,
    0.17999626427407764,
    -0.5126791390432305,
    0.7022362436632085,
    0.3202916865537976,
    1.0,
    -0.48664795789851373,
    0.1821200603868802,
    -0.3392376228878216,
    0.17999626427407764,
    -0.48664795789851373,
    1.0000000000000002,
    -0.4557335899834292,
    0.7727175938901186,
    -0.5126791390432306,
    0.18212006038688025,
    -0.45573358998342917,
    1.0000000000000002,
    -0.7143383547878946,
    0.7022362436632084,
    -0.3392376228878216,
    0.7727175938901186,
    -0.7143383547878946,
    1.0,
  ];

  @override
  Widget build(BuildContext context) {
    List<Color> colorList = generateIntermediateColors(
        graphPalette[index][0], graphPalette[index][1], 101);
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1),
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          width: MediaQuery.of(context).size.width / 1.5,
          height: MediaQuery.of(context).size.width / 1.5,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            itemCount: l.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Container(
                  height: 10,
                  width: 10,
                  color: colorList[((l[index] + 1) * 50).round()],
                  child: Center(child: Text('')),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            // Generate new colors
            index = (index + 1) % (graphPalette.length);
            colorList = generateIntermediateColors(
                Colors.lightBlue[900]!, Colors.lightGreen, 101);
          });
        },
      ),
    );
  }

  static List<Color> generateIntermediateColors(
      Color color1, Color color2, int count) {
    List<Color> colors = [];

    double stepR = (color2.red - color1.red) / (count - 1);
    double stepG = (color2.green - color1.green) / (count - 1);
    double stepB = (color2.blue - color1.blue) / (count - 1);

    for (int i = 0; i < count; i++) {
      int red = (color1.red + stepR * i).round();
      int green = (color1.green + stepG * i).round();
      int blue = (color1.blue + stepB * i).round();

      Color color = Color.fromARGB(255, red, green, blue);
      colors.add(color);
    }

    return colors;
  }
}

class TestGraph extends StatelessWidget {
  // const TestGraph({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Graph2D();
  }
}
