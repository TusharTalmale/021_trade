import 'package:flutter/material.dart';
import 'package:trade_021/models/order.dart';

class OrderViewModel extends ChangeNotifier {
  String? selectedClient = 'AAA002';
  String _search = '';
  final List<String> tickers = ['RELIANCE', 'ASIANPAINT'];

  void setClient(String? client) {
    selectedClient = client;
    notifyListeners();
    filter();
  }

  void setSearch(String text) {
    _search = text.toLowerCase();
    notifyListeners();
    filter();
  }

  void removeTicker(String t) {
    tickers.remove(t);
    notifyListeners();
    filter();
  }

  void cancelAll() {
    // Logic to cancel all orders
    print('Canceling all orders...');
  }

  // filtered should be calculated
  List<Order> filtered = [];
  
  get allOrders => null;

  void filter() {
    filtered = allOrders.where((order) {
      final clientMatch = selectedClient == null || order.clientId == selectedClient;
      final tickerMatch = tickers.isEmpty || tickers.contains(order.ticker);
      final searchMatch = _search.isEmpty || order.ticker.toLowerCase().contains(_search);
      return clientMatch && tickerMatch && searchMatch;
    }).toList();
    notifyListeners();
  }
}
