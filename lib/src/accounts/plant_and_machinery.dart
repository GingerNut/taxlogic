import '../assets/asset.dart';
import 'capital_allowances.dart';
import '../entities/entity.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';


class PlantAndMachinery extends Asset with CapitalAllowances{

  PlantAndMachinery(Entity entity) : super(entity);



}