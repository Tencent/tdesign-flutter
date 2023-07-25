import 'package:flutter/material.dart';

class TDSideBarController extends ChangeNotifier {
  int currentValue = 0;

  void selectTo(int value) {
    currentValue = value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
    currentValue = 0;
  }
}
