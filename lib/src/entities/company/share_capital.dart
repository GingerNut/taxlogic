import 'package:taxlogic/src/entities/company/dividend.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';

export 'ordinary_share.dart';


abstract class ShareCapital{
  ShareCapital(this.company, this.name);

  final Company company;
  String name;
  num par;
  int totalIssued;

  List<Entity> shareholders = new List();
  List<Dividend> dividends = new List();

  Dividend dividend(Date date, num amount){
    Dividend dividend = new Dividend(this, date, amount);
    dividends.add(dividend);

    return dividend;
  }


}