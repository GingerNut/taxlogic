import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';




class JointOwners extends Entity{

    bool jointTenants = true;

    List<JointShare> _owners = new List();
    num totalShares = 0;

   addOwner(Asset asset, Entity entity, num share){
     JointShare jointShare = new JointShare(asset, entity, share);
     _owners.add(jointShare);

     totalShares += share;

     updateShares();

   }

   removeOwner(Entity entity){
     _owners.remove(getShare(entity));

     updateShares();
   }

    updateShares(){
     totalShares = 0;

     _owners.forEach((share)=> totalShares += share._share);

     _owners.forEach((share)=> share.update());

    }


    JointShare getShare(Entity entity){
      JointShare owner;

      _owners.forEach( (test){if(
      test.entity == entity)owner = test;
      });

      return owner;
    }

  @override
  PeriodCollection getTaxPeriods(Period period) {
    // TODO: implement getTaxPeriods
  }

  @override
  TaxPosition taxYear(int taxYearEnd) {
    // TODO: implement taxYear
  }

  void updateOwners() {
     _owners.forEach((share){



       share.entity.assets.remove(this);



       share.entity.activities.remove(this);

     });


  }
}

class JointShare{

  JointShare(this.asset, this.entity, this._share);

  Asset asset;
  JointOwners jointOwners;
  Entity entity;
  num _share;
  num _proportion;

  get share=> _share;

  set share(num newshare){
    _share = newshare;

    jointOwners.updateShares();
  }

  get proportion => _proportion;

  update(){
    _proportion = share / jointOwners.totalShares;
  }
}