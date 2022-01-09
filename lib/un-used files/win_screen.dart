import 'package:chess_game/backend%20files/model.dart';
import 'package:flutter/material.dart';

class GameEndScreen extends StatelessWidget {
  final Player winner;
  const GameEndScreen({Key? key, required this.winner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(" ")),
      body: Center(
          child: Text(
              (winner == Player.Player1) ? "Black Wins !" : "White Wins !")),
    );
  }
}
