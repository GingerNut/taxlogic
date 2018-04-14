import 'package:taxlogic/src/utilities/utilities.dart';



class ShareHistory extends RateHistory{
    ShareHistory() : super.empty();





    add(RateChange change) => super.add(change);



}


class ShareChange extends RateChange{
  ShareChange(Date date, num rate) : super(date, rate);


}