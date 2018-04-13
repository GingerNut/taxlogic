import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareRegister{
  final Company company;

  ShareRegister(this.company, this.initialShares);

  final List<ShareHolding> initialShares;
  List<ShareHolderChange> shareChanges = new List();

  List<ShareHolding> getShareholdingsAt(Date date){
    List<ShareHolding> holdingsAt = new List();
    initialShares.forEach((sh) => holdingsAt.add(sh));

    //TODO shareholder changes

    return holdingsAt;
  }


}


class ShareHolderChange{
  static const int SHARE_ISSUE = 1;



}