
import '../position/position.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'move_start_activity.dart';
export 'move_start_activity.dart';
import 'move_create_entity.dart';
export 'move_create_entity.dart';
import 'move_transfer_activity.dart';
export 'move_transfer_activity.dart';

abstract class Move{
  static const int RESIDENTIAL_PROPERTY_BUSINESS = 1;
  static const int CREATE_ENTITY = 2;
  static const int TRANSFER_ACTIVITY = 3;
  static const int START_ACTIVITY = 4;

  int type;

  Move(this.type);

  doMove(Position newPosition);

}