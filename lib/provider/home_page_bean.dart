import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:cloudMusic/provider/base_provider_bean.dart';

class HomePageCubit extends Cubit<HomePageBean> {
  HomePageCubit() : super(HomePageBean());

  setColor(alphal, textColor, unSelTextColor) {
    HomePageBean bean = HomePageBean()..drawKey = state.drawKey;
    bean.alphal = alphal;
    bean.textColor = textColor;
    bean.unSelTextColor = unSelTextColor;
    emit(bean);
  }
}

class HomePageBean {
  double alphal = 1.0;
  Color textColor = Colors.white;
  Color unSelTextColor = Colors.white60;
  GlobalKey<ScaffoldState> drawKey = GlobalKey<ScaffoldState>();
}
