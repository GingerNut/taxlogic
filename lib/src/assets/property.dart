import 'chargeable_assets.dart';
import '../accounts/accounts.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../entities/entity.dart';
import 'package:taxlogic/src/utilities/rate_history.dart';
import 'package:taxlogic/src/assets/value/value.dart';

class Property extends ChargeableAsset{
  Property(Entity entity) : super(entity);
  List<Accounts> accounts = new List();

  RateHistory _rentsDue = new RateHistory.empty();
  RateHistory _interestsDue = new RateHistory.empty();

  void setRent(num amount, Date date){
    _rentsDue.add(new RateChange(date, amount));
  }
  void setInterst(num amount, Date date){
    _interestsDue.add(new RateChange(date, amount));
  }

  num getRent(Date date){
    return _rentsDue.rateAt(date);
  }

  num getInterest(Date date){
    return _interestsDue.rateAt(date);
  }

  num rent(Period period)=>_rentsDue.overallAmount(period);

  num interest(Period period)=>_interestsDue.overallAmount(period);


}