import 'package:flutter/cupertino.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 't_swipe_cell_action.dart';

class TSwipeCellInherited extends InheritedWidget {
  const TSwipeCellInherited({
    Key? key,
    required Widget child,
    required this.cellClick,
    required this.actionClick,
    required this.duration,
    required this.controller,
  }) : super(child: child, key: key);

  final Duration duration;
  final void Function() cellClick;
  final bool Function(TSwipeCellAction action) actionClick;
  final SlidableController controller;

  @override
  bool updateShouldNotify(covariant TSwipeCellInherited oldWidget) {
    return true;
  }

  static TSwipeCellInherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TSwipeCellInherited>();
  }
}
