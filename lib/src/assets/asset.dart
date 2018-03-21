import '../entities/entity.dart';
import '../date.dart';


class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;
  num cost = 0;
  Date purchaseDate;
  Date saleDate;
  num proceeds = 0;



}