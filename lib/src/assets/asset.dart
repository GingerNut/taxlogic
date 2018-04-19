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
  Entity owner;
  Asset(this.owner);

  addOwner(Entity entity, num share){

    JointOwners owners;

    if(owner is JointOwners){
      owners = owner;
      owners.addOwner(this, entity, share);

    } else {
      JointOwners jointOwners = new JointOwners();

      jointOwners.addOwner(this, entity , share);

    }

  }

  removeOwner(Entity entity){

  }


  String name;
  String description;
  int locus = Country.GBR;

  JointShare jointShare = null;

  Acquisition acquisition;
  Disposal disposal;

  ValueHistory value;

  onTransaction(Transaction transaction){}
}