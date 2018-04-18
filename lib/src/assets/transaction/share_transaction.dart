import 'package:taxlogic/src/assets/asset.dart';
import 'package:taxlogic/src/assets/transaction/transaction.dart';


class ShareTransaction extends Transaction{

  num numberOfShares;

  ShareTransaction(Asset asset) : super(asset);



}