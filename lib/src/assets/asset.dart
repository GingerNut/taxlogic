import '../entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'value.dart';

export 'disposal.dart';
export 'car.dart';

abstract class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;
  num cost = 0;
  Date purchaseDate;
  Date saleDate;
  num proceeds = 0;

}