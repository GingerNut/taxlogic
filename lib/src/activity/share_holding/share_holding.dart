import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/transaction/disposal/disposal.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';
import 'package:taxlogic/src/entities/company/share_history.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';

class ShareHolding extends Activity{
  ShareHolding(this.company, this.shareCapital, this.date, Entity entity) : super(entity);

  Date date;
  Company company;
  ShareCapital shareCapital;

  ShareHistory _shareHistory = new ShareHistory();

  int sharesAt(String name, Date date) {

    if(shareCapital.name.valueAt(date) != name) return 0;

    if(date == null ) date = new Date(31,3,82);
   return _shareHistory.valueAt(date);
  }

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareChange(date, number));

  @override
  DividendIncome getNewIncome(TaxPosition taxPosition) => new DividendIncome(this, taxPosition);

  partDisposalTo(Transaction transaction , num number){

    /*

    num originalHolding = sharesAt(shareCapital.name.valueAt(disposal.date), disposal.date);
    number = number.clamp(0, originalHolding);

    ShareHolding holding = company.addShareholder(transaction.date,
        transaction.buyer,
        shareCapital,
        number)
      ..acquisition.date = transaction.date
      ..acquisition.cost = transaction.consideration;

    this.disposal.date = transaction.date;
    this.disposal.consideration = transaction.consideration;
    this.addShares(
        originalHolding - number,
        transaction.date);

    return holding;
*/
  }

  @override
  onTransaction(Transaction transaction) {
/*
    num number = (transaction as ShareTransaction).numberOfShares;
    num shareholding = sharesAt(shareCapital.name.valueAt(transaction.date), transaction.date);

    if(number < shareholding){

      return partDisposalTo(transaction, number);


    } else {

      ShareHolding holding = company.addShareholder(transaction.date, transaction.buyer, shareCapital, sharesAt(shareCapital.name.valueAt(transaction.date), transaction.date + 1))
        ..acquisition.date = transaction.date
        ..acquisition.cost = transaction.consideration;

      this.disposal.date = transaction.date;
      this.disposal.consideration = transaction.consideration;
      this.addShares(0, transaction.date);

      return holding;

    }
  */

  }

  String string(Date date) => 'Shareholding for ${owner(date).name} of ${sharesAt(shareCapital.name.valueAt(date), date)} ${name} shares in ${company.name}';





}

class ShareHistoryByType{

  String name;

  ShareHistory _shareHistory = new ShareHistory();

  int sharesAt(Date date) => _shareHistory.valueAt(date);

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareChange(date, number));

}