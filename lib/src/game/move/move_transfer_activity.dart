
import 'package:taxlogic/src/game/move/move.dart';
import 'package:taxlogic/src/game/position/position.dart';
import 'package:taxlogic/src/activity/activity.dart';
import '../../entities/entity.dart';
import 'package:taxlogic/src/utilities/date.dart';
import '../../assets/value.dart';

class TransferActivity extends Move{
  Date date;
 Activity subject;
 Entity from;
 Entity to;
 Value value;
 num consideration;
 bool holdover;
 bool lossTransfer;
 String narrative;

  TransferActivity(
      this.date,
      this.subject,
      this.from,
      this.to,
      this.value,
      this.consideration,
      this.holdover,
      this.lossTransfer,
      this.narrative);


  @override
  doMove(Position position) {

    subject.transferToEntity(date, to, value);

  }


}