import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/entities/company/share_history.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';

class ShareHolding extends Activity{
  ShareHolding(this.company, this.date, Entity entity) : super(entity);

  Date date;
  Company company;

  ShareHistory _shareHistory = new ShareHistory();

  int sharesAt(Date date) {

    if(date == null ) date = new Date(31,3,82);
   return _shareHistory.rateAt(date);
  }

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareChange(date, number));

  @override
  DividendIncome getNewIncome(TaxPosition taxPosition) => new DividendIncome(this, taxPosition);



  @override
  ShareHolding transferTo(Entity newEntity, Disposal disposal) {
      ShareHolding holding = company.addShareholder(disposal.date, newEntity, sharesAt(disposal.date + 1))
        ..acquisition.date = disposal.date
        ..acquisition.cost = disposal.consideration;

      this.disposal.date = disposal.date;
      this.disposal.consideration = disposal.consideration;
      this.addShares(0, disposal.date);

      return holding;
  }

  String string(Date date) {


      'Shareholding for ${entity.name} of ${sharesAt(date)} ${name} shares in ${company.name}';




  }




}

class ShareHistoryByType{

  String name;

  ShareHistory _shareHistory = new ShareHistory();

  int sharesAt(Date date) => _shareHistory.rateAt(date);

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareChange(date, number));

}