import 'entity.dart';
import 'package:taxlogic/src/date.dart';


class Partnership extends Entity{

  Partnership(){
    type = Entity.PARTNERSHIP;


  }



  @override
  num taxPayble(Date periodend) {
    // TODO: implement taxPayble
  }
}