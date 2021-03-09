import 'package:flutter/foundation.dart';

class NumberProvider extends ChangeNotifier {
  int currentNumber = 10;

  void updateCurrentNumber() {
    currentNumber += 1;
    notifyListeners();
  }
}
