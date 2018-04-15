import 'dart:math';

import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
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

  partDisposalTo(Entity newEntity, int amountSold, Disposal disposal){

    num originalHolding = sharesAt(shareCapital.name.valueAt(disposal.date), disposal.date);
    amountSold = amountSold.clamp(0, originalHolding);

    ShareHolding holding = company.addShareholder(disposal.date,
        newEntity,
        shareCapital,
        amountSold)
      ..acquisition.date = disposal.date
      ..acquisition.cost = disposal.consideration;

    this.disposal.date = disposal.date;
    this.disposal.consideration = disposal.consideration;
    this.addShares(
        originalHolding - amountSold,
        disposal.date);



    return holding;

  }

  @override
  ShareHolding transferTo(Entity newEntity, Disposal disposal) {
      ShareHolding holding = company.addShareholder(disposal.date, newEntity, shareCapital, sharesAt(shareCapital.name.valueAt(disposal.date), disposal.date + 1))
        ..acquisition.date = disposal.date
        ..acquisition.cost = disposal.consideration;

      this.disposal.date = disposal.date;
      this.disposal.consideration = disposal.consideration;
      this.addShares(0, disposal.date);

      return holding;
  }

  String string(Date date) => 'Shareholding for ${entity.name} of ${sharesAt(shareCapital.name.valueAt(date), date)} ${name} shares in ${company.name}';





}

class ShareHistoryByType{

  String name;

  ShareHistory _shareHistory = new ShareHistory();

  int sharesAt(Date date) => _shareHistory.valueAt(date);

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareChange(date, number));

}