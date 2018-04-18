import '../entities/entity.dart';
import 'package:taxlogic/src/assets/transaction/acquisition/acquisition.dart';
import 'package:taxlogic/src/assets/transaction/disposal/disposal.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/residence/country.dart';
import 'package:taxlogic/src/utilities/history/value_history.dart';

export 'vehicle.dart';
export 'package:taxlogic/src/assets/property/property.dart';
export 'chargeable_assets.dart';

abstract class Asset{
  final Entity owner;
  Asset(this.owner);

  String name;
  String description;
  int locus = Country.GBR;

  Acquisition acquisition;
  Disposal disposal;

  ValueHistory value;


  onTransaction(Transaction transaction){}

}