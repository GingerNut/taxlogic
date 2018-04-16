



class RateTable{
  RateTable(this.table);

  final List<RateThreshold> table;

  num rate(num crtierion){

    if(table.length == 0) return null;

    int index = 1;

    while(index < table.length ){

      if(crtierion >= table[index].threshold) index ++;
      else break;
    }

    return table[index - 1].rate;
  }



}


class RateThreshold{
  RateThreshold(this.threshold, this.rate);

  final num threshold;
  final num rate;

}