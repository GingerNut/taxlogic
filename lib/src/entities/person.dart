import '../tax_position.dart';
import '../assets/chargeable_assets.dart';
import 'entity.dart';

class Person extends Entity{

  static const String jsonTagCode = "code";
  static const String jsonTagScotland = "scotland";
  static const String jsonTagFirstName = "first_name";
  static const String jsonTagSurname = "surname";
  static const String jsonTagAddress = "address";

  String code;
  bool scotland = false;
  String firstName;
  String surname;
  String address;

  List<ChargeableAsset> assets = new List();

  TaxPosition taxPosition2016;
  TaxPosition taxPosition2017;
  TaxPosition taxPosition2018;
  TaxPosition taxPosition2019;

  TaxPosition currentTaxYear;

  Person(){
    type = Class.individual;

  }

  void setTaxPositions(){
    taxPosition2016 = new TaxPosition(this, 2016);
    taxPosition2017 = new TaxPosition(this, 2017);
    taxPosition2018 = new TaxPosition(this, 2018);
    taxPosition2019 = new TaxPosition(this, 2019);
  }


  TaxPosition getYear(int year){

    switch(year){
      case 2016: return taxPosition2016;

      case 2017: return taxPosition2017;

      case 2018: return taxPosition2018;

      case 2019: return taxPosition2019;

    }
    return taxPosition2017;

  }

  setCurrentTaxYear(int year) {
    currentTaxYear = getYear(year);
  }

    static Person fromMap(Map map){

      Person person = new Person();
      person.code = map[jsonTagCode];
      person.scotland = map[jsonTagScotland] == 'true';
      person.firstName = map[jsonTagFirstName];
      person.surname = map[jsonTagSurname];
      person.address = map[jsonTagAddress];

      return person;
    }

    Map toMap(){

      Map jsonMap = {
        jsonTagCode: code,
        jsonTagFirstName: firstName,
        jsonTagSurname: surname,
        jsonTagAddress: address
      };



      return jsonMap;
    }
  }

