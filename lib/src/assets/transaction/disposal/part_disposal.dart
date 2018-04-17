
import 'package:taxlogic/src/assets/transaction/disposal/disposal.dart';
import 'package:taxlogic/src/utilities/date.dart';



class PartDisposal extends Disposal{
  PartDisposal(Date date, num consideration) : super(date, consideration);

  Date date;
  num consideration = 0;

  PartDisposal lsatDisposal;


}