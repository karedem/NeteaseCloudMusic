import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cloudMusic/provider/home_page_bean.dart';
import 'package:cloudMusic/ui/pages/home.dart';
import 'package:cloudMusic/ui/pages/launch/launch.dart';
import 'package:cloudMusic/utils/route_utils.dart';

import 'bloc/global_observer.dart';
import 'bloc/theme_cubit.dart';
import 'config/s.dart';

void main() {
  Bloc.observer = GlobalObserver();
  runApp(MyApp());
}

final Map<String, WidgetBuilder> routes = {
  Routes.HOME: (ctx) => HomePage(),
  Routes.LAUNCH: (ctx) => LaunchPage(),
};

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(
            create: (BuildContext context) => ThemeCubit(),
          ),
//          BlocProvider<HomePageCubit>(
//            create: (BuildContext context) => HomePageCubit(),
//          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeData>(builder: (ctx, theme) {
          return MaterialApp(
            navigatorKey: RouteUtils.KEY,
            onGenerateTitle: (ctx) {
              return S.of(ctx).taskTitle;
            },
            theme: theme,
            //坚信可以喜欢很久 不计较付出
//      theme: ThemeData(
//        primarySwatch: Colors.blue,
//        visualDensity: VisualDensity.adaptivePlatformDensity,
//      ),
            initialRoute: '/home',
            routes: routes,
            localizationsDelegates: [
              const S(),
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', ''),
              const Locale('zh', ''),
            ],
          );
        }));
  }
}

class Routes {
  //static final String INDEX = '/';
  static const String HOME = '/home';
  static const String LAUNCH = '/launch';
}
