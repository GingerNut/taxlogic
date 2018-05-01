




class TaxBands{
  List<RateBand> bands = new List();
  num topRate = 0;

  num tax (num input){

    num untaxed = input;
    num tax = 0;
    int i = 0;


    while(untaxed > 0 && i < bands.length){


      if(untaxed > bands[i].band) {
        tax += bands[i].total;
        untaxed -= bands[i].band;
      }
      else {
        tax += bands[i].rate * untaxed;
        untaxed = 0;
      }

     i++;
    }

   tax += untaxed * topRate;

    return tax;
  }


  sortBands(){}



}


class RateBand{
  RateBand(this.band, this.rate);

  final num band;
  final num rate;

  num get total => band * rate;


}