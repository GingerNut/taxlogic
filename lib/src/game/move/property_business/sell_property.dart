import '../move.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/utilities/date.dart';


class SellRentalProperty extends Move{
  SellRentalProperty(this.entityFromId, this.entityToId, this.propertyId, this.date, this.consideration);

  String entityFromId;
  String entityToId;
  String propertyId;
  Entity entityFrom;
  Entity entityTo;
  Property property;
  num consideration;
  Date date;

  @override
  go(Position position) {
    entityFrom = position.getEntityByName(entityFromId);
    entityTo = position.getEntityByName(entityToId);

    property = entityFrom.getAssetById(propertyId);

    new Transaction(property)
      ..seller = entityFrom
      ..buyer = entityTo
      ..date = date
      ..consideration = consideration
    ..go();



  }

  @override
  String check(Position position) {
    entityFrom = position.getEntityByName(entityFromId);
    if(entityFrom == null) return 'selling entity not found';

    entityTo = position.getEntityByName(entityToId);
    if(entityTo == null) return 'purchasing entity not found';

    property = entityFrom.getAssetById(propertyId);
    if(property == null) return 'property not found';

    return 'OK';
  }

}

