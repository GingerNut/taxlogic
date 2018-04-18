import 'package:taxlogic/src/assets/value/valuation.dart';
import 'package:taxlogic/src/assets/value/value.dart';
import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/history.dart';



class ValueHistory extends History<Valuation>{






  @override
  ValueChange newChange(Date date, Valuation valuation) => new ValueChange(date, valuation);

  @override
  setNil() {
    new Valuation()
        ..amount = 0;
  }
}

class ValueChange extends Change<Valuation>{
  ValueChange(Date date, Valuation valuation) : super(date, valuation);


}