import 'package:taxlogic/src/assets/acquisition/acquisition.dart';
import 'package:taxlogic/src/assets/acquisition/stamp_taxes/stamp_taxes.dart';



class StampDuty extends StampTaxes{

    StampDuty(Acquisition acquisition) : super(acquisition);


  @override
  num calculateDuty() => acquisition.cost * 0.5 / 100;
}