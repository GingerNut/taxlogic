import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class TransactionHistory extends History<Transaction>{

  set (Transaction  amount){

    sort();
  }


  Date disposalDate(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;
    });

    if(change != null) return change.date;
    else return null;
  }

  Date acquisitionDate(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) change = test;
    });

    if(change != null)  {

      return change.amount.date;

    }
    else return null;
  }

  num disposalConsideration(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;
    });

    if(change != null) return change.amount.consideration;
    else return null;
  }

  num acquisitionConsideration(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) change = test;
    });

    if(change != null) return change.amount.consideration;
    else return 0;
  }


  @override
  TransactionChange newChange(Date date, Transaction transaction) => new TransactionChange(transaction);


  setAcquisitionDate(Entity entity, Date date) {
    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) change = test;
    });

    if(change != null) {
      change.amount.date = date;
    }

  }

  setAcquisitionConsideration(Entity entity, num consideration) {
    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) change = test;
    });

    if(change != null) change.amount.consideration = consideration;

  }

  setDisposalDate(Entity entity, Date date) {
    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;
    });

    if(change != null) change.amount.date = date;

  }

  setDisposalConsideration(Entity entity, num consideration) {
    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;
    });

    if(change != null) change.amount.consideration = consideration;


  }

  sell(Asset asset, Entity entity, Date date, amount) {
    Transaction transaction = new Transaction(asset)
        ..date = date
        ..consideration = amount
        .. seller = entity;

    history.add(new TransactionChange(transaction));
  }
}

class TransactionChange extends Change<Transaction>{

  TransactionChange(Transaction transaction) : super(transaction.date, transaction);

}