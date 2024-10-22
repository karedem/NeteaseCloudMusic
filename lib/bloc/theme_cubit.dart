import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

class ThemeCubit extends Cubit<ThemeData> {
  static final _lightTheme = ThemeData(
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: Colors.white),
      brightness: Brightness.light);
  static final _darkTheme = ThemeData(
      floatingActionButtonTheme:
          const FloatingActionButtonThemeData(foregroundColor: Colors.black38),
      brightness: Brightness.dark);

  ThemeCubit() : super(_lightTheme);

  void changeTheme() {
    emit(state.brightness == Brightness.dark ? _lightTheme : _darkTheme);
  }
}
