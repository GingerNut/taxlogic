import 'package:taxlogic/src/assets/acquisition/acquisition.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'stamp_duty_land_tax.dart';
export 'stamp_duty.dart';

abstract class StampTaxes{
  StampTaxes(this.acquisition);

  final Acquisition acquisition;

  Date dueDate;
  num get duty => calculateDuty();

  num calculateDuty();
}