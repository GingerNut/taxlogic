

import 'package:taxlogic/src/accounts/accounts.dart';
import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/num_history.dart';
import 'package:taxlogic/src/utilities/period.dart';
import 'package:taxlogic/src/utilities/date.dart';



class Property extends ChargeableAsset{
  Property(Entity entity) : super(entity);
  List<Accounts> accounts = new List();

  NumHistory _rentsDue = new NumHistory();
  NumHistory _interestsDue = new NumHistory();

  void changeRent(num amount, Date date){
    _rentsDue.add(new NumChange(date, amount));
  }
  void changeInterest(num amount, Date date){
    _interestsDue.add(new NumChange(date, amount));
  }

  void setRent(num amount){
    _rentsDue.set(amount);
  }

  void setInterest(num amount){
    _interestsDue.set(amount);
  }

  num getRent(Date date){
    return _rentsDue.valueAt(date);
  }

  num getInterest(Date date){
    return _interestsDue.valueAt(date);
  }

  num rent(Period period)=>_rentsDue.overallAmount(period);

  num interest(Period period)=>_interestsDue.overallAmount(period);

  num generalExpenses(Period period) => 0;  //TODO make this more satisfying


  Property getProperty(Entity entity) => new Property(entity);

  @override
  transferTo(Entity transferee, Disposal disposal) {
    Property newProp = getProperty(transferee)
        ..acquisition.date = disposal.date
        ..acquisition.cost = disposal.consideration
        ..name = name
        ..setRent(0)
        ..setInterest(0)
        ..changeRent(getRent(disposal.date), disposal.date)
        ..changeInterest(getInterest(disposal.date), disposal.date);
    transferee.assets.add(newProp);

    PropertyBusiness business;

    transferee.activities.forEach((activity){
      if(activity is PropertyBusiness) business = activity;
    });

    if(business == null) {
      business = new PropertyBusiness(transferee);
    }

    business.properties.add(newProp);

    if(entity != null){
      this.disposal = disposal;
      changeRent(0, disposal.date);
      changeInterest(0, disposal.date);
        }
      return newProp;

  }


}