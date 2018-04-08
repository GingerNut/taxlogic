
import '../position/position.dart';

export 'package:taxlogic/src/game/move/employment/move_start_employment.dart';
export 'move_create_entity.dart';
export 'move_transfer_activity.dart';
export 'package:taxlogic/src/game/move/employment/move_end_employment.dart';
export 'employment/move_payrise.dart';

abstract class Move{
  static const int RESIDENTIAL_PROPERTY_BUSINESS = 1;
  static const int CREATE_ENTITY = 2;
  static const int TRANSFER_ACTIVITY = 3;
  static const int START_ACTIVITY = 4;

  Move();

  doMove(Position newPosition);
}