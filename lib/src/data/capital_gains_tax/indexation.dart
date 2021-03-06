import 'package:taxlogic/src/utilities/date.dart';
import 'dart:math';
import 'package:taxlogic/src/utilities/utilities.dart';

class Indexation{
  

  static var RPI1982 = [78.73, 78.76, 79.44, 81.04, 81.62, 81.85, 81.88, 81.90, 81.85, 82.26, 82.66, 82.51];
  static var RPI1983 = [82.61, 82.97, 83.12, 84.28, 84.64, 84.84, 85.30, 85.68, 86.06, 86.36, 86.67, 86.89];
  static var RPI1984 = [86.84, 87.20, 87.48, 88.64, 88.97, 89.20, 89.10, 89.94, 90.11, 90.67, 90.95, 90.87];
  static var RPI1985 = [91.20, 91.94, 92.80, 94.78, 95.21, 95.41, 95.23, 95.49, 95.44, 95.59, 95.92, 96.05];
  static var RPI1986 = [96.25, 96.60, 96.73, 97.67, 97.85, 97.79, 97.52, 97.82, 98.30, 98.45, 99.29, 99.62];
  static var RPI1987 = [100.0, 100.4, 100.6, 101.8, 101.9, 101.9, 101.8, 102.1, 102.4, 102.9, 103.4, 103.3];
  static var RPI1988 = [103.3, 103.7, 104.1, 105.8, 106.2, 106.6, 106.7, 107.9, 108.4, 109.5, 110.0, 110.3];
  static var RPI1989 = [111.0, 111.8, 112.3, 114.3, 115.0, 115.4, 115.5, 115.8, 116.6, 117.5, 118.5, 118.8];
  static var RPI1990 = [119.5, 120.2, 121.4, 125.1, 126.2, 126.7, 126.8, 128.1, 129.3, 130.3, 130.0, 129.9];
  static var RPI1991 = [130.2, 130.9, 131.4, 133.1, 133.5, 134.1, 133.8, 134.1, 134.6, 135.1, 135.6, 135.7];
  static var RPI1992 = [135.6, 136.3, 136.7, 138.8, 139.3, 139.3, 138.8, 138.9, 139.4, 139.9, 139.7, 139.2];
  static var RPI1993 = [137.9, 138.8, 139.3, 140.6, 141.1, 141.0, 140.7, 141.3, 141.9, 141.8, 141.6, 141.9];
  static var RPI1994 = [141.3, 142.1, 142.5, 144.2, 144.7, 144.7, 144.0, 144.7, 145.0, 145.2, 145.3, 146.0];
  static var RPI1995 = [146.0, 146.9, 147.5, 149.0, 149.6, 149.8, 149.1, 149.9, 150.6, 149.8, 149.8, 150.7];
  static var RPI1996 = [150.2, 150.9, 151.5, 152.6, 152.9, 153.0, 152.4, 153.1, 153.8, 153.8, 153.9, 154.4];
  static var RPI1997 = [154.4, 155.0, 155.4, 156.3, 156.9, 157.5, 157.5, 158.5, 159.3, 159.5, 159.6, 160.0];
  static var RPI1998 = [159.5, 160.3, 160.8, 162.6, 163.5, 163.4, 163.0, 163.7, 164.4, 164.5, 164.4, 164.4];
  static var RPI1999 = [163.4, 163.7, 164.1, 165.2, 165.6, 165.6, 165.1, 165.5, 166.2, 166.5, 166.7, 167.3];
  static var RPI2000 = [166.6, 167.5, 168.4, 170.1, 170.7, 171.1, 170.5, 170.5, 171.7, 171.6, 172.1, 172.2];
  static var RPI2001 = [171.1, 172.0, 172.2, 173.1, 174.2, 174.4, 173.3, 174.0, 174.6, 174.3, 173.6, 173.4];
  static var RPI2002 = [173.3, 173.8, 174.5, 175.7, 176.2, 176.2, 175.9, 176.4, 177.6, 177.9, 178.2, 178.5];
  static var RPI2003 = [178.4, 179.3, 179.9, 181.2, 181.5, 181.3, 181.3, 181.6, 182.5, 182.6, 182.7, 183.5];
  static var RPI2004 = [183.1, 183.8, 184.6, 185.7, 186.5, 186.8, 186.8, 187.4, 188.1, 188.6, 189.0, 189.9];
  static var RPI2005 = [188.9, 189.6, 190.5, 191.6, 192.0, 192.2, 192.2, 192.6, 193.1, 193.3, 193.6, 194.1];
  static var RPI2006 = [193.4, 194.2, 195.0, 196.5, 197.7, 198.5, 198.5, 199.2, 200.1, 200.4, 201.1, 202.7];
  static var RPI2007 = [201.6, 203.1, 204.4, 205.4, 206.2, 207.3, 206.1, 207.3, 208.0, 208.9, 209.7, 210.9];
  static var RPI2008 = [209.8, 211.4, 212.1, 214.0, 215.1, 216.8, 216.5, 217.2, 218.4, 217.7, 216.0, 212.9];
  static var RPI2009 = [210.1, 211.4, 211.3, 211.5, 212.8, 213.4, 213.4, 214.4, 215.3, 216.0, 216.6, 218.0];
  static var RPI2010 = [217.9, 219.2, 220.7, 222.8, 223.6, 224.1, 223.6, 224.5, 225.3, 225.8, 226.8, 228.4];
  static var RPI2011 = [229.0, 231.3, 232.5, 234.4, 235.2, 235.2, 234.7, 236.1, 237.9, 238.0, 238.5, 239.4];
  static var RPI2012 = [238.0, 239.9, 240.8, 242.5, 242.4, 241.8, 242.1, 243.0, 244.2, 245.6, 245.6, 246.8];
  static var RPI2013 = [245.8, 247.6, 248.7, 249.5, 250.0, 249.7, 249.7, 251.0, 251.9, 251.9, 252.1, 253.4];
  static var RPI2014 = [252.6, 254.2, 254.8, 255.7, 255.9, 256.3, 256.0, 257.0, 257.6, 257.7, 257.1, 257.5];
  static var RPI2015 = [255.4, 256.7, 257.1, 258.0, 258.5, 258.9, 258.6, 259.8, 259.6, 259.5, 259.8, 260.6];
  static var RPI2016 = [258.8, 260.0, 261.1, 261.4, 262.1, 263.1, 263.4, 264.4, 264.9, 264.8, 265.5, 267.1];
  static var RPI2017 = [265.5, 268.4, 269.3, 270.6, 271.7, 272.3, 272.9, 274.7, 275.1, 275.3, 275.8, 278.1];



