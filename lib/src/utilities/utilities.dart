import 'dart:math';
export 'date.dart';
export 'period.dart';
export 'period_collection.dart';
export 'package:taxlogic/src/utilities/history/num_history.dart';
export 'period_end.dart';
export 'tax_year.dart';
export 'package:taxlogic/src/utilities/history/num_table.dart';
export 'package:taxlogic/src/utilities/history/name_history.dart';
export 'package:taxlogic/src/utilities/history/diary.dart';

class Utilities{


  static num roundIncome(num n){
    int decimals = 0;
    int fac = pow(10, decimals);

    n = (n * fac).round() / fac;

     return n;
  }

  static num roundTax(num n){
    int decimals = 2;
    int fac = pow(10, decimals);

    n = (n * fac).round() / fac;
    return n;
  }

  static num roundTo(num n, int rounding){
    int decimals = rounding;
    int fac = pow(10, decimals);

    n = (n * fac).round() / fac;
    return n;
  }

  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

}

