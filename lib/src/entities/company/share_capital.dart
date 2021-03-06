import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/assets/transaction/transaction_history.dart';
import 'package:taxlogic/src/entities/company/share_transaction/issue_shares.dart';
import 'package:taxlogic/src/entities/company/share_transaction/name_change.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareCapital extends Diary{
  ShareCapital(this._originalName);

  String _originalName;

  name(Date date){
    String name = _originalName;

    events.forEach((entry){

      ShareNameChange nameChange;

      if (entry is ShareNameChange) nameChange = entry;

      if(nameChange != null && (nameChange. date == null || nameChange.date < date)){
        name = nameChange.name;
      }
    });

    return name;
  }


  void issue(Entity entity, int shares, Date date) {
      new IssueShares(this, entity, shares, date)
      ..go();

  }

  int sharesAt(Entity entity, Date date){

  }

  int totalShareCapital(Date date){

  }

}


class ShareChange extends Change<ShareTransaction>{
  ShareChange(ShareTransaction transaction) : super(transaction.date, transaction);

}