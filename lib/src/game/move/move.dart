
import '../position/position.dart';
import 'package:taxlogic/src/advice/advice.dart';

export 'package:taxlogic/src/game/move/employment/move_start_employment.dart';
export 'package:taxlogic/src/game/move/employment/move_add_company_car.dart';
export 'package:taxlogic/src/game/move/create_entity/move_create_individual.dart';
export 'package:taxlogic/src/game/move/create_entity/move_create_company.dart';
export 'package:taxlogic/src/game/move/employment/move_end_employment.dart';
export 'employment/move_payrise.dart';
export 'property_business/transfer_property.dart';


abstract class Move{
  static const int RESIDENTIAL_PROPERTY_BUSINESS = 1;
  static const int CREATE_ENTITY = 2;
  static const int TRANSFER_ACTIVITY = 3;
  static const int START_ACTIVITY = 4;

  Move();

  Advice advice(Position position) => null;

  String check(Position position); // //OK means move is good

  go(Position position);
}