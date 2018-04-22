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

  disposal(Entity entity){
    if(entity == seller) return date;
    else return null;
  }

  acquisition(Entity entity){
    if(entity == buyer) return date;
    else return null;
  }

  num gain() => 0;

  num duty() => 0;

  printTransaction(){

    print('Transaction details ');
    print('Asset type $asset');
    print('Asset name ${asset.name}');
    date.printDate();
    print('Seller is $seller');
    print('buyer is $buyer');

  }

  go() => asset.onTransaction(this);


}