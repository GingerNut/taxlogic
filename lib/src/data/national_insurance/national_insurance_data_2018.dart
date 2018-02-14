import 'national_insurance_data.dart';

class NationalInsuranceData2018 extends NationalInsuranceData{

  num C1LowerEarningsLimit = 5880;
  num C1PrimaryThreshold = 8160;
  num C1SecondaryThreshold = 8160;
  num C1UpperAccrualPoint = 40044;
  num C1UpperEarningsLimit = 45000;
  num C1UpperSecondaryThreshold = 45000;
  num C1ApprenticeUpperSecondaryThreshold;

  num C1RateToUEL = 0.12;
  num C1RateAboveUEL = 0.02;
  num C1RateContractedOut = 0.014;
  num C1MarriedWomensRate = 0.0585;
  num C1RateSecondary = 0.138;
  num C1RateSecondaryContractedOut = 0.034;

  //class 2
  num C2SmallProfitsThreshold = 6025;
  num C2Cl2Rate = 148.20;

  // class 4

  num C4LowerProfitLimit = 8164;
  num C4UpperProfitLimit = 45000;
  num C4RateToUpperLimit = 0.09;
  num C4RateAboveUpperLimit = 0.02;

}
