import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/tax_position/stamp_taxes/stamp_taxes.dart';


class ShareTransaction extends Transaction{

  num numberOfShares;

  ShareTransaction(Asset asset) : super(asset){
    stampDuty = new StampDuty(this);
  }

  num get duty=> stampDuty.calculateDuty();

}