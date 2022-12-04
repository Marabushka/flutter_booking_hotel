import 'package:flutter/material.dart';
import 'package:hotel_database_app/entity/hotels.dart';

class HotelModel extends ChangeNotifier {
  int? _index;
  int? _adults;
  int? _children;

  Hotels? _hotels;
  Hotels? get hotels => _hotels;
  int? get index => _index;
  int? get adults => _adults;
  int? get children => _children;

  void getHotel(Map<String, dynamic>? data) {
    _hotels = Hotels.fromJson(data!);
    notifyListeners();
  }

  setIndex(int i) {
    _index = i;
    notifyListeners();
  }

  setPeopleCount(int adults, int children) {
    _adults = adults;
    _children = children;
    notifyListeners();
  }
}
