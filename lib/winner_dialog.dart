import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class GameEndDialog extends StatelessWidget {
  final String winnerName;
  final void Function() replay;
  final void Function() undo;
  const GameEndDialog(
      {Key? key,
      required this.winnerName,
      required this.replay,
      required this.undo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          //background with winnerName
          Container(
            alignment: Alignment.center,
            height: 200,
            width: double.infinity,
            margin: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
              border: Border.all(width: 2),
            ),
            child: Text(
              winnerName,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            //padding: const EdgeInsets.only(top: 10),
          ),
          Positioned(
            top: -20,
            child: SvgPicture.asset("assets/trophy_new.svg", width: 100),
          ),
          Container(
            height: 200,
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                      onPressed: replay,
                      child: const Text("Replay",
                          style: TextStyle(fontWeight: FontWeight.bold))),
                ),
                TextButton(
                  onPressed: undo,
                  child: const Icon(Icons.undo),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
