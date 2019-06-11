import 'package:flutter/material.dart';
import 'bloc_base.dart';

class BlockProvider<T extends BlocBase> extends StatefulWidget {
  BlockProvider({Key key, @required this.child, @required this.bloc}) : super(key: key);

  final T bloc;
  final Widget child;

  _BlockProviderState<T> createState() => _BlockProviderState<T>();

  // 用来通过上下文自身组件
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlockProvider<T>>();
    BlockProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;
}

class _BlockProviderState<T> extends State<BlockProvider<BlocBase>> {
  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}