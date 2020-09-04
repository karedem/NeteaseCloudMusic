import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloudMusic/bloc/theme_cubit.dart';
import 'package:cloudMusic/const/constkey.dart';
import 'package:cloudMusic/provider/home_page_bean.dart';
import 'package:cloudMusic/ui/pages/country.dart';
import 'package:cloudMusic/ui/pages/find.dart';
import 'package:cloudMusic/ui/pages/my.dart';
import 'package:cloudMusic/ui/pages/video.dart';
import 'package:cloudMusic/utils/log_plus.dart';
import 'package:cloudMusic/widgets/common_btn.dart';
import 'package:cloudMusic/widgets/common_inkwell.dart';
import 'package:cloudMusic/widgets/common_play_bar.dart';
import 'package:cloudMusic/widgets/over_scroll_behavior.dart';
import 'package:cloudMusic/flutter/gh_page_view.dart' as GhPage;
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  List<Widget> pages = [];
  TabController _tabController;
  PageController _pageController;
  HomePageCubit homeCubit = HomePageCubit();
  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController(initialPage: 0);
    pages.add(MyPage());
    pages.add(FindPage());
    pages.add(CountryPage());
    pages.add(VideoPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: homeCubit,
      child: Scaffold(
        key: homeCubit.state.drawKey,
        drawer: Drawer(
          child: Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: ScrollConfiguration(
                    child: CustomScrollView(
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Stack(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                height: 180,
                                decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [
                                  Color(0xFFCC514C),
                                  Color(0xFFd36e53)
                                ])),
                                child: Column(
                                  children: <Widget>[],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 160),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                          color: context
                                              .bloc<ThemeCubit>()
                                              .state
                                              .scaffoldBackgroundColor,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      padding:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      width: 600,
                                      child: userInfoArea(),
                                    ),
                                    menuItem(
                                        '听歌识曲',
                                        IconData(0xe612,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '演出',
                                        IconData(0xe66f,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '商城',
                                        IconData(0xe613,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '附近的人',
                                        IconData(0xe683,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '口袋彩铃',
                                        IconData(0xe675,
                                            fontFamily: 'iconfont')),
                                    Container(
                                      width: 400,
                                      height: 0.5,
                                      color: Colors.grey,
                                    ),
                                    menuItem(
                                        '我的订单',
                                        IconData(0xe637,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '定时停止播放',
                                        IconData(0xe6f1,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '扫一扫',
                                        IconData(0xe69f,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '音乐闹钟',
                                        IconData(0xe744,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '音乐云盘',
                                        IconData(0xe7f1,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '免流量',
                                        IconData(0xe6bd,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '优惠券',
                                        IconData(0xe60a,
                                            fontFamily: 'iconfont')),
                                    menuItem(
                                        '青少年模式',
                                        IconData(0xe628,
                                            fontFamily: 'iconfont'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    behavior: OverScrollBehavior(),
                  ),
                ),
                bottomArea(),
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Stack(children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(child: sliverBarContent()),
                PlayBar()
              ],
            ),
            BlocBuilder<HomePageCubit, HomePageBean>(
              builder: (ctx, bean) {
                return Opacity(
                    opacity: bean.alphal,
                    child: Container(
                      height: 55,
                      child: AppBar(
                        leading: GestureDetector(
                          child: Icon(
                            Icons.menu,
                            color: bean.textColor,
                          ),
                          onTap: () {
                            bean.drawKey.currentState.openDrawer();
                          },
                        ),
                        elevation: 0.0,
                        backgroundColor: Colors.transparent,
                        title: commonTabs(bean.textColor, bean.unSelTextColor),
                        actions: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 15),
                            child: Icon(
                              Icons.search,
                              color: bean.textColor,
                            ),
                          )
                        ],
                      ),
                    ));
              },
            )
          ]),
        ),
      ),
    );
  }

  Widget bottomArea() {
    return Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black12, width: 0.5))),
        height: ConstKey.playHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            CommonInkwell(
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(IconData(0xe611, fontFamily: 'iconfont')),
                  BlocBuilder<ThemeCubit, ThemeData>(
                    builder: (ctx, theme) => Text(
                        theme.brightness == Brightness.light ? '夜间模式' : '白天模式'),
                  )
                ],
              ),
              tap: () {
                context.bloc<ThemeCubit>().changeTheme();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(IconData(0xe614, fontFamily: 'iconfont')),
                Text('设置')
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(IconData(0xe623, fontFamily: 'iconfont')),
                Text('退出')
              ],
            )
          ],
        ));
  }

  Widget userInfoArea() {
    bool ifLogin = true;
    if (ifLogin) {
      return Row(
        children: <Widget>[
          SizedBox(width: 15),
          ClipOval(
            child: Container(
                width: 35,
                height: 35,
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
          Text('慢慢摇'),
          Expanded(child: Container()),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.add_location,
                ),
                Text(
                  '签到',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          SizedBox(
            width: 10,
          )
        ],
      );
    } else {
      return Column(children: <Widget>[
        Text('手机电脑多端同步, 尽享海量高品质音乐'),
        CommonBtn(
            Container(
              height: 40,
              width: 100,
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(20)),
              child: Text(
                '立即登陆',
                style: TextStyle(color: Colors.white),
              ),
            ),
            () {})
      ]);
    }
  }

  Widget menuItem(String til, IconData icon, {String subTil}) {
    return CommonInkwell(Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        height: 50,
        child: Row(children: <Widget>[
          Icon(icon),
          SizedBox(width: 5),
          Text(til),
          Expanded(child: Container()),
          Text(subTil ?? '')
        ])));
  }

  Widget commonTabs(textColor, unSelTextColor) {
    return TabBar(
      onTap: (i) {
        //Change to i
        _pageController.jumpToPage(i);
      },
      labelPadding: EdgeInsets.only(left: 10, right: 10),
      indicatorPadding: EdgeInsets.only(left: 5, right: 5),
      isScrollable: true,
      indicator: BoxDecoration(),
      indicatorColor: textColor,
      controller: _tabController,
      labelColor: textColor,
      unselectedLabelColor: unSelTextColor,
      labelStyle: TextStyle(fontSize: 18.0),
      //unselectedLabelStyle: TextStyle(fontSize: 16.0),
      tabs: <Widget>[
        Tab(
          text: '我的', //'我的',
        ),
        Tab(
          text: '发现', //'''发现',
        ),
        Tab(
          text: '云村', //'云村',
        ),
        Tab(
          text: '视频', //'视频',
        )
      ],
    );
  }

  ///主页 播放栏以上的部分
  Widget sliverBarContent() {
    return Container(
      width: 750,
      child: Stack(
        children: <Widget>[
          GhPage.PageView(
            controller: _pageController,
            children: pages,
            onPageChanged: (i) {
              _tabController.animateTo(i);
            },
            scrollChanged: (double page) {
              ///根据当前页的滑动距离 渐变背景 文字颜色 透明度
              if (page > 1) {
                ///不处理
                return;
              }
              LogPlus.i("page: $page");
              Color textColor = Colors.black;
              Color unSelTextColor = Colors.black45;
              double alphal = page * page;
              if (page < 0.5) {
                textColor = Colors.white;
                unSelTextColor = Colors.white60;
                alphal = (1 - page) * (1 - page);
              }
              homeCubit.setColor(alphal, textColor, unSelTextColor);

              ///透明度变化 1 -> 0.5 -> 1
              ///文字颜色变化 白 -> 灰 ->黑
              ///
            },
          ),
        ],
      ),
    );
  }
}
