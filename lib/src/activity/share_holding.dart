import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/assets/value/value.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/date.dart';

class ShareHolding extends Activity{
  ShareHolding(this.company, Entity entity, this.shares) : super(entity);

  Company company;
  num shares;



  @override
  transferToEntity(Date date, Entity transferee, Value value) {
    // TODO: implement transferToEntity
  }

  @override
  DividendIncome getNewIncome(TaxPosition taxPosition) => new DividendIncome(this, taxPosition);

  @override
  transferTo(Entity entity, Disposal disposal) {
    // TODO: implement transferTo
  }
}