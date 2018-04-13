import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';


class Dividend{
  num totalShares;
  final Date date;
  final List<ShareHolding> shareholders;
  final num amount;

  Dividend(this.date, this.shareholders, this.amount){
    totalShares = 0;
    shareholders.forEach((sh)=> totalShares += sh.shares);
  }

  num dividend(Entity entity) {
    ShareHolding holding;

    shareholders.forEach((hold) {
      if(hold.entity == entity) holding = hold;
    });

   if(holding == null) return 0;
   else return amount * holding.shares / totalShares;
  }

}