import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';


class Dividend{
  num totalShares;
  final Date date;
  final List<ShareHolding> shareholdings;
  final num amount;

  Dividend(this.date, this.shareholdings, this.amount){
    totalShares = 0;
    shareholdings.forEach((sh)=> totalShares += sh.shares);
  }

  num dividend(Entity entity) {
    ShareHolding holding;

    shareholdings.forEach((hold) {
      if(hold.entity == entity) holding = hold;
    });

   if(holding == null) return 0;
   else return amount * holding.shares / totalShares;
  }

}