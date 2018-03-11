import 'dart:math';

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

  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

}

