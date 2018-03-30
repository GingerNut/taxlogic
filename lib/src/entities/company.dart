import 'entity.dart';
import 'package:taxlogic/src/date.dart';


class Company extends Entity{


  Company(){
    type = Entity.COMPANY;

  }


  @override
  num taxPayble(Date periodend) {
    // TODO: implement TaxPayble
  }
}