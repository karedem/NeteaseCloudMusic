import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cloudMusic/core/base_processer.dart';
import 'package:cloudMusic/core/base_widget.dart';
import 'package:cloudMusic/flutter/gh_page_view.dart' as GhPage;

class FindState extends BaseState with TickerProviderStateMixin {
  SwiperController controller = SwiperController();
  TabController tabController;
  PageController pageController;

  @override
  BaseProcesser getProcess() {
    return null;
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    pageController = PageController(initialPage: 0);
  }

  @override
  Widget buildView(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Container(height: 55),
        Expanded(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: topSwiper(),
              ),
              SliverToBoxAdapter(
                child: rowList(),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('精选'),
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text('查看更多')
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: rowSongList(),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('藏着'),
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text('查看更多')
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: recommendSongs(),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('精选'),
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text('查看更多')
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: rowSongList(),
              ),
              SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('精选'),
                    SizedBox(
                      width: 100,
                    ),
                    SizedBox(
                      width: 100,
                    ),
                    Text('查看更多')
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: rowSongList(),
              ),
              SliverToBoxAdapter(
                child: viewPager(),
              ),
            ],
          ),
        )
      ],
    )));
  }

  Widget topSwiper() {
    return Container(
      height: 200,
      child: Swiper(
        controller: controller,
        itemCount: 3,
        itemBuilder: (ctx, i) {
          return Container(
            child: CachedNetworkImage(
              imageUrl:
                  'http://wxapit.qtwo.fun/image/carousel/gua_bg_5_new.png',
              fit: BoxFit.fill,
              width: 500,
              height: 200,
              placeholder: (context, url) => SizedBox(
                  width: 10, height: 10, child: CupertinoActivityIndicator()),
              errorWidget: (context, url, error) => Icon(
                Icons.error,
                size: 50,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget rowList() {
    return Container(
      height: 100,
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            width: 60,
            height: 80,
            color: Colors.grey[100],
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: 10,
      ),
    );
  }

  Widget rowSongList() {
    return Container(
      height: 100,
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            width: 60,
            height: 80,
            color: Colors.grey[100],
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: 10,
      ),
    );
  }

  Widget recommendSongs() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemBuilder: (ctx, i) {
          return Container(
            margin: EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                  width: 300,
                  height: 60,
                  color: Colors.grey[100],
                ),
                Container(
                  width: 300,
                  height: 60,
                  color: Colors.grey[100],
                ),
                Container(
                  width: 300,
                  height: 60,
                  color: Colors.grey[100],
                )
              ],
            ),
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: 3,
      ),
    );
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
          height: 120,
          child: PageView(
            controller: pageController,
            onPageChanged: (i) {
              tabController.animateTo(i);
            },
            children: <Widget>[
              Container(
                height: 100,
                color: Colors.black,
              ),
              Container(
                height: 100,
              )
            ],
          ),
        )
      ],
    ));
  }
}

class FindPage extends BaseStatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return FindState();
  }
}
