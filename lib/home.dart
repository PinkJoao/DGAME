import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_icons/cupertino_icons.dart';
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

  @override
  void initState() {
    super.initState();
    //requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /*Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    'Cadastro de jogadores',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
                )
              ),*/

              Padding(
                padding: EdgeInsets.fromLTRB(0, getTotalHeight(context)/4, 0, 5),
                child: Image.asset('assets/images/logo.png'),
              ),

              

              Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: ElevatedButton(
                  onPressed: playerCount > 2
                    ? (){

                    }
                    : null,
                  style: ElevatedButton.styleFrom(
                    side: playerCount > 2
                      ? const BorderSide(
                        width: 3.0,
                        color: Color.fromARGB(50, 255, 64, 128),
                      )
                      : null,
                  ),
                  child: Text(
                    'JOGAR',
                    style: playerCount > 2
                      ? TextStyle(
                        fontSize: getTotalWidth(context)/ 20,
                      )
                      : null
                  )
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
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
                      suffixIcon: IconButton(
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
                      )
                    ),
                  ),
                ),


            ],
          ),
        ),
      )
      
    );
  }
}