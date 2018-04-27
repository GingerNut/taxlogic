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
      else if (test.amount.seller is JointOwners && ((test.amount.seller as JointOwners).includes(entity))){
        JointOwners owners = test.amount.seller as JointOwners;

        owners.getOwners().forEach((owner){

          if(owner.entity == entity) {
            if(period.includes(test.date)) if(!disposals.contains(test.amount))disposals.add(test.amount);
          }
        });
      }
    });

    return disposals;

  }

  Date disposalDate(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;
      else if (test.amount.seller is JointOwners && ((test.amount.seller as JointOwners).includes(entity))){
        JointOwners owners = test.amount.seller as JointOwners;

        owners.getOwners().forEach((owner){

          if(owner.entity == entity) change = test;

        });

      }
    });

    if(change != null) return change.amount.date;
    else return null;
  }

  Date acquisitionDate(Entity entity){

    TransactionChange change;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) change = test;
      else if (test.amount.buyer is JointOwners && ((test.amount.buyer as JointOwners).includes(entity))){
        JointOwners owners = test.amount.buyer as JointOwners;

        owners.getOwners().forEach((owner){

          if(owner.entity == entity) change = test;

        });

      }
    });

    if(change != null)  {

      return change.amount.date;

    }
    else return null;
  }

  num disposalConsideration(Entity entity){

    TransactionChange change;
    num proportion = 1;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.seller == entity) change = test;
      else if (test.amount.seller is JointOwners  && ((test.amount.seller as JointOwners).includes(entity))){
        JointOwners owners = test.amount.seller as JointOwners;

        owners.getOwners().forEach((owner){

          if(owner.entity == entity) change = test;
          proportion = owner.proportion;

        });

      }
    });

    if(change != null) return change.amount.consideration * proportion;
    else return null;
  }

  num acquisitionConsideration(Entity entity){

    TransactionChange change;
    num proportion = 1;

    history.forEach((t){
      TransactionChange test = t as TransactionChange;

      if(test.amount.buyer == entity) {
        change = test;

      } else if (test.amount.buyer is JointOwners && ((test.amount.buyer as JointOwners).includes(entity)) ){
        JointOwners owners = test.amount.buyer as JointOwners;

        owners.getOwners().forEach((owner){

          if(owner.entity == entity ) change = test;
          proportion = owner.proportion;

        });

      }
    });

    if(change != null) {
      return change.amount.consideration * proportion;
    }
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

    if(entity is JointOwners  ){

      entity.getOwners().forEach((jointOnwer){

        history.forEach((t){
          TransactionChange test = t as TransactionChange;

          if(test.amount.buyer == jointOnwer.entity) change = test;
        });

        if(change != null) change.amount.date = date;

      });

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