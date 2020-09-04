import 'package:flutter_bloc/flutter_bloc.dart';

class GlobalObserver extends BlocObserver {
  @override
  void onChange(Cubit cubit, Change change) {
    print('onChange ${cubit.runtimeType} $change');
    super.onChange(cubit, change);
  }
}
