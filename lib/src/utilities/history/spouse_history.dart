import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/history.dart';



class SpouseHistory extends History<Spouse>{








  @override
  SpouseChange newChange(Date date, Spouse spouse)=> new SpouseChange(date, spouse);

  @override
  setNil() {
    // TODO: implement setNil
  }
}

class SpouseChange extends Change<Spouse>{
  SpouseChange(Date date, Spouse spouse) : super(date, spouse);



}

class Spouse{
  Person person;
  Date marriage;
  Date divorce;
  bool livingTogether = true;
}