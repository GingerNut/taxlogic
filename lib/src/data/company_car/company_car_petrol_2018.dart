import '../../utilities/utilities.dart';
import 'company_car.dart';

class CompanyCarPetrol2018 extends CompanyCarRates{

  RateTable table = new RateTable.fromList([
    new RateThreshold(0,9),
    new RateThreshold(51,13),
    new RateThreshold(76,17),
    new RateThreshold(95,18),
    new RateThreshold(100,19),
    new RateThreshold(105,20),
    new RateThreshold(110,21),
    new RateThreshold(115,22),
    new RateThreshold(120,23),
    new RateThreshold(125,24),
    new RateThreshold(130,25),
    new RateThreshold(135,26),
    new RateThreshold(140,27),
    new RateThreshold(145,28),
    new RateThreshold(150,29),
    new RateThreshold(155,30),
    new RateThreshold(160,31),
    new RateThreshold(165,32),
    new RateThreshold(170,33),
    new RateThreshold(175,34),
    new RateThreshold(180,35),
    new RateThreshold(185,37),
  ]);



}