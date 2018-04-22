

import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/tax_position/stamp_taxes/stamp_taxes.dart';



class StampDutyLandTax extends StampTaxes{
  StampDutyLandTax(Transaction transaction) : super(transaction);




  @override
  num calculateDuty() {
    // TODO: implement calculateDuty
  }
}