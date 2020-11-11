
/// create by crius on 2020/11/6
/// email:criusker@163.com

class PositionModel{
  double startX;
  double startY;
  double endX;
  double endY;

  PositionModel({this.startX, this.startY, this.endX, this.endY});

  @override
  String toString() {
    return 'PositionModel{startX: $startX, startY: $startY, endX: $endX, endY: $endY}';
  }
}