import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloudMusic/core/base_widget.dart';

class VideoPage extends BaseStateLessWidget {
  @override
  Widget buildView() {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.red,
          ),
          Text('Video'),
        ],
      ),
    ));
  }
}
