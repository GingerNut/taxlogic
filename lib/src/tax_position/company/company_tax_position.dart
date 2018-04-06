
import 'package:taxlogic/src/data/tax_data.dart';
import 'package:taxlogic/src/entities/entity.dart';
import 'package:taxlogic/src/tax_position/tax_position.dart';
import 'package:taxlogic/src/utilities/utilities.dart';



class CompanyTaxPosition extends TaxPosition{
  CompanyTaxPosition(this.company) : super (company);

  num incomeProfits;
  num gains = 0;
  num _totalProfits;
  num _tax = 0;

  final Company company;

  get totalProfits{

    _totalProfits = 0;

    income.forEach((inc){

      _totalProfits += inc.income;

    });

    incomeProfits = _totalProfits;

    _totalProfits += capitalGains();

    return _totalProfits;
  }

  capitalGains(){

    allocateLosses();

    num gain = 0;

    disposals.forEach((disposal){
      gain += disposal.taxableGain;
    });

    gains = gain;

    return gain;
  }

  void allocateLosses(){

    num lossesToAllocate = totalLossUsed;

    while(lossesToAllocate > 0){

      disposals.forEach((asset){
        if(lossesToAllocate < asset.taxableGain){
          asset.lossAllocated = lossesToAllocate;
          lossesToAllocate = 0;
        } else {
          asset.lossAllocated = asset.taxableGain;
          lossesToAllocate -= asset.lossAllocated;
        }

      });
    }
  }


  @override
  num get tax{

    _tax = 0;

    refreshDisposals();

    num profits = totalProfits;

    List<RatePeriod> periods = TaxData.CompanyRatePeriods(period);

    periods.forEach((part){
      _tax += profits * part.period.duration/period.duration * part.rate;
    });

    _tax = Utilities.roundTax(_tax);

    return _tax;

  }

}