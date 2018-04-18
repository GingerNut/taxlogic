import '../move.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/utilities/date.dart';


class BuyRentalProperty extends Move{
  BuyRentalProperty(this.entityId, this.property, this.date, this.consideration);

  String entityId;
  Entity entity;
  Property property;
  num consideration;
  Date date;

  @override
  doMove(Position position) {
    entity = position.getEntityByName(entityId);

    new Transaction(property)
    ..buyer = entity
    ..date = date
    ..consideration = consideration
    ..go();


  }

  @override
  String checkMove(Position position) {
    entity = position.getEntityByName(entityId);
    if(entity == null) return 'entity not found';

    return 'OK';
  }

}

