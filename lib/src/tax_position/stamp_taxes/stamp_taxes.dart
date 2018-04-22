

import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'stamp_duty_land_tax.dart';
export 'stamp_duty.dart';

abstract class StampTaxes{
  StampTaxes(this.transaction);

  final Transaction transaction;

  Date dueDate;
  num get duty => calculateDuty();

  num calculateDuty();
}