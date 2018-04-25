import '../entities/entity.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/residence/country.dart';
import 'package:taxlogic/src/utilities/history/transaction_history.dart';
import 'package:taxlogic/src/utilities/history/value_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'vehicle.dart';
export 'package:taxlogic/src/assets/property/property.dart';
export 'chargeable_assets.dart';

abstract class Asset{
  String name;
  String description;
  int locus = Country.GBR;
  JointShare jointShare = null;
  ValueHistory value;

  Asset(Entity entity){

    if(entity != null) {
      entity.addAsset(this);
      if(transactions.history.length == 0) entity.addTransaction(this);
    }


  }

  Asset.buy(Entity entity, Date date, amount){
    Transaction transaction = new Transaction(this)
      ..buyer = entity
      ..consideration = amount
    ..date = date;

    transactions.add(new TransactionChange(transaction));

  }


  owner(Date date) => transactions.valueAt(date).buyer;

  TransactionHistory transactions = new TransactionHistory();

  Date acquisitionDate(Entity entity) => transactions.acquisitionDate(entity);

  Date disposalDate(Entity entity) => transactions.disposalDate(entity);

  num acquisitionConsideration(Entity entity) => transactions.acquisitionConsideration(entity);

  num disposalConsideration(Entity entity) => transactions.disposalConsideration(entity);

  setAcquisitionDate(Entity entity, Date date) => transactions.setAcquisitionDate(entity, date);

  setAcquisitionConsideration(Entity entity, num consideration) => transactions.setAcquisitionConsideration(entity, consideration);

  sell(Entity entity, Date date, amount)=> transactions.sell(this, entity, date, amount);

  onTransaction(Transaction transaction){

  }

  printTransactions()=> transactions.printTransactions();
}