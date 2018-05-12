import 'package:taxlogic/src/utilities/date.dart';
import 'package:taxlogic/src/utilities/history/history.dart';



class Resolutions extends History<Resolution>{







  @override
  RegisterEntry newChange(Date date, Resolution resolution)=> new RegisterEntry(resolution);
}


class RegisterEntry extends Change<Resolution>{
  RegisterEntry(Resolution resolution) : super(resolution.date, resolution);

}


class Resolution{
  Date date;



}