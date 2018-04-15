import 'package:taxlogic/src/activity/activity.dart';
import 'package:taxlogic/src/assets/disposal/disposal.dart';
import 'package:taxlogic/src/assets/value/value.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/income/income.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';


class QuotedShares extends ShareHolding{
  QuotedShares(this.SEDOL, Date date, int number, Entity entity) : super(null, null, null,entity);

  ShareHolding shareHolding;

  String SEDOL;

  @override
  DividendIncome getNewIncome(TaxPosition taxPosition) => new DividendIncome(this, taxPosition);
}