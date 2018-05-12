
import 'package:taxlogic/src/assets/transaction/transaction_history.dart';
import 'package:taxlogic/src/entities/company/share_transaction/share_transaction.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class IssueShares extends ShareTransaction{
      IssueShares(this.capital, Entity entity, int shares, Date date){

        super.buyer = entity;
        super.numberOfShares = shares;
        super.date = date;

      }

      ShareCapital capital;

      go(){
        super.go();

        capital.history.add(new TransactionChange(this));

      }

}