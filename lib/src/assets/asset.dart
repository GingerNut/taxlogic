import '../entities/entity.dart';
import 'package:taxlogic/src/assets/transaction/acquisition/acquisition.dart';
import 'package:taxlogic/src/assets/transaction/disposal/disposal.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/residence/country.dart';

export 'vehicle.dart';
export 'package:taxlogic/src/assets/property/property.dart';
export 'chargeable_assets.dart';

abstract class Asset{
  final Entity entity;
  Asset(this.entity);

  String name;
  String description;
  int locus = Country.GBR;

  Acquisition acquisition;
  Disposal disposal;

//Asset transfer(Entity transferee, Disposal disposal);

  Asset transfer(Transaction transaction){

    if(transaction.seller == entity){



    } else {




    }

    onTransaction();
  }

  onTransaction(){}

}