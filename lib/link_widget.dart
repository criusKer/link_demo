import 'package:flutter/material.dart';
import 'package:link_demo/position_model.dart';

import 'line_paint.dart';

/// create by crius on 2020/11/10
/// email:criusker@163.com

class LinkWidget extends StatefulWidget {

  final List answers;
  final List questions;

  const LinkWidget({
    Key key,
    @required this.answers,
    @required this.questions
  }) : super(key: key);

  @override
  _LinkWidgetState createState() => _LinkWidgetState();
}

class _LinkWidgetState extends State<LinkWidget> {

  List<GlobalKey> _answerKeys = [GlobalKey(),GlobalKey(),GlobalKey(),GlobalKey()];
  List<GlobalKey> _questionKeys = [GlobalKey(),GlobalKey(),GlobalKey(),GlobalKey()];
  PositionModel touchPosition = PositionModel();
  PositionModel line = PositionModel();
  List<PositionModel> lines = List<PositionModel>();

  // 判断触摸点是否在选项内
  bool _isInOption({@required double x, @required double y, @required RenderBox renderBox}){
    return x >= renderBox.localToGlobal(Offset.zero).dx &&
        x <= renderBox.localToGlobal(Offset.zero).dx + renderBox.size.width &&
        y >= renderBox.localToGlobal(Offset.zero).dy &&
        y <= renderBox.localToGlobal(Offset.zero).dy + renderBox.size.height;
  }

  // 初始化线条
  void _initLine(){
    setState(() {
      line.startX = null;
      line.startY = null;
      line.endX = null;
      line.endY = null;
    });
  }

  // 记录触摸点位置（因为onPanEnd里没看到能获取触摸点坐标的方法，就自己记录了 不知道有没有别的方式）
  void _setTouchPosition({@required double x, @required double y}){
    setState(() {
      touchPosition.startX = x;
      touchPosition.startY = y;
    });
  }

  // 记录起始点坐标
  void _setStartPosition({@required double startX, @required double startY}){
    setState(() {
      line.startX = startX;
      line.startY = startY;
      if(startX != null && startY != null) {
        // 判断已画线中的起始点或结束点是否和要传入的起始点坐标相同 若相同移除已画线
        lines.removeWhere((line){
          return line.startX == startX && line.startY == startY || line.endX == startX && line.endY == startY;
        });
      }
    });
  }

  // 获取结束点后添加画线
  void _addLine({@required double endX, @required double endY}){
    setState(() {
      // 判断已画线中的起始点或结束点是否和要传入的结束点坐标相同 若相同移除已画线
      lines.removeWhere((line){
        return line.startX == endX && line.startY == endY || line.endX == endX && line.endY == endY;
      });
      PositionModel model = PositionModel();
      model.startX = line.startX;
      model.startY = line.startY;
      model.endX = endX;
      model.endY = endY;
      lines.add(model);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details){
        _initLine();

        double x = details.globalPosition.dx;
        double y = details.globalPosition.dy;
        print("按下时x:$x,y:$y");
        // 按下时坐标与问题项位置比较
        for(int i = 0; i<widget.questions.length; i++){
          RenderBox renderBox = _questionKeys[i].currentContext.findRenderObject();
          if(_isInOption(x: x, y: y, renderBox: renderBox)){
            double startX = renderBox.localToGlobal(Offset(renderBox.size.width,renderBox.size.height)).dx;
            double startY = renderBox.localToGlobal(Offset(renderBox.size.width,renderBox.size.height)).dy - (renderBox.size.height / 2);

            _setStartPosition(startX: startX, startY: startY);
            return;
          }
        }
        // 按下时坐标与答案项位置比较
        for(int i = 0; i<widget.answers.length; i++){
          RenderBox renderBox = _answerKeys[i].currentContext.findRenderObject();
          if(_isInOption(x: x, y: y, renderBox: renderBox)){
            double startX = renderBox.localToGlobal(Offset.zero).dx;
            double startY = renderBox.localToGlobal(Offset.zero).dy + (renderBox.size.height / 2);

            _setStartPosition(startX: startX, startY: startY);
            return;
          }
        }
      },
      onPanUpdate: (details){
        _setTouchPosition(x: details.globalPosition.dx, y: details.globalPosition.dy);
      },
      onPanEnd: (_){
        // 存在起始坐标再执行记录结束坐标代码
        if(line.startX != null && line.startY != null){
          double x = touchPosition.startX;
          double y = touchPosition.startY;
          // 松开时坐标与答案项位置比较
          for(int i = 0; i< widget.answers.length; i++){
            RenderBox renderBox = _answerKeys[i].currentContext.findRenderObject();
            if(_isInOption(x: x, y: y, renderBox: renderBox)){
              print("松开时在${widget.answers[i]}里面！");
              double endX = renderBox.localToGlobal(Offset.zero).dx;
              double endY = renderBox.localToGlobal(Offset.zero).dy + (renderBox.size.height / 2);
              // 如果起始点和结束点的横坐标不同则记录结束点坐标
              if(line.startX != endX){
                _addLine(endX: endX, endY: endY);
              }else{
                print("不能将两个答案相连");
              }
              return;
            }
          }
          // 松开时坐标与问题项位置比较
          for(int i = 0; i< widget.questions.length; i++){
            RenderBox renderBox = _questionKeys[i].currentContext.findRenderObject();
            if(_isInOption(x: x, y: y, renderBox: renderBox)){
              print("松开时在${widget.questions[i]}里面！");
              double endX = renderBox.localToGlobal(Offset(renderBox.size.width,renderBox.size.height)).dx;
              double endY = renderBox.localToGlobal(Offset(renderBox.size.width,renderBox.size.height)).dy - (renderBox.size.height / 2);
              // 如果起始点和结束点的横坐标不同则记录结束点坐标
              if(line.startX != endX){
                _addLine(endX: endX, endY: endY);
              }else{
                print("不能将两个问题相连");
              }
              return;
            }
          }
        }else{
          print("没有按下时的坐标");
        }
      },
      child: CustomPaint(
        foregroundPainter: LinePainter(lines: lines),
        child: Container(
          margin: EdgeInsets.only(left: 17,right: 10),
          color: Colors.transparent,
          child: Row(
            children: <Widget>[
              listBuilder(list: widget.questions, keys: _questionKeys),
              listBuilder(list: widget.answers, keys: _answerKeys)
            ],
          ),
        ),
      ),
    );
  }

  Widget listBuilder({@required List list, @required List keys}){
    return Expanded(
      child: ListView.builder(
          itemCount: list.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index){
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Container(
                  key: keys[index],
                  width: 80,
                  height: 80,
                  alignment: Alignment.center,
                  color: Colors.red,
                  child: Text(list[index],style: TextStyle(
                      color: Colors.white
                  ),),
                ),
              ],
            );
          }),
    );
  }
}
