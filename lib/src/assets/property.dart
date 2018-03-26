import 'chargeable_assets.dart';
import '../accounts/accounts.dart';
import '../period.dart';
import '../date.dart';
import '../entities/entity.dart';
import '../rate_history.dart';

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

  num rent(Period period)=>_rentsDue.overallAmount(period);

  num interest(Period period)=>_interestsDue.overallAmount(period);
}