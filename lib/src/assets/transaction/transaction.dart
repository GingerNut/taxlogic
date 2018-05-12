import 'dart:math';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction_history.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/stamp_taxes/stamp_taxes.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'package:taxlogic/src/entities/company/share_transaction/share_transaction.dart';


class Transaction extends Event{

  Asset asset;

  Entity seller;
  Entity buyer;

  num consideration;

  // capital gains stuff =>

  num taxableGain = 0;
  num totalImprovements;
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  num annualExemptionAllocated = 0;

  StampTaxes stampDuty;

  disposal(Entity entity){
    if(entity == seller) return date;
    else return null;
  }

  acquisition(Entity entity){
    if(entity == buyer) return date;
    else return null;
  }

  num get duty => 0;

  printTransaction() => print(string());

  String string(){

    String string = '';

    string += 'Transaction details \n';
    string += 'Asset type $asset';
    if(asset.name !=  null) string += ' known as ' + asset.name;
    string += '\n';

    if(date != null) string += date.string();
    string += '\n';

    string += 'consideration is £' + consideration.toString();
    string += '\n';

    string += 'Seller is $seller';
    if(seller != null && seller.name !=  null) string += ' named ' + seller.name;
    string += '\n';

    string += 'Buyer is $buyer';
    if(buyer != null && buyer.name !=  null) string += ' named ' + buyer.name;
    string += '\n';

    string += 'taxable gain is $taxableGain';
    string += '\n';

    string += '---------------- \n\n';

    return string;
  }

  go() {

    if(!(seller is JointOwners) && !(buyer is JointOwners)) {

      if(asset != null) {
        asset.transactions.add(this);

        if(buyer != null) buyer.addAsset(asset);

        asset.onTransaction(this);

        if(seller != null) taxableGain = calculateGain(seller);
      }

      if(buyer != null){
        buyer.transactions.add(this);

      }

      if(seller != null){
        seller.transactions.add(this);

      }



    } else {

      if(seller is JointOwners){
        List<JointShare> shares = (seller as JointOwners).getOwners();
        shares.forEach((share){
          new Transaction()
          ..asset = asset
              ..buyer = buyer
            ..seller = share.entity
              ..date = date
              ..consideration = consideration * share.proportion
          ..go();
        });

      }

      if(buyer is JointOwners){
        List<JointShare> shares = (buyer as JointOwners).getOwners();
        shares.forEach((share){
          new Transaction()
          ..asset = asset
           ..buyer = share.entity
            ..seller = seller
            ..date = date
            ..consideration = consideration * share.proportion
            ..go();
        });

      }


    }


  }

  num calculateGain(Entity entity){

    if(asset is !ChargeableAsset) return 0;

    ChargeableAsset chargeableAsset = asset as ChargeableAsset;

    Date acquisition = asset.acquisitionDate(seller);

    Date disposal = date;

    num acquisitionConsideration = chargeableAsset.acquisitionConsideration(entity);

    // get total consideration

    List<Transaction> sales = asset.transactions.disposal(entity);

    num totalConsideration = 0;

    sales.forEach((sale) => totalConsideration += sale.consideration);;

    // pro rata purchase cost

    if(totalConsideration != consideration) acquisitionConsideration = acquisitionConsideration * consideration / totalConsideration;

    Period ownership;

    if(acquisition != null && disposal != null) ownership = new Period(acquisition, disposal);

    num gain = consideration - acquisitionConsideration - chargeableAsset.totalImprovements(ownership);


    gain = chargeableAsset.adjustGain(entity, gain);

    gain  = Utilities.roundIncome(gain);


    if(entity.type == Entity.COMPANY && gain > 0){

      num indexation = min(TaxData.IndexationFactor(acquisition, disposal) * acquisitionConsideration, gain);

      gain -= indexation ;

    }

    chargeableAsset.setGainValid(entity);

    taxableGain = gain;

    return gain;
  }


}