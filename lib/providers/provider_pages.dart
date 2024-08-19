import 'package:flutter/material.dart';

class ProviderPages extends ChangeNotifier{
  int _pageIndex = 0;
  int get pageIndex => _pageIndex;

  set pageIndex(int v){
    _pageIndex = v;
    notifyListeners();
  }
}