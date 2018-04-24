import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class ShareHistory extends History<int>{




  @override
  ShareChange newChange(Date date, int number) => new ShareChange(date, number);

}


class ShareChange extends Change<int>{
  ShareChange(Date date, int number) : super(date, number);

  num cost;
}