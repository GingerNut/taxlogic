import 'package:taxlogic/src/assets/chargeable_assets.dart';



class Disposal{
  Disposal (this.asset);

  final ChargeableAsset asset;

  num taxableGain;
  num totalImprovements;
  num lossAllocated = 0;
  num basicRateAllocated = 0;
  num annualExemptionAllocated = 0;
  bool entrepreneurRelief = false;
  bool rolloverReliefAsset = false;
  bool residentialProperty = false;
  bool exempt = false;



}