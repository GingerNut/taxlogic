

class Utilities{


  static num roundIncome(num n){
     return num.parse(n.toStringAsFixed(0));
  }

  static num roundTax(num n){
    return num.parse(n.toStringAsFixed(2));
  }

  static bool isNumeric(String s) {
    if(s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }

}

