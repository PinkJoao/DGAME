import 'dart:developer';
import 'package:dgame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:random_name_generator/random_name_generator.dart';

import 'mylib.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> players = [];
  int playerCount = 0;
  List<TextEditingController> controllers = [];
  TextEditingController playerInputController = TextEditingController();
  FocusNode focus = FocusNode();
  final randomNames = RandomNames(Zone.us);

  @override
  void initState() {
    super.initState();
    //requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [

            SizedBox(height: getTotalHeight(context)/2,),

            

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child:Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Expanded(
                    flex: 6,
                    child: TextField(
                      controller: playerInputController,
                      focusNode: focus,
                      onSubmitted: (value){
                        setState(() {
                          controllers.add(TextEditingController());
                          controllers.last.text = playerInputController.text;
                          players.add(playerInputController.text);
                          playerCount++;
                          if(playerInputController.text.isNotEmpty){
                            focus.requestFocus();
                            playerInputController.clear();
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Adicionar jogador ${players.length + 1}',
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 10,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            CupertinoIcons.person_add_solid,
                            color: Colors.pinkAccent,
                          ),
                          onPressed: (){
                            setState(() {
                              controllers.add(TextEditingController());
                              controllers.last.text = playerInputController.text;
                              players.add(playerInputController.text);
                              playerCount++;
                              if(playerInputController.text.isNotEmpty){
                                focus.requestFocus();
                                playerInputController.clear();
                              }
                            });
                              
                          }
                        )
                      ),
                    ),
                  ),

                  const SizedBox(width: 5,),
                  
                  Flexible(
                    child: IconButton(
                      icon: Stack(
                        children: [
                          Icon(
                            CupertinoIcons.play_circle_fill,
                            size: 32,
                            color: playerCount > 2 && players.toSet().length == players.length && !players.contains('') ? Colors.pinkAccent : null,
                          ),
                          if(playerCount > 2 && players.toSet().length == players.length && !players.contains(''))
                            Icon(
                              CupertinoIcons.play_circle,
                              size: 32,
                              color: playerCount > 2 && players.toSet().length == players.length && !players.contains('') ? Colors.white : null,
                            ),
                        ],
                      ),
                      
                      onPressed: playerCount > 2 && players.toSet().length == players.length && !players.contains('')
                        ? (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GamePage(
                                players: players.toSet()
                              ),
                            ),
                          );
                        }
                        : null,
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: playerCount > 2 && players.toSet().length == players.length && !players.contains('') ? Colors.pinkAccent : Colors.grey
                        ),
                      ), 
                      
                    ),
                  ),
                  
                ],
              ),
            ),

            for (int player = 0; player < playerCount; player ++)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: TextField(
                  controller: controllers[player],
                  onChanged: (value) {
                    setState(() {
                      players[player] = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Jogador ${player + 1}',
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey[600],
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.arrow_2_circlepath_circle_fill,
                          ),
                          onPressed: (){
                            setState(() {
                              controllers[player].text = randomNames.surname();
                              players[player] = controllers[player].text;
                            });
                          }
                        ),

                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.clear_circled_solid,
                          ),
                          onPressed: (){
                            setState(() {
                              playerCount--;
                              players.removeAt(player);
                              controllers.removeAt(player);
                            });
                          }
                        ),
                      ],
                    )
                    
                    
                    
                    
                    
                  ),
                ),
              ),


          ],
        ),
      ),
      
      
    );
  }
}