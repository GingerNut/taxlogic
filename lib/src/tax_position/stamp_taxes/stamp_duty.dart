
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/tax_position/stamp_taxes/stamp_taxes.dart';




class StampDuty extends StampTaxes{

    StampDuty(Transaction transaction) : super(transaction);


  @override
  num calculateDuty() => transaction.consideration * 0.5 / 100;
}