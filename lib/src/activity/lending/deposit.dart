import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/activity/lending/lending_activity.dart';
import 'package:taxlogic/src/activity/lending/loan.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class Deposit extends Loan{
  Deposit(Entity entity) : super(entity);




  @override
  Asset transfer(Transaction transaction) {
    // TODO: implement transferTo
  }
}