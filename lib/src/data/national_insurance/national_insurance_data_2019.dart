import 'national_insurance_data.dart';

class NationalInsuranceData2019 extends NationalInsuranceData{

  num C1LowerEarningsLimit = 6032;
  num C1PrimaryThreshold = 8424;
  num C1SecondaryThreshold = 8424;
  num C1UpperAccrualPoint = 40044;
  num C1UpperEarningsLimit = 46384;
  num C1UpperSecondaryThreshold = 46384;
  num C1ApprenticeUpperSecondaryThreshold;

  num C1RateToUEL = 0.12;
  num C1RateAboveUEL = 0.02;
  num C1RateContractedOut = 0.014;
  num C1MarriedWomensRate = 0.0585;
  num C1RateSecondary = 0.138;
  num C1RateSecondaryContractedOut = 0.034;

  //class 2
  num C2SmallProfitsThreshold = 5965;
  num C2Cl2Rate = 145.60;

  // class 4

  num C4LowerProfitLimit = 8424;
  num C4UpperProfitLimit = 46350;
  num C4RateToUpperLimit = 0.09;
  num C4RateAboveUpperLimit = 0.02;

}
