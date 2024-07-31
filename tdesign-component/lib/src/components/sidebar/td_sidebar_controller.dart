import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDSideBarController extends ChangeNotifier {
  int currentValue = 0;
  List<SideItemProps> children = [];
  bool _loading = true;

  void selectTo(int value) {
    currentValue = value;
    notifyListeners();
  }

  void init(List<SideItemProps> data) {
    children = data;
    notifyListeners();
  }

  set loading(bool load) {
    _loading = load;
    notifyListeners();
  }

  bool get loading => _loading;

  @override
  void dispose() {
    super.dispose();
    currentValue = 0;
  }
}
