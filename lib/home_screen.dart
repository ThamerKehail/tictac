import 'package:flutter/material.dart';

import 'game_logic.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String activePlayer = "x";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  Game game = Game();
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: MediaQuery.of(context).orientation == Orientation.portrait?Column(
          children: [
            ...fistBlock(),
            _expanded(context),
            ...lastBlock(),
          ],
        ):Row(
          children: [
            Column(
              children: [
                ...fistBlock(),
                ...lastBlock(),
              ],

            ),
            _expanded(context),
          ],
        ),
      ),
    );
  }

  List<Widget> fistBlock() {
    return [
      SwitchListTile.adaptive(
        value: isSwitched,
        onChanged: (bool newval) {
          setState(() {
            isSwitched = newval;
          });
        },
        title: Text(
          "Turn on/off two player",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Text(
        "It's $activePlayer turn".toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 52,
        ),
        textAlign: TextAlign.center,
      ),
    ];
  }

  List<Widget> lastBlock() {
    return [
      Text(
        result,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 42,
        ),
        textAlign: TextAlign.center,
      ),
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            Player.playerO = [];
            Player.playerX = [];
            activePlayer = "x";
            gameOver = false;
            turn = 0;
            result = "";
          });
        },
        icon: Icon(Icons.replay),
        label: Text("Repeat the game"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.teal),
        ),
      )
    ];
  }

  Expanded _expanded(BuildContext context) {
    return Expanded(
        child: GridView.count(
      padding: EdgeInsets.all(16),
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 1.0,
      crossAxisCount: 3,
      children: List.generate(
          9,
          (index) => InkWell(
                borderRadius: BorderRadius.circular(10.0),
                onTap: gameOver ? null : () => _onTap(index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text(
                      Player.playerX.contains(index)
                          ? "X"
                          : Player.playerO.contains(index)
                              ? 'o'
                              : '',
                      style: TextStyle(
                          color: Player.playerX.contains(index)
                              ? Colors.red
                              : Colors.pinkAccent,
                          fontSize: 52),
                    ),
                  ),
                ),
              )),
    ));
  }

  _onTap(int index) {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, activePlayer);
      updateState();
      if (!isSwitched && !gameOver && turn != 9) {
        game.autoPlay(activePlayer);
        updateState();
      }
    }
  }

  void updateState() {
    setState(() {
      activePlayer = activePlayer == 'x' ? 'o' : 'x';
      String winnerPlayer = game.checkWinner();
      turn++;

      if (winnerPlayer != "") {
        gameOver = true;
        result = "$winnerPlayer is the winner";
      } else if (!gameOver && turn == 9) {
        result = "It's Draw";
      }
    });
  }
}
