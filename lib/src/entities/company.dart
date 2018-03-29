import 'entity.dart';
import 'package:taxlogic/src/date.dart';


class Company extends Entity{


  Company(){
    type = Class.company;

  }


  @override
  num taxPayble(Date periodend) {
    // TODO: implement TaxPayble
  }
}