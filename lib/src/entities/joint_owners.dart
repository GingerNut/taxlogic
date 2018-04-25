import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/period_collection.dart';




class JointOwners extends Entity{

    bool tenantsInCommon = false;

    List<JointShare> _owners = new List();
    num totalShares = 0;

  JointOwners.jointTenants(Entity entity1, Entity entity2){
    tenantsInCommon = false;

    addOwner(entity1, 1);
    addOwner(entity2, 1);

  }

  List<JointShare> getOwners() => _owners;


   addOwner(Entity entity, num share){
     JointShare jointShare = new JointShare(this, entity, share);
     _owners.add(jointShare);

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


  PeriodCollection getTaxPeriods(Period period)=> null;

  TaxPosition taxYear(int taxYearEnd) => null;

  void updateOwners() {
     _owners.forEach((share){



       share.entity.assets.remove(this);



       share.entity.activities.remove(this);

     });


  }

}



class JointShare{

  JointShare(this.jointOwners, this.entity, this._share);

  JointOwners jointOwners;
  Entity entity;
  num _share;
  num _proportion;

  get share => _share;

  set share(num newshare){
    _share = newshare;

    jointOwners.updateShares();
  }

  get proportion => _proportion;

  update(){
    _proportion = share / jointOwners.totalShares;
  }
}