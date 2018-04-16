import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class Loan extends Asset{
  Loan(Entity entity) : super(entity);

  Activity lender;
  Activity borrower;

  NumHistory principle = new NumHistory();
  NumHistory interest = new NumHistory();




}