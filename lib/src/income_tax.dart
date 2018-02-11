import 'dart:math';
import 'table.dart';

class IncomeTaxPosition{

  int year;
  bool Scotland = false;

  num totalIncome;
  num personalAllowance;
  num basicRateUsed;
  num higherRateUsed;
  num earnings;
  num dividends;
  num interest;
  num trade;
  num pension;
  num tax = 0.0;

  IncomeTaxPosition(this.year, this.totalIncome){

    if(totalIncome > PersonalAllowanceLimit){

      personalAllowance = PersonalAllowanceDefault - (totalIncome - PersonalAllowanceLimit)/2;
      if (personalAllowance < 0) personalAllowance = 0.0;

    } else personalAllowance = PersonalAllowanceDefault;

    if(totalIncome > personalAllowance){

      basicRateUsed = min(BasicRateBand, totalIncome - personalAllowance);

      if(totalIncome > personalAllowance + BasicRateBand) {
        higherRateUsed = min(AdditionalRateLimit - personalAllowance - BasicRateBand, totalIncome - personalAllowance - basicRateUsed);
      }

      tax = basicRateUsed * 0.20;
      tax += higherRateUsed * 0.40;
      if(totalIncome > AdditionalRateLimit) tax += (totalIncome - AdditionalRateLimit) * 0.45;

      print ("Personal Allowance " + personalAllowance.toString());
      print ("Basic Rate used " + basicRateUsed.toString());
      print ("Higher rate used " + higherRateUsed.toString());

    }

    }

    List<List<String>> narrativeTaxCalc(){

    List<List<String>> narrative = new List<List<String>>();


    if(totalIncome == 0){

      narrative.add(["Nothing to pay"]);

    } else if(totalIncome < personalAllowance){

      narrative.add(["Income", "", totalIncome.toString()]);
      narrative.add(["Less: Personal Allowance", "", totalIncome.toString()]);
      narrative.add(["Taxable Income", "", "0"]);

    } else if (totalIncome < BasicRateBand){

    } else if (totalIncome < AdditionalRateLimit){

    } else {

    }

    return narrative;
   }




  static const num PersonalAllowanceDefault = 11500.0;
  static const num BasicRateBand = 33500.0;
  static const num AdditionalRateLimit = 150000.0;
  static const num PersonalAllowanceLimit = 100000.0;


}
