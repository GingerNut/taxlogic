import 'package:taxlogic/src/utilities/history/lookup_table.dart';




class RateTable extends LookupTable<num>{
  RateTable.fromList(List<RateThreshold> table) : super.fromList(table);

  num valueAt(num crtierion)=> (getEntry(crtierion) as RateThreshold).rate;

}


class RateThreshold extends TableEntry<num>{
  RateThreshold(this.threshold, this.rate) : super(threshold);

  final num threshold;
  final num rate;
}