import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';

import 'package:taxlogic/src/utilities/utilities.dart';

class TransactionHistory extends Diary{

  set (Transaction  amount){

    sort();
  }

  List<Transaction> disposalsInPeriod(Period period, Entity entity){  // not tested
    List<Transaction> disposals = new List();

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.seller == entity) {
        if(period.includes(test.date)) if(!disposals.contains(test))disposals.add(test);
      }

    });

    return disposals;

  }

  List<Transaction> disposal(Entity entity) {

    List<Transaction> disposals = new List();

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.seller == entity) {
        if(!disposals.contains(test))disposals.add(test);
      }

    });

    return disposals;

  }

  Date disposalDate(Entity entity){

    Transaction change;

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.seller == entity) change = test;

    });

    if(change != null) return change.date;
    else return null;
  }

  Date acquisitionDate(Entity entity){

    Transaction change;

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.buyer == entity) change = test;

    });

    if(change != null)  {

      return change.date;

    }
    else return null;
  }

  num disposalConsideration(Entity entity){

    List<Transaction> changes = new List();

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.seller == entity) changes.add(test);

    });

    num consideration = 0;
    changes.forEach((change)=>consideration += change.consideration);
    return consideration;
  }

  num acquisitionConsideration(Entity entity){

    List<Transaction> changes = new List();

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.buyer == entity) changes.add(test);

    });

    num consideration = 0;
    changes.forEach((change)=>consideration += change.consideration);
    return consideration;
  }

  setAcquisitionDate(Entity entity, Date date) {
    Transaction change;

    if(entity is JointOwners  ){

      entity.getOwners().forEach((jointOnwer){

        events.forEach((t){
          Transaction test = t as Transaction;

          if(test.buyer == jointOnwer.entity) change = test;
        });

        if(change != null) change.date = date;

      });

    } else {

      events.forEach((t){
        Transaction test = t as Transaction;

        if(test.buyer == entity) change = test;
      });

      if(change != null) {
        change.date = date;
      }

    }

  }

  setAcquisitionConsideration(Entity entity, num consideration) {

    setConsideration(Entity entity, num consideration){
      Transaction change;

      events.forEach((t){
        Transaction test = t as Transaction;

        if(test.buyer == entity) change = test;

      });

      if(change != null) change.consideration = consideration;
    }

    if(entity is JointOwners){

        List<JointShare> ownerShares = entity.getOwners();

        ownerShares.forEach((share){
          setConsideration(share.entity, consideration * share.proportion);
        });

    } else setConsideration(entity, consideration);

  }

  setDisposalDate(Entity entity, Date date) {
    Transaction change;

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.seller == entity) change = test;
    });

    if(change != null) change.date = date;

  }

  setDisposalConsideration(Entity entity, num consideration) {
    Transaction change;

    events.forEach((t){
      Transaction test = t as Transaction;

      if(test.seller == entity) change = test;
    });

    if(change != null) change.consideration = consideration;


  }

  sell(Asset asset, Entity entity, Date date, amount) {
    Transaction transaction = new Transaction()
    ..asset = asset
        ..date = date
        ..consideration = amount
        .. seller = entity
        ..go();

    events.add(transaction);
  }

  void printTransactions() {
    events.forEach((change){
      (change as Transaction).printTransaction();
    });
  }


}


