import '../../entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import '../game.dart';

class Position{
    Position lastPosition;
    Move move;
    Entity entity;
    Game game;

    Position(this.game, this.lastPosition, this.move){


    }

}