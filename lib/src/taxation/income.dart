import '../entities/entity.dart';
import 'taxation.dart';
import '../tax_position/tax_position.dart';

abstract class Income extends Taxation{


  Income(TaxPosition taxPosition) : super(taxPosition);

}