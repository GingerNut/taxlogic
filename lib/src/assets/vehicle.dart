import 'package:taxlogic/src/utilities/utilities.dart';



class Car{
  static const ELECTRIC = 1;
  static const PETROL = 0;
  static const DIESEL = 2;


  String manufacturer;
  String model;
  Date registered;
  Date purchased;
  int engineType = 0;
  num CO2;

  num cost;


}