import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/assets/transaction/transaction_history.dart';
import 'package:taxlogic/src/entities/company/share_capital.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareNameChange extends ShareTransaction{
  ShareNameChange(this.capital, this.name, Date date){
    super.date = date;
  }

  ShareCapital capital;
  String name;


  go(){
    super.go();

    capital.history.add(new TransactionChange(this));

  }

}