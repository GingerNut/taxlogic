import 'acquisition.dart';
import 'package:taxlogic/src/utilities/date.dart';


class Purchase extends Acquisition{
  Purchase (Date date, num consideration){
    this.date = date;
    this.cost = consideration;
  }



}