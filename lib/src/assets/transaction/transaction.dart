import 'dart:math';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'share_transaction.dart';


class Transaction{

  Transaction(this.asset);

  Asset asset;

  Entity seller;
  Entity buyer;

  num consideration;
  Date date;

  // capital gains stuff =>
  bool gainValid = false;
  num taxableGain = 0;
  num totalImprovements;
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  num annualExemptionAllocated = 0;

  disposal(Entity entity){
    if(entity == seller) return date;
    else return null;
  }

  acquisition(Entity entity){
    if(entity == buyer) return date;
    else return null;
  }

  num duty() => 0;

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

    asset.transactions.add(new TransactionChange(this));

    if(buyer != null) buyer.addAsset(asset);

    asset.onTransaction(this);

    if(seller != null) taxableGain = calculateGain(seller);
  }

  num calculateGain(Entity entity){

    if(asset is !ChargeableAsset) return 0;

    ChargeableAsset chargeableAsset = asset as ChargeableAsset;

    Date acquisition = asset.acquisitionDate(seller);

    Date disposal = date;

    num acquisitionConsideration = chargeableAsset.acquisitionConsideration(entity);

    Period ownership;

    if(acquisition != null && disposal != null) ownership = new Period(acquisition, disposal);

    num gain = consideration - acquisitionConsideration - chargeableAsset.totalImprovements(ownership);

    gain = chargeableAsset.adjustGain(entity, gain);

    gain  = Utilities.roundIncome(gain);


    if(entity.type == Entity.COMPANY && gain > 0){

      num indexation = min(TaxData.IndexationFactor(acquisition, disposal) * acquisitionConsideration, gain);

      gain -= indexation ;

    }

    return gain;
  }


}