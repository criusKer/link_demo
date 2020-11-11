import 'package:flutter/material.dart';
import 'package:link_demo/link_widget.dart';

/// create by crius on 2020/11/10
/// email:criusker@163.com

class LinkPage extends StatefulWidget {
  @override
  _LinkPageState createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {

  List answers = ["A","B","C","D"];
  List questions = ["鸡","鸭","鱼","肉"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("连一连",style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: LinkWidget(
        answers: answers,
        questions: questions,
      ),
    );
  }
}
