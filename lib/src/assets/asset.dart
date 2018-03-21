import '../entities/entity.dart';
import '../date.dart';


class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;
  num cost;
  Date purchaseDate;
  Date saleDate;
  num proceeds;



}