import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class CompanyCar extends Car{

  //in super :-
  //String manufacturer;
  //String model;
  //Date registered;
  //Date purchased;

  //num CO2;
  //num cost;

  num listPrice;
  Date madeAvailable;
  Date ceaseToBeAvailable;

  num benefit(TaxPosition taxPosition){

    num benefit = TaxData.CompanyCarRate(taxPosition.period.end.year, engineType, CO2) * listPrice;

    Date from = madeAvailable == null ? taxPosition.period.start : madeAvailable;

    Date to = ceaseToBeAvailable == null ? taxPosition.period.end : ceaseToBeAvailable;

    num fraction = Period.overlap(taxPosition.period, new Period(from, to))/taxPosition.period.days;

    benefit = benefit * fraction;

    return benefit.toInt();
  }



}