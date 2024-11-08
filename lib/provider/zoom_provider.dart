import 'package:flutter/material.dart';

class ZoomProvider with ChangeNotifier {
  double _scaleFactor = 1.0;
  final double _minZoom = 0.5; // Valor mínimo para o fator de zoom
  final double _maxZoom = 2.0; // Valor máximo para o fator de zoom

  double get scaleFactor => _scaleFactor;

  void increaseZoom() {
    if (_scaleFactor < _maxZoom) {
      _scaleFactor += 0.1;
      if (_scaleFactor > _maxZoom) {
        _scaleFactor = _maxZoom;
      }
      notifyListeners();
    }
  }

  void decreaseZoom() {
    if (_scaleFactor > _minZoom) {
      _scaleFactor -= 0.1;
      if (_scaleFactor < _minZoom) {
        _scaleFactor = _minZoom;
      }
      notifyListeners();
    }
  }

  void resetZoom() {
    _scaleFactor = 1.0;
    notifyListeners();
  }
}
