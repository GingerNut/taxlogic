import 'package:taxlogic/src/utilities/utilities.dart';
export 'payment.dart';

class Accounts{

  List<Account> accounts = new List();



  List<Account> get chart {
    List<Account> chart = new List();

    chart.add(new Account(01100, 'Cost'));

    return chart;
  }


}

class Account{

  int number;
  String name;
  num balance;

  Account(this.number, this.name);

}

class Entry{
  Date date;
  Debit debit;
  Credit credit;


}

class Journal{
  Date date;
  Debit debit;
  Credit credit;
  String narrative;

}

class Debit{
  Account account;
  num amount;



}

class Credit{
  Account account;
  num amount;

}