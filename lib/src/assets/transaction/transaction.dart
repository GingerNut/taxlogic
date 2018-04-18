import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'share_transaction.dart';


class Transaction{

  Transaction(this.asset);

  Asset asset;

  Entity seller;
  Entity buyer;

  num consideration;
  Date date;

  go(){

    asset.onTransaction(this);
  }


}