import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cube/flutter_cube.dart';

class Graph2D extends StatefulWidget {
  Graph2D({super.key});

  @override
  State<Graph2D> createState() => _Graph2DState();
}

class _Graph2DState extends State<Graph2D> {
  List<MaterialColor> colorList = [
    Colors.red,
    Colors.orange,
    Colors.amber,
    Colors.green,
    Colors.lightGreen
  ];

  @override
  Widget build(BuildContext context) {
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
                itemCount: 25,
                itemBuilder: (BuildContext context, int index) {
                  print(index);
                  return Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Container(
                      height: 10,
                      width: 10,
                      color: (index != 0 ||
                              index != 6 ||
                              index != 12 ||
                              index != 18 ||
                              index != 24)
                          ? colorList[Random().nextInt(5)]
                          : colorList[0],
                      child: Center(child: Text('')),
                    ),
                  );
                }),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.refresh),
          onPressed: () {
            setState(
              () {},
            );
          },
        ));
  }
}

class TestGraph extends StatelessWidget {
  const TestGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return Graph2D();
  }
}
