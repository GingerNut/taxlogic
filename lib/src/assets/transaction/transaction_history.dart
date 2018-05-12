import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class TransactionHistory extends History<Transaction>{

  set (Transaction  amount){

    sort();
  }

  List<Transaction> disposalsInPeriod(Period period, Entity entity){  // not tested
    List<Transaction> disposals = new List();

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) {
        if(period.includes(test.date)) if(!disposals.contains(test.amount))disposals.add(test.amount);
      }

    });

    return disposals;

  }

  List<Transaction> disposal(Entity entity) {

    List<Transaction> disposals = new List();

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) {
        if(!disposals.contains(test.amount))disposals.add(test.amount);
      }

    });

    return disposals;

  }

  Date disposalDate(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;

    });

    if(change != null) return change.amount.date;
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

    List<TransactionChange> changes = new List();

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) changes.add(test);

    });

    num consideration = 0;
    changes.forEach((change)=>consideration += change.amount.consideration);
    return consideration;
  }

  num acquisitionConsideration(Entity entity){

    List<TransactionChange> changes = new List();

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) changes.add(test);

    });

    num consideration = 0;
    changes.forEach((change)=>consideration += change.amount.consideration);
    return consideration;
  }


  @override
  TransactionChange newChange(Date date, Transaction transaction) => new TransactionChange(transaction);


  setAcquisitionDate(Entity entity, Date date) {
    TransactionChange change;

    if(entity is JointOwners  ){

      entity.getOwners().forEach((jointOnwer){

        history.forEach((t){
          TransactionChange test = t as TransactionChange;

          if(test.amount.buyer == jointOnwer.entity) change = test;
        });

        if(change != null) change.amount.date = date;

      });

    } else {

      history.forEach((t){
        TransactionChange test = t as TransactionChange;

        if(test.amount.buyer == entity) change = test;
      });

      if(change != null) {
        change.amount.date = date;
      }

    }

  }

  setAcquisitionConsideration(Entity entity, num consideration) {

    setConsideration(Entity entity, num consideration){
      TransactionChange change;

      history.forEach((t){
        TransactionChange test = t as TransactionChange;

        if(test.amount.buyer == entity) change = test;

      });

      if(change != null) change.amount.consideration = consideration;
    }

    if(entity is JointOwners){

        List<JointShare> ownerShares = entity.getOwners();

        ownerShares.forEach((share){
          setConsideration(share.entity, consideration * share.proportion);
        });

    } else setConsideration(entity, consideration);

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
    Transaction transaction = new Transaction()
    ..asset = asset
        ..date = date
        ..consideration = amount
        .. seller = entity
        ..go();

    history.add(new TransactionChange(transaction));
  }

  void printTransactions() {
    history.forEach((change){
      (change as TransactionChange).amount.printTransaction();
    });
  }


}



class TransactionChange extends Change<Transaction>{

  TransactionChange(Transaction transaction) : super(transaction.date, transaction);

}