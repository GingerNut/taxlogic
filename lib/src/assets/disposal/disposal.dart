import 'package:taxlogic/src/utilities/utilities.dart';

export 'sale.dart';
export 'connected_party_transfer.dart';

abstract class Disposal{

  Date date;
  num consideration = 0;

}