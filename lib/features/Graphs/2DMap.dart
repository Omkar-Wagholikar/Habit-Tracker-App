import 'package:flutter/material.dart';
import 'package:habit_monitor/themes/appColors.dart';

import '../../services/calculateCorrelation/calculateCorr.dart';

class Graph2D extends StatefulWidget {
  const Graph2D({super.key});

  @override
  _Graph2DState createState() => _Graph2DState();
}

class _Graph2DState extends State<Graph2D> {
  List<List<Color>> graphPalette = AppColors.graphPalette;
  int index = 0;
  late List<double> l;

  Future<void> assign() async {
    setState(() async {
      l = await ComputeCorrelation.computeCorrelation2Values();
    });
  }

  List<Widget> graphLabels = const [
    Text("A"),
    Text("B"),
    Text("C"),
    Text("D"),
    Text("E"),
  ];

  @override
  Widget build(BuildContext context) {
    assign();
    List<Color> colorList = generateIntermediateColors2(
        Colors.lightGreen, Colors.amber, Colors.red, 101);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.width / 1.5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: graphLabels,
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.black,
                        ),
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width / 1.5,
                        height: MediaQuery.of(context).size.width / 1.5,
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
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
                                child: Center(
                                  child: Text(
                                    "${((l[index] + 1) * 50).round() / 100}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.amber,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
              width: MediaQuery.of(context).size.width / 1.5,
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 5,
                childAspectRatio: 1.0,
                padding: const EdgeInsets.all(4.0),
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
                children: List.generate(
                  graphLabels.length,
                  (index) => graphLabels[index],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            index = (index + 1) % (graphPalette.length);
            colorList = generateIntermediateColors(
              Colors.lightBlue[900]!,
              Colors.lightGreen,
              101,
            );
          });
        },
      ),
    );
  }

  static List<Color> generateIntermediateColors(
    Color color1,
    Color color2,
    int count,
  ) {
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

  static List<Color> generateIntermediateColors2(
    Color color1,
    Color color2,
    Color color3,
    int count,
  ) {
    List<Color> colors = [];

    double stepR1 = (color2.red - color1.red) / (count / 2 - 1);
    double stepG1 = (color2.green - color1.green) / (count / 2 - 1);
    double stepB1 = (color2.blue - color1.blue) / (count / 2 - 1);

    double stepR2 = (color3.red - color2.red) / (count / 2 - 1);
    double stepG2 = (color3.green - color2.green) / (count / 2 - 1);
    double stepB2 = (color3.blue - color2.blue) / (count / 2 - 1);

    for (int i = 0; i < count / 2; i++) {
      int red = (color1.red + stepR1 * i).round();
      int green = (color1.green + stepG1 * i).round();
      int blue = (color1.blue + stepB1 * i).round();

      Color color = Color.fromARGB(255, red, green, blue);
      colors.add(color);
    }

    for (int i = 0; i <= count / 2; i++) {
      int red = (color2.red + stepR2 * i).round();
      int green = (color2.green + stepG2 * i).round();
      int blue = (color2.blue + stepB2 * i).round();

      Color color = Color.fromARGB(255, red, green, blue);
      colors.add(color);
    }

    return colors;
  }
}

class TestGraph extends StatelessWidget {
  const TestGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Graph2D();
  }
}
