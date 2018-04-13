import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareRegister{
  final Company company;

  ShareRegister(this.company);

  List<ShareHolding> shares = new List();
  List<ShareHolderChange> shareChanges = new List();


  List<ShareHolding> getShareholdingsAt(Date date){
    List<ShareHolding> holdingsAt = new List();

    shares.forEach((sh) {
      if(sh.date == null || sh.date < date || sh.date == date)
        holdingsAt.add(sh);
    });

    return holdingsAt;
  }

  founder(Entity entity, int number) => shares.add(new ShareHolding(company, null, entity, number));


  addShareholder(Date date, Entity entity, int number){
    shares.add(new ShareHolding(company, null, entity, number));

      shareChanges.add(
        new ShareHolderChange(ShareHolderChange.SHARE_ISSUE)
            ..entity = entity
            ..shares = number
            ..date =  date
        );
  }


}

class ShareHolderChange{
  static const int SHARE_ISSUE = 1;
  static const int SHARE_TRANSFER = 2;

  Date date;
  Entity entity;
  int type;
  int shares;

  ShareHolderChange(this.type);

}