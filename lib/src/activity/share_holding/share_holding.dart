import 'package:taxlogic/src/activity/activity.dart';

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

  addShares(int number, Date date) => _shareHistory.add(new ShareTransaction(date, number));

  @override
  DividendIncome getNewIncome(TaxPosition taxPosition) => new DividendIncome(this, taxPosition);

  partDisposalTo(Transaction transaction , num number){

    num originalHolding = sharesAt(shareCapital.name.valueAt(transaction.date), transaction.date);
    number = number.clamp(0, originalHolding);

    ShareHolding holding = company.addShareholder(transaction.date,
        transaction.buyer,
        shareCapital,
        number)
      ..setAcquisitionDate(transaction.buyer, transaction.date)
      ..setAcquisitionConsideration(transaction.buyer, transaction.consideration);

    this.addShares(
        originalHolding - number,
        transaction.date);

    return holding;

  }

  @override
  onTransaction(Transaction transaction) {

    if(transaction is ShareTransaction) {

      num number = (transaction as ShareTransaction).numberOfShares;
      num shareholding = sharesAt(shareCapital.name.valueAt(transaction.date), transaction.date);

      if(number < shareholding){

        return partDisposalTo(transaction, number);


      } else {

        ShareHolding holding = company.addShareholder(transaction.date, transaction.buyer, shareCapital, sharesAt(shareCapital.name.valueAt(transaction.date), transaction.date + 1))
          ..setAcquisitionDate(transaction.buyer, transaction.date)
          ..setAcquisitionConsideration(transaction.buyer, transaction.consideration);

        this.addShares(0, transaction.date);

      }

    }






  }

  String string(Date date) => 'Shareholding for ${owner(date).name} of ${sharesAt(shareCapital.name.valueAt(date), date)} ${name} shares in ${company.name}';





}

class ShareHistoryByType{

  String name;

  ShareChange _shareHistory = new ShareChange();

  int sharesAt(Date date) => _shareHistory.valueAt(date);

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareTransaction(date, number));

}