import 'package:chess_game/backend%20files/chess_data.dart';
import 'package:chess_game/backend%20files/model.dart';
import 'package:chess_game/mygrid.dart';
import 'package:chess_game/winner_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import './chess_widget.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late List<ChessData> history;
  late ChessData chessData;
  late bool isPlayerChanged;
  bool isGameEnd = false;

  @override
  void initState() {
    super.initState();
    history = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    chessData = Provider.of<ChessData>(context);
    isPlayerChanged = history.isEmpty ||
        (history.last.currentlyPlaying != chessData.currentlyPlaying);
    if (isPlayerChanged) {
      history.add(ChessData.copy(chessData));

      //logic for checking end of game and displaying winner.
      List<ChessPiece> killedPiece =
          (chessData.currentlyPlaying == Player.Player1)
              ? chessData.killedPieceOfPlayer1
              : chessData.killedPieceOfPlayer2;
      for (ChessPiece chessPiece in killedPiece) {
        //whether king is present in kill chess piece list
        if (PieceType.king == chessPiece.pieceType) {
          isGameEnd = true;
          break;
        }
      }
      if (isGameEnd) {
        String winnerName = (chessData.currentlyPlaying == Player.Player1)
            ? "White Wins !"
            : "Black Wins !";
        print(winnerName);
        displayWinnerDialog(context, winnerName);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  //show name of winner either black or white
  void displayWinnerDialog(BuildContext context, String winnerName) {
    Future.delayed(
      Duration.zero,
      () => showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => GameEndDialog(
            winnerName: winnerName,
            replay: () {
              reset(context);
              Navigator.of(context).pop();
              isGameEnd = false;
            },
            undo: () {
              undo(context);
              Navigator.of(context).pop();
              isGameEnd = false;
            }),
      ),
    );
  }

  void reset(BuildContext context) {
    if (history.length > 1) {
      Provider.of<ChessData>(context, listen: false).update(history.first);
      ChessData first = history.first;
      history.clear();
      history.add(first);
    }
  }

  void undo(BuildContext context) {
    if (history.length == 2) {
      reset(context);
      return;
    }
    if (history.length > 2) {
      Provider.of<ChessData>(context, listen: false)
          .update(history[history.length - 1 - 1]);
      history.removeLast();
      history.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    chessData = Provider.of<ChessData>(context);
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromRGBO(4, 0, 51, 1),
      body: Column(
        children: [
          GestureDetector(
            onDoubleTap: () {
              undo(context);
            },
            child: SafeArea(
              child: Container(
                height: size.width / 4,
                color: const Color.fromRGBO(159, 75, 225, 1),
                child: MyGridView(chessData.killedPieceOfPlayer1
                    .map((e) => SizedBox(
                        width: size.width / 8,
                        child: SvgPicture.asset(e.imagePath)))
                    .toList()),
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 60,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    reset(context);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                          width: 4.0,
                          color: chessData.currentlyPlaying == Player.Player1
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //adding chess to game screen
          Center(
            child: Container(
              height: size.width,
              width: size.width,
              child: Chess(),
            ),
          ),
          Container(
            height: 60,
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onDoubleTap: () {
                    reset(context);
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(
                          width: 4.0,
                          color: chessData.currentlyPlaying == Player.Player2
                              ? Colors.white
                              : Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onDoubleTap: () {
              undo(context);
            },
            child: SafeArea(
              child: Container(
                height: size.width / 4, //(159, 75, 225, 1)
                color: const Color.fromRGBO(159, 75, 225, 1),
                child: GridView.extent(
                  maxCrossAxisExtent: size.width / 8,
                  dragStartBehavior: DragStartBehavior.down,
                  physics: const NeverScrollableScrollPhysics(),
                  children: chessData.killedPieceOfPlayer2
                      .map((e) => SvgPicture.asset(e.imagePath))
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
