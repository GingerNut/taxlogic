import 'package:taxlogic/src/assets/transaction/acquisition/acquisition.dart';
import 'package:taxlogic/src/assets/transaction/acquisition/stamp_taxes/stamp_taxes.dart';



class StampDutyLandTax extends StampTaxes{
  StampDutyLandTax(Acquisition acquisition) : super(acquisition);




  @override
  num calculateDuty() {
    // TODO: implement calculateDuty
  }
}