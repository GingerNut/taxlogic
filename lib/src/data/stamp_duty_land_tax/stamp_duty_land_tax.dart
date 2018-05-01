import 'package:taxlogic/src/utilities/tax_bands.dart';




class StampDutyLandTaxData{

  static List<RateBand>residential2019 = [
    new RateBand(125000, 0),
    new RateBand(125000, 0.02),
    new RateBand(675000, 0.05),
    new RateBand(575000, 0.10),
  ];

  static const residentialTopRate2019 = 0.12;


  static List<RateBand>nonResidential2019 = [
    new RateBand(150000, 0),
    new RateBand(100000, 0.02),
  ];

  static const nonResidentialTopRate2019 = 0.05;


}

