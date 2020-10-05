import 'package:flutter/material.dart';

class Searching with ChangeNotifier {
  bool buscando = false;
  bool text = false;

  void buscar() {
    buscando = true;
    text = true;
    notifyListeners();
  }

  void nobuscar() {
    buscando = false;
    text = false;
    notifyListeners();
  }
}
