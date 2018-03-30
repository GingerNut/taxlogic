import 'entity.dart';
import 'package:taxlogic/src/date.dart';


class Trust extends Entity{

  Trust(){
    type = Entity.TRUST;


  }



  @override
  num taxPayble(Date periodend) {
    // TODO: implement taxPayble
  }
}