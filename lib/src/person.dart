import 'tax_position.dart';

class Person{

  bool scotland = false;

  TaxPosition taxPosition2017;
  TaxPosition taxPosition2018;
  TaxPosition taxPosition2019;


  void setTaxPositions(){
    taxPosition2017 = new TaxPosition(this, 2017);
    taxPosition2018 = new TaxPosition(this, 2018);
    taxPosition2019 = new TaxPosition(this, 2019);
  }


  TaxPosition getYear(int year){

    switch(year){
      case 2017: return taxPosition2017;

      case 2018: return taxPosition2018;

      case 2019: return taxPosition2019;

    }
    return taxPosition2017;

  }


}