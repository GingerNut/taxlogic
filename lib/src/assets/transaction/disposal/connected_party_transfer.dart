import 'disposal.dart';
import 'package:taxlogic/src/assets/transaction/value/value.dart';
import 'package:taxlogic/src/utilities/date.dart';


class ConnectedPartyTransfer extends Disposal{
    ConnectedPartyTransfer(Date date, this.value) : super(date, value.value);

    Value value;

  get consideration => value.value;

}