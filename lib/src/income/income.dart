import '../entities/entity.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
export 'rental_income.dart';

class Income{
  Income(this.activity, this.taxPosition){
    taxPosition.income.add(this);
  }

  final Activity activity;
  final TaxPosition taxPosition;

  bool manualSet = true;

  num income = 0;

  num get taxDeducted => 0;

  num get foreignTax => 0;

  num get taxCredit => 0;

}