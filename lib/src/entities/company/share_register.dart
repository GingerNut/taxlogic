import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';


class ShareRegister{
  final Company company;

  ShareRegister(this.company);

  List<Entity> shareholders = new List();

  ShareHolding shareholding(Entity entity){

    ShareHolding shareHolding;

    entity.activities.forEach((activity){
      if(activity is ShareHolding){
        if(activity.company == company) shareHolding = activity;
      }
    });

    if(shareHolding == null) {
      shareHolding = new ShareHolding(company, null, entity); //this.company, this.date, Entity entity, this.shares
      shareholders.add(entity);
    }

      return shareHolding;

  }

  List<ShareHolderChange> changes = new List();

  ShareHolding founder(Entity entity, int number) {
    ShareHolding holding = shareholding(entity);

    holding.set(number);

    company.ordinaryShares.shareholders.add(entity);

    return holding;
  }


  ShareHolding addShareholder(Date date, Entity entity, int number){
    ShareHolding holding = shareholding(entity)
    ..date = date;

    holding.addShares(number, date);

    company.ordinaryShares.shareholders.add(entity);


      changes.add(
        new ShareHolderChange(ShareHolderChange.SHARE_ISSUE, date)
            ..newEntity = entity
            ..shares = number

        );

      return holding;
  }

  ShareHolding transferShares(Date date, Entity entity, ShareHolding shareHolding) {
    ShareHolding holding = shareholding(entity)
     ..date = date;


    changes.add(
        new ShareHolderChange(ShareHolderChange.SHARE_TRANSFER, date)
          ..newEntity = entity
          ..oldEntity = shareHolding.entity

    );

    return holding;

  }

  printRegister(Date date){

    String string = 'Shareregister at ' + date.string() +  '\n';

    shareholders.forEach((holder){

      string += '${holder.name}  ${shareholding(holder).sharesAt(date)} \n' ;

    });

    print(string);

  }

  ShareHolding getPartHolding(int number) {


  }

}

class ShareHolderChange{
  static const int SHARE_ISSUE = 1;
  static const int SHARE_TRANSFER = 2;
  static const int SPLIT_HOLDING = 3;

  Date date;
  Entity oldEntity;
  Entity newEntity;
  int type;
  int shares;

  ShareHolderChange(this.type, this.date);

}