import 'package:taxlogic/src/entities/company/dividend.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/utilities/utilities.dart';




abstract class ShareCapital{
  ShareCapital(this.company, String shareName){
    name.set(shareName);
  }

  final Company company;
  NameHistory name = new NameHistory();
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