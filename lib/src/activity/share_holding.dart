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

  int sharesAt(Date date) => _shareHistory.rateAt(date);

  void set(int number) => _shareHistory.set(number);

  addShares(int number, Date date) => _shareHistory.add(new ShareChange(date, number));

  @override
  DividendIncome getNewIncome(TaxPosition taxPosition) => new DividendIncome(this, taxPosition);


  ShareHolding partTransfer(Entity entity, number, Disposal disposal) {

    ShareHolding part = company.shareRegister.getPartHolding(number);

    // TODO share splits in share register


    this.disposal.date = disposal.date;
    this.disposal.consideration = disposal.consideration;

    ShareHolding holding = company.transferShares(disposal.date, entity, this)
      ..acquisition.date = date
      ..acquisition.cost = disposal.consideration;

    return holding;
  }

  @override
  ShareHolding transferTo(Entity entity, Disposal disposal) {

      this.disposal.date = disposal.date;
      this.disposal.consideration = disposal.consideration;

      ShareHolding holding = company.transferShares(disposal.date, entity, this)
        ..acquisition.date = date
        ..acquisition.cost = disposal.consideration;

     return holding;
  }

  String string(Date date) => 'Shareholding for ${entity.name} of ${sharesAt(date)} in ${company.name}';




}