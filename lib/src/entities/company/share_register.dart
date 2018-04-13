import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareRegister{
  final Company company;

  ShareRegister(this.company);

  List<ShareHolding> shares = new List();
  List<ShareHolderChange> changes = new List();


  List<ShareHolding> getShareholdingsAt(Date date){
    List<ShareHolding> holdingsAt = new List();

    shares.forEach((sh) {
      if(sh.date == null || sh.date < date || sh.date == date)
        holdingsAt.add(sh);
    });

    changes.forEach((change){

      if(change.date == null || change.date < date || change.date == date)

        if(change.type == ShareHolderChange.SHARE_TRANSFER){

          ShareHolding remove;

          while(remove == null){

            holdingsAt.forEach((holding){

              if(holding.entity == change.oldEntity){
                remove = holding;
              }

            });

            if(remove != null) holdingsAt.remove(remove);
          }

        }
    });

    return holdingsAt;
  }

  ShareHolding founder(Entity entity, int number) {
    ShareHolding holding = new ShareHolding(company, null, entity, number);
    shares.add(holding);
    return holding;
  }


  ShareHolding addShareholder(Date date, Entity entity, int number){
    ShareHolding holding = new ShareHolding(company, date, entity, number);
    shares.add(holding);

      changes.add(
        new ShareHolderChange(ShareHolderChange.SHARE_ISSUE, date)
            ..newEntity = entity
            ..shares = number

        );

      return holding;
  }

  ShareHolding transferShares(Date date, Entity entity, ShareHolding shareHolding) {
    ShareHolding holding = new ShareHolding(company, date, entity, shareHolding.shares);
    shares.add(holding);

    changes.add(
        new ShareHolderChange(ShareHolderChange.SHARE_TRANSFER, date)
          ..newEntity = entity
          ..oldEntity = shareHolding.entity
          ..shares = shareHolding.shares

    );

    return holding;

  }

  printRegister(Date date){
    List<ShareHolding> holdings = getShareholdingsAt(date);

    String string = 'Shareregister at ' + date.string() +  '\n';

    holdings.forEach((holding){

      string += '${holding.entity.name}  ${holding.shares} \n' ;

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