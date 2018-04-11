import 'disposal.dart';
import 'package:taxlogic/src/assets/value/value.dart';


class ConnectedPartyTransfer extends Disposal{
    ConnectedPartyTransfer(this.value);

    Value value;

  get consideration => value.value;

}