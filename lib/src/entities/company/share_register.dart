import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';


class ShareRegister{
  final Company company;

  ShareRegister(this.company);

  List<Entity> shareholders = new List();

  ShareHolding shareholding(Entity entity, ShareCapital shareCapital){

    ShareHolding shareHolding;

    entity.activities.forEach((activity){
      if(activity is ShareHolding){
        if(activity.company == company) shareHolding = activity;
      }
    });

    if(shareHolding == null) {
      shareHolding = new ShareHolding(company, shareCapital, null, entity); //this.company, this.date, Entity entity, this.shares
      shareholders.add(entity);
    }

      return shareHolding;

  }


  ShareHolding founder(Entity entity, int number) {
    ShareHolding holding = shareholding(entity, company.ordinaryShares);

    holding.set(number);

    company.ordinaryShares.shareholders.add(entity);

    return holding;
  }


  ShareHolding addShareholder(Date date, Entity entity, ShareCapital shareCapital, int number){
    ShareHolding holding = shareholding(entity, shareCapital)
    ..date = date;

    holding.addShares(number, date);

    company.ordinaryShares.shareholders.add(entity);



      return holding;
  }

  ShareHolding transferShares(Date date, Entity entity, ShareHolding shareHolding) {
    ShareHolding holding = shareholding(entity, shareHolding.shareCapital)
     ..date = date;



    return holding;

  }

  printRegister(Date date){

    String string = 'Shareregister at ' + date.string() +  '\n';

    shareholders.forEach((holder){

      //string += '${holder.name}  ${shareholding(holder).sharesAt(date)} \n' ;

    });

    print(string);

  }



}
