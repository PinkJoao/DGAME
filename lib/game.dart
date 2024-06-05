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
  CarouselController carouselController = CarouselController();

  @override
  void initState() {
    super.initState();
    //requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              CarouselSlider(
                items: <Widget>[
                  
                  for(Color color in Colors.primaries)
                    Container(
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),

                ],
                carouselController: carouselController,
                options: CarouselOptions(
                  aspectRatio: 9/16,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    if(index == 17){
                      
                    }
                  },
                ),
              ),

              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: (){

                    }, 
                    icon: Icon(CupertinoIcons.back)
                  ),

                  IconButton(
                    onPressed: (){

                    }, 
                    icon: Icon(CupertinoIcons.forward)
                  ),
                ],
              )

            ],
          ),
        )
      ),
    );
  }
}