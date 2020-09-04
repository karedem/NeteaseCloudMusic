import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloudMusic/const/constkey.dart';
import 'package:cloudMusic/core/base_widget.dart';
import 'package:cloudMusic/widgets/over_scroll_behavior.dart';

class MyPage extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyState();
  }
}

class MyState extends BaseState<MyPage> with TickerProviderStateMixin {
  @override
  getProcess() {
    return null;
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 55,
              color: Colors.brown,
            ),
            Expanded(
              child: ScrollConfiguration(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                        child: Container(height: 150, color: Colors.brown)),
                    SliverPersistentHeader(
                      pinned: true, //是否固定在顶部
                      floating: false,
                      delegate: _SliverAppBarDelegate(
                          minHeight: 30, //收起的高度
                          maxHeight: 30, //展开的最大高度
                          child: Stack(
                            children: <Widget>[
                              Container(
                                color: Colors.brown,
                                margin: EdgeInsets.only(bottom: 1),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(15),
                                        topRight: Radius.circular(15))),
                              )
                            ],
                          )),
                    ),
                    SliverToBoxAdapter(
                        child: Container(
                      height: 400,
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          Text('123123123123'),
                          Text('123123123123'),
                          Text('123123123123'),
                          Text('123123123123'),
                          Text('123123123123'),
                          Text('123123123123'),
                          Text('123123123123'),
                          Text('123123123123'),
                        ],
                      ),
                    )),
                    SliverToBoxAdapter(
                        child: Container(height: 400, color: Colors.grey[100])),
                  ],
                ),
                behavior: OverScrollBehavior(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

///顶部吸附代理
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
