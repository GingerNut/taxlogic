import 'history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class NameHistory extends History<Date>{






  @override
  getZero() => new Date(1,1,80);

  @override
  NameChange newChange(Date threshold, dynamic name) => new NameChange(threshold, name);
}

class NameChange extends Change{
  NameChange(Date date, String amount) : super(date, amount);


}