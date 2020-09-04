import 'package:flutter/material.dart';
import 'package:cloudMusic/core/base_processer.dart';
import 'package:cloudMusic/core/base_widget.dart';

class LoginPage extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {}
}

class LoginState extends BaseState {
  @override
  BaseProcesser getProcess() {
    return null;
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: <Widget>[
          Image.asset(
            '',
            fit: BoxFit.cover,
          ),
          Column(
            children: <Widget>[
              Expanded(child: Container()),
              Row(
                children: <Widget>[
                  Text('账号'),
                  TextField(
                    decoration: InputDecoration(hintText: '手机号或邮箱'),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Text('密码'),
                  TextField(
                    decoration: InputDecoration(hintText: ''),
                  )
                ],
              )
            ],
          )
        ],
      ),
    ));
  }
}
