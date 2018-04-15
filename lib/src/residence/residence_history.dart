import 'package:taxlogic/src/residence/residence.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history.dart';



class ResidenceHistory extends History<Residence>{




  @override
  ResidenceChange newChange(Date date, Residence residence) => new ResidenceChange(date, residence);

  @override
  setNil() {
    // TODO: implement setNil
  }
}

class ResidenceChange extends Change<Residence>{
  ResidenceChange(Date date, Residence residence) : super(date, residence);


}