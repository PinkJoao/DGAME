import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'mylib.dart';

class GamePage extends StatefulWidget {
  final Set<String> players;

  const GamePage({
    Key? key,
    required this.players,
  }) : super(key: key);

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  
  ScrollController carouselController = ScrollController();

  @override
  void initState() {
    super.initState();
    //requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
        height: getTotalHeight(context),
        width: getTotalWidth(context),
        child: Stack(
          fit: StackFit.expand,
          children: [
            //for(Color color in Colors.primaries)
            Container(                                                            // LAYER 00
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: getTotalHeight(context),
              width: getTotalHeight(context),
              child: SingleChildScrollView(
                controller: carouselController,
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for(Color color in Colors.primaries + Colors.primaries)
                      Container(
                        width: getTotalWidth(context),
                        color: color,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                
                              },
                              child: Text('prev'),
                            ),

                            ElevatedButton(
                              onPressed: () {
                                carouselController.animateTo(150, duration: Duration(milliseconds: 500), curve: Curves.linear); // adaptar
                              },
                              child: Text('next'),
                            ),
                          ]
                        ),
                      )
                  ],
                ),
              ),
            ),

            Container(                                                            // LAYER 01
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: getTotalHeight(context),
              width: getTotalHeight(context),
              child: Center(),
            ),

            Container(                                                            // LAYER 02
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: getTotalHeight(context),
              width: getTotalHeight(context),
              child: Center(),
            ),

            Container(                                                            // LAYER 03
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: getTotalHeight(context),
              width: getTotalHeight(context),
              child: Center(),
            ),

            Container(                                                            // LAYER 04
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: getTotalHeight(context),
              width: getTotalHeight(context),
              child: Center(),
            ),

            Container(                                                            // LAYER 05
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              height: getTotalHeight(context),
              width: getTotalHeight(context),
              child: Center(),
            )
          ],
        ),
      ),
    );
  }
}