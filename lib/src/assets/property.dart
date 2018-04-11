import 'chargeable_assets.dart';
import '../accounts/accounts.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../entities/entity.dart';
import 'package:taxlogic/src/utilities/rate_history.dart';


class Property extends ChargeableAsset{
  Property(Entity entity) : super(entity);
  List<Accounts> accounts = new List();

  RateHistory _rentsDue = new RateHistory.empty();
  RateHistory _interestsDue = new RateHistory.empty();

  void changeRent(num amount, Date date){
    _rentsDue.add(new RateChange(date, amount));
  }
  void changeInterest(num amount, Date date){
    _interestsDue.add(new RateChange(date, amount));
  }

  void setRent(num amount){
    _rentsDue.set(amount);
  }

  void setInterest(num amount){
    _interestsDue.set(amount);
  }

  num getRent(Date date){
    return _rentsDue.rateAt(date);
  }

  num getInterest(Date date){
    return _interestsDue.rateAt(date);
  }

  num rent(Period period)=>_rentsDue.overallAmount(period);

  num interest(Period period)=>_interestsDue.overallAmount(period);

  @override
  transferTo(Entity transferee, Disposal disposal) {
    Property newProp = new Property(transferee)
        ..acquisition.date = disposal.date
        ..acquisition.cost = disposal.consideration
        ..setRent(getRent(disposal.date))
        ..setInterest(getInterest(disposal.date));
    transferee.assets.add(newProp);

    PropertyBusiness business;

    transferee.activities.forEach((activity){
      if(activity is PropertyBusiness) business = activity;
    });

    if(business == null) {
      business = new PropertyBusiness(transferee);
      transferee.activities.add(business);
    }

    business.properties.add(newProp);

    this.disposal = disposal;

    return newProp;
  }
}