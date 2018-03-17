import '../../date.dart';
import 'company_tax_data_2016.dart';
import 'company_tax_data_2017.dart';
import 'company_tax_data_2018.dart';
import 'company_tax_data_2019.dart';
import 'company_tax_data_2020.dart';
import 'company_tax_data_2021.dart';

abstract class CompanyTaxData{

  num CompanyMainRate;
  num CompanySmallRate;
  num CompanySpecialRate;


  static CompanyTaxData get(Date date){

    CompanyTaxData taxData = null;

    switch(date.financialYear){
      case 2016:
        taxData = new CompanyTaxData2016();
        break;

      case 2017:
        taxData = new CompanyTaxData2017();
        break;

      case 2018:
        taxData = new CompanyTaxData2018();
        break;

      case 2019:
        taxData = new CompanyTaxData2019();
        break;

      case 2020:
        taxData = new CompanyTaxData2020();
        break;

      case 2021:
        taxData = new CompanyTaxData2021();
        break;
    }

    return taxData;

  }


}
