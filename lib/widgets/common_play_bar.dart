import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloudMusic/const/constkey.dart';
import 'package:cloudMusic/core/base_widget.dart';

class PlayBar extends BaseStateLessWidget {
  @override
  Widget buildView() {
    return Container(
      width: ConstKey.MaxWidth,
      height: ConstKey.playHeight,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          ClipOval(
            child: Container(
                width: 35,
                height: 35,
                color: Colors.white,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://gw.alicdn.com/tps/TB1W_X6OXXXXXcZXVXXXXXXXXXX-400-400.png',
                  placeholder: (ctx, s) => Image.asset(
                    'images/ic_headimg.png',
                    width: 40,
                    height: 40,
                  ),
                )),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Text('xxxxxxxxx'), Text('xxx')],
          ),
          Expanded(child: Container()),
          Icon(
            Icons.play_circle_outline,
            color: Colors.black45,
          ),
          SizedBox(width: 15),
          Icon(
            Icons.favorite_border,
            color: Colors.black45,
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