  static num RPI(Date date){
    if(date.year > 2017 ) return 278.1;
    if(date.year <= 1982 && date.month < 3) return 79.44;
    if(date.year < 1982) return 79.44;
    
    var RPIlist;
    
    switch(date.year){
      
      case 1982 : RPIlist = RPI1982; break;
      case 1983 : RPIlist = RPI1983; break;
      case 1984 : RPIlist = RPI1984; break;
      case 1985 : RPIlist = RPI1985; break;
      case 1986 : RPIlist = RPI1986; break;
      case 1987 : RPIlist = RPI1987; break;
      case 1988 : RPIlist = RPI1988; break;
      case 1989 : RPIlist = RPI1989; break;

      case 1990 : RPIlist = RPI1990; break;
      case 1991 : RPIlist = RPI1991; break;
      case 1992 : RPIlist = RPI1992; break;
      case 1993 : RPIlist = RPI1993; break;
      case 1994 : RPIlist = RPI1994; break;
      case 1995 : RPIlist = RPI1995; break;
      case 1996 : RPIlist = RPI1996; break;
      case 1997 : RPIlist = RPI1997; break;
      case 1998 : RPIlist = RPI1998; break;
      case 1999 : RPIlist = RPI1999; break;

      case 2000 : RPIlist = RPI2000; break;
      case 2001 : RPIlist = RPI2001; break;
      case 2002 : RPIlist = RPI2002; break;
      case 2003 : RPIlist = RPI2003; break;
      case 2004 : RPIlist = RPI2004; break;
      case 2005 : RPIlist = RPI2005; break;
      case 2006 : RPIlist = RPI2006; break;
      case 2007 : RPIlist = RPI2007; break;
      case 2008 : RPIlist = RPI2008; break;
      case 2009 : RPIlist = RPI2009; break;

      case 2010 : RPIlist = RPI2010; break;
      case 2011 : RPIlist = RPI2011; break;
      case 2012 : RPIlist = RPI2012; break;
      case 2013 : RPIlist = RPI2013; break;
      case 2014 : RPIlist = RPI2014; break;
      case 2015 : RPIlist = RPI2015; break;
      case 2016 : RPIlist = RPI2016; break;
      case 2017 : RPIlist = RPI2017; break;

    }

    return RPIlist[date.month -1 ];

  }
  
  
  static num indexation(Date purchase, Date sale){

    if(purchase == null || sale == null) return 0;

    num rpisale = RPI(sale);
    num rpipurchase = RPI(purchase);

    return Utilities.roundTo((max(rpisale - rpipurchase,0))/rpipurchase,3);

  }

}