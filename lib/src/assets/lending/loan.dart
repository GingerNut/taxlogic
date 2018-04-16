import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/entities/entity.dart';



class Loan extends Asset{
  Loan(Entity entity) : super(entity);

  Entity lender;
  Entity borrower;

  Activity lendingActivity;
  Activity borrowingActivity;




  @override
  Asset transferTo(Entity transferee, Disposal disposal) {
    // TODO: implement transferTo
  }
}