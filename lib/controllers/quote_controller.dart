import 'package:flutter/material.dart';

class QuoteController with ChangeNotifier {
  late bool isFavoriteStatus;

  QuoteController() {
    isFavoriteStatus = false;
  }

  toogleFavoriteStatus() {
    isFavoriteStatus = !isFavoriteStatus;
    notifyListeners();
  }
}
