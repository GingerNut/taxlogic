import 'period.dart';
import 'date.dart';


class TaxYear extends Period{
  int year;

  TaxYear(this.year) : super(new Date(6,4,year-1), new Date(5,4,year));



}