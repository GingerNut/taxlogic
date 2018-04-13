import '../move.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/acquisition/acquisition.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
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

    property.transferTo(entity, new Sale(date, consideration));

  }

  @override
  String checkMove(Position position) {
    entity = position.getEntityByName(entityId);
    if(entity == null) return 'entity not found';

    return 'OK';
  }

}
