import '../../entities/entity.dart';
import 'package:taxlogic/src/game/move/move.dart';
import '../game.dart';

abstract class Position{
    final Position lastPosition;
    final Move move;
    final Game game;

    Entity entity;

    Position(this.game, this.lastPosition, this.move);

    setUp();

}