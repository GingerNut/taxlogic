import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/tax_position/stamp_taxes/stamp_duty_land_tax.dart';



class PropertyTransaction extends Transaction{
  PropertyTransaction(Asset asset) : super(asset){

    stampDuty = new StampDutyLandTax(this);

  }

  num get duty=> stampDuty.calculateDuty();

}