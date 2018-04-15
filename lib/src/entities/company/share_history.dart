import 'package:taxlogic/src/utilities/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareHistory extends History<Date>{





  @override
  Date getZero() => new Date(31,3,82);

  @override
  ShareChange newChange(Date date, num number) {
    return new ShareChange(date, number);
  }
}


class ShareChange extends Change{
  ShareChange(Date date, num number) : super(date, number);


}