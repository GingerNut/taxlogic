import '../entities/entity.dart';


abstract class Income{
  Income(this.entity, this.year);

  final Entity entity;
  final int year;

  num get income;

  num get taxDeducted => 0;

  num get foreignTax => 0;

  num get taxCredit => 0;

}