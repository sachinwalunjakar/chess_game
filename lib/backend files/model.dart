import 'package:flutter/material.dart';

enum PieceType { none, king, queen, camel, horse, elephant, soldier }

enum Player { Player1, Player2, NullPlayer }

class ChessPiece {
  PieceType pieceType;
  Player player;
  ChessPiece(
    this.pieceType,
    this.player,
  );
  ChessPiece.copy(ChessPiece chessPiece)
      : this(chessPiece.pieceType, chessPiece.player);

  String get imagePath {
    if (this.player == Player.Player1) {
      switch (this.pieceType) {
        case PieceType.none:
          return "";
        case PieceType.camel:
          return "assets/black_camel.svg";
        case PieceType.elephant:
          return "assets/black_elephant.svg";
        case PieceType.horse:
          return "assets/black_horse.svg";
        case PieceType.king:
          return "assets/black_king.svg";
        case PieceType.soldier:
          return "assets/black_pawn.svg";
        case PieceType.queen:
          return "assets/black_queen.svg";
        default:
      }
    } else if (this.player == Player.Player2) {
      switch (this.pieceType) {
        case PieceType.none:
          return "";
        case PieceType.camel:
          return "assets/white_camel.svg";
        case PieceType.elephant:
          return "assets/white_elephant.svg";
        case PieceType.horse:
          return "assets/white_horse.svg";
        case PieceType.king:
          return "assets/white_king.svg";
        case PieceType.soldier:
          return "assets/white_pawn.svg";
        case PieceType.queen:
          return "assets/white_queen.svg";
        default:
      }
    }
    return "";
  }
  //
}

enum PlaceState { normal, possible, selected, susKill }

//actual place in chess grid
class Place {
  final int position;
  ChessPiece chessPiece; //class containing two enum
  PlaceState state; //enum
  Place({
    required this.position,
    required this.chessPiece,
    required this.state,
  });

  //return value instead reference
  Place.copy(Place place)
      : this(
          position: place.position,
          chessPiece: ChessPiece.copy(place.chessPiece),
          state: place.state,
        );
}
