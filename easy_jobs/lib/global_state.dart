import 'package:flutter/cupertino.dart';

class GlobalState extends ChangeNotifier {
  String name = '';

  void setName(String n) {
    name = n;
    notifyListeners();
  }
}
