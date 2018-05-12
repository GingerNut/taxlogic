import 'package:taxlogic/src/entities/company/share_capital.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';
import 'share_capital.dart';

class Dividend{
  num totalShares;
  ShareCapital shareCapital;

  final Date date;
  final num amount;

  Dividend(this.shareCapital, this.date,this.amount){
    if(shareCapital.shareholders.length == 0) throw 'unable to pay dividend as the company has no shareholders';

    totalShares = 0;
    shareCapital.shareholders.forEach((sh)=> totalShares += shareCapital.company.shareRegister.shareholding(sh, shareCapital).sharesAt(shareCapital.name.valueAt(date), date));

  }

  num dividend(Entity entity) {

    num dividend = 0;

    int holding = shareCapital.company.shareRegister.shareholding(entity, shareCapital).sharesAt(shareCapital.name.valueAt(date), date);

    dividend += amount * holding / totalShares;

   return Utilities.roundIncome(dividend);
  }

}