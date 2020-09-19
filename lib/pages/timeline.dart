import 'package:flutter/material.dart';
import 'package:turkshare/widgets/header.dart';
import 'package:turkshare/widgets/progress.dart';

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context,isAppTitle: true),
      body: circularProgress(),
    );
  }
}
