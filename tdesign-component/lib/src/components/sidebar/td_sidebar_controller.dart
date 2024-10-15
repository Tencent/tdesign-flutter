import 'package:flutter/material.dart';

import '../../../tdesign_flutter.dart';

class TDSideBarController extends ChangeNotifier {
  int currentValue = 0;
  List<SideItemProps> children = [];
  bool _loading = false;

  void selectTo(int value) {
    currentValue = value;
    notifyListeners();
  }

  void init(List<SideItemProps> data) {
    closeLoading(false, needNotify: false);
    children = data;
    notifyListeners();
  }

  void closeLoading(bool load, { bool needNotify = true }) {
    _loading = load;
    if(needNotify) {
      notifyListeners();
    }
  }

  set loading (bool load) {
    _loading = load;
  }

  bool get loading => _loading;

  @override
  void dispose() {
    super.dispose();
    currentValue = 0;
  }
}
