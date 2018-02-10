

class Table{

  List<Row> table = new List<Row>();

  add(Row row){
    table.add(row);
  }

}

class Row{
  String narrativeText;
  int narrativeIndent;

  num amount;
  int amountIndent;

  Row(this.narrativeText, this.narrativeIndent, this.amount, this.amountIndent);

}