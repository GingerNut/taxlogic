import 'package:taxlogic/src/utilities/history/history.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

class NameHistory extends History<String>{



  @override
  NameChange newChange(Date threshold, dynamic name) => new NameChange(threshold, name);


}

class NameChange extends Change<String>{
  NameChange(Date date, String amount) : super(date, amount);


}