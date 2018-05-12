import '../entities/entity.dart';
import 'package:taxlogic/src/assets/gain_valid.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/assets/transaction/transaction_history.dart';
import 'package:taxlogic/src/residence/country.dart';
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

      if(transactions.history.length == 0) entity.addCreationTransaction(this);
    }
  }

  Asset.buy(Entity entity, Date date, amount){
    new Transaction()
    ..asset = this
      ..buyer = entity
      ..consideration = amount
    ..date = date
    ..go();

  }

  owner(Date date) => transactions.valueAt(date).buyer;

  TransactionHistory transactions = new TransactionHistory();

  List<Transaction> disposalsInPeriod(Period period, Entity entity) => transactions.disposalsInPeriod(period, entity);

  List<Transaction> disposal(Entity entity) => transactions.disposal(entity);

  Date acquisitionDate(Entity entity) => transactions.acquisitionDate(entity);

  Date disposalDate(Entity entity) => transactions.disposalDate(entity);

  num acquisitionConsideration(Entity entity) => transactions.acquisitionConsideration(entity);

  num disposalConsideration(Entity entity) => transactions.disposalConsideration(entity);

  setAcquisitionDate(Entity entity, Date date) => transactions.setAcquisitionDate(entity, date);

  setAcquisitionConsideration(Entity entity, num consideration) => transactions.setAcquisitionConsideration(entity, consideration);

  sell(Entity entity, Date date, amount)=> transactions.sell(this, entity, date, amount);

  onTransaction(Transaction transaction){}

  printTransactions()=> transactions.printTransactions();
}