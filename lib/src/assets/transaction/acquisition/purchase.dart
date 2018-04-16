import 'acquisition.dart';
import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/utilities/date.dart';


class Purchase extends Acquisition{
  Purchase (Asset asset, Date date, num consideration) : super(asset){

    this.date = date;
    this.cost = consideration;
  }



}