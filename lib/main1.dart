import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloudMusic/bloc/counter_cubit.dart';
import 'package:cloudMusic/bloc/theme_cubit.dart';

import 'bloc/global_observer.dart';
import 'config/s.dart';

void main() {
  Bloc.observer = GlobalObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder: (ctx, theme) {
          return MaterialApp(
            theme: theme,
            home: CounterPage(),
          );
        },
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}

class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: BlocBuilder<CounterCubit, int>(
          builder: (context, state) {
            return Text('$state', style: textTheme.headline2);
          },
        ),
      ), //first see  30%, fit each other(xingge piqi sanguan) 40%, other match (goal background lifeable) 30%
      //70 is ok   15+5+25+5  5+5+35+10  20+30+20
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            key: const Key('counterView_increment_floatingActionButton'),
            child: const Icon(Icons.add),
            onPressed: () => context.bloc<CounterCubit>().increment(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_decrement_floatingActionButton'),
            child: const Icon(Icons.remove),
            onPressed: () => context.bloc<CounterCubit>().decrement(),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            key: const Key('counterView_changeTheme_floatingActionButton'),
            child: const Icon(Icons.close),
            onPressed: () => context.bloc<ThemeCubit>().changeTheme(),
          ),
        ],
      ),
    );
  }
}

class PageViewPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PageViewState();
  }
}

class PageViewState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: 700,
              child: PageView(
                children: <Widget>[NumberPage(0), NumberPage(1), NumberPage(2)],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class NumberPage extends StatelessWidget {
  int number = 0;
  NumberPage(this.number);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: 40),
          Container(
            height: 100,
            child: Text('这是第$number page'),
          ),
          Container(
            width: 400.0,
            height: 70.0,
            color: Colors.red,
            child: Text('1'),
//                      decoration: BoxDecoration(
//                          color: Colors.red, //Color(0xFFb6d4e2),
//                          borderRadius: BorderRadius.circular(setH(20)),
//                          border: Border.all(color: Colors.red)),
          ),
          Container(
            width: 400.0,
            height: 15.0,
            child: Text('1'),
            decoration: BoxDecoration(
                color: Colors.red,
                border: Border.all(color: Colors.red, width: 0.0),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5))),
          ),
          SizedBox(
            height: 300,
            child: ListView.builder(
              itemBuilder: (ctx, i) => ListTile(title: Text('123123')),
              itemCount: 10,
            ),
          )
        ],
      ),
    ));
  }
}
