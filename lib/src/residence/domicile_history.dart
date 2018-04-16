import 'package:taxlogic/src/residence/domicile.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/history.dart';



class DomicileHistory extends History<Domicile>{




  @override
  DomicileChange newChange(Date date, Domicile domicile) => new DomicileChange(date, domicile);

  @override
  setNil() {
    // TODO: implement setNil
  }
}

class DomicileChange extends Change<Domicile>{
  DomicileChange(Date date, Domicile domicile) : super(date, domicile);


}