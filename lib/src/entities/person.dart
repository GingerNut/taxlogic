import 'package:taxlogic/src/tax_position/personal_tax_position.dart';
import '../assets/chargeable_assets.dart';
import 'entity.dart';

class Person extends Entity{

  static const String jsonTagCode = "code";
  static const String jsonTagScotland = "scotland";
  static const String jsonTagFirstName = "first_name";
  static const String jsonTagSurname = "surname";
  static const String jsonTagAddress = "address";

  bool scotland = false;
  Person spouse;

  String firstName;
  String surname;
  String address;

  PersonalTaxPosition taxPosition2016;
  PersonalTaxPosition taxPosition2017;
  PersonalTaxPosition taxPosition2018;
  PersonalTaxPosition taxPosition2019;

  PersonalTaxPosition currentTaxYear;

  Person(){
    type = Class.individual;

  }

  void setTaxPositions(){
    taxPosition2016 = new PersonalTaxPosition(this, 2016);
    taxPosition2017 = new PersonalTaxPosition(this, 2017);
    taxPosition2018 = new PersonalTaxPosition(this, 2018);
    taxPosition2019 = new PersonalTaxPosition(this, 2019);
  }


  PersonalTaxPosition getYear(int year){

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

