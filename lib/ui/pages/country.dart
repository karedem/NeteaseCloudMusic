import 'package:flutter/material.dart';
import 'package:cloudMusic/core/base_processer.dart';
import 'package:cloudMusic/core/base_widget.dart';

class CountryPage extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CountryState();
  }
}

class CountryState extends BaseState with TickerProviderStateMixin {
  TabController tabController;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pageController = PageController();
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            height: 55,
          ),
          viewPager()
        ],
      ),
    ));
  }

  Widget viewPager() {
    return Container(
        child: Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          indicator: BoxDecoration(),
          controller: tabController,
          onTap: (i) {
            pageController.jumpToPage(i);
          },
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: <Widget>[
            Tab(
              text: '精选',
            ),
            Tab(text: '非精选') //
          ],
        ),
        SizedBox(
          height: 490,
          child: PageView(
            //physics: NeverScrollableScrollPhysics(),
            controller: pageController,
            onPageChanged: (i) {
              tabController.animateTo(i);
            },
            children: <Widget>[
              Container(
                height: 500,
                color: Colors.black,
              ),
              Container(
                height: 500,
              )
            ],
          ),
        )
      ],
    ));
  }

  @override
  BaseProcesser getProcess() {
    return null;
  }
}
