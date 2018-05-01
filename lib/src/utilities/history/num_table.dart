import 'package:taxlogic/src/utilities/history/lookup_table.dart';




class NumTable extends LookupTable<num>{
  NumTable.fromList(List<NumThreshold> table) : super.fromList(table);

  num valueAt(num crtierion)=> (getEntry(crtierion) as NumThreshold).rate;

}


class NumThreshold extends TableEntry<num>{
  NumThreshold(this.threshold, this.rate) : super(threshold);

  final num threshold;
  final num rate;
}