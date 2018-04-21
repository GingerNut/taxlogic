import 'package:taxlogic/src/narrative/advice.dart';
import 'package:taxlogic/src/narrative/graphic.dart';



class FlowChart extends Advice{

  FlowChartStart start;






}


class FlowChartElement{
  List<DecisionBoxExit> exits = new List();

  String heading;
  String narrative;
  Graphic graphic;

}


class DecisionBoxExit extends FlowChartElement{

  FlowChartElement exit;
  String narrative;

}

class FlowChartStart extends FlowChartElement{



}


class FlowChartEndPoint extends FlowChartElement{




}