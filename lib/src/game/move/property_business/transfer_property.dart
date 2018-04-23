import '../move.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/utilities/date.dart';


class TransferRentalProperty extends Move{
  TransferRentalProperty(this.sellerId, this.buyerId, this.property, this.date, this.consideration);

  String sellerId;
  String buyerId;
  Entity seller;
  Entity buyer;
  Property property;
  num consideration;
  Date date;

  @override
  go(Position position) {
    if(sellerId != null) seller = position.getEntityByName(sellerId);

    if(buyerId != null) buyer = position.getEntityByName(buyerId);


    new Transaction(property)
    ..seller = seller
    ..buyer = buyer
    ..date = date
    ..consideration = consideration

    ..go();



  }

  @override
  String check(Position position) {
    String string = '';

    if(sellerId != null) {
      seller = position.getEntityByName(sellerId);
      if(seller == null) string += 'seller entity ' ;
    }

      if(buyerId != null) {
        buyer = position.getEntityByName(buyerId);
        if(buyer == null) string += 'buyer entity ';
      }

      if(string != '') return string + 'not found';

      return 'OK';

  }

}

