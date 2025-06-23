import 'package:flutter/material.dart';
import 'package:trade_021/models/order.dart';
import '../data/mock_data.dart';

class OrderController extends ChangeNotifier {
  // --- STATE VARIABLES ---

  // The original, unfiltered list of all orders.
  List<Order> _allOrders = [];

  // The list of orders currently displayed on the screen, after filtering and sorting.
  List<Order> _displayedOrders = [];
  List<Order> get displayedOrders => _displayedOrders;

  // Filter-related state
  String? _selectedClientFilter;
  final List<String> _selectedTickerFilters = [];
  String _searchQuery = '';
  
  // A list of all unique client IDs, extracted from the mock data.
  List<String> get uniqueClients =>
      { for (var order in _allOrders) order.client }.toList();

  // Sorting-related state
  int? _sortColumnIndex;
  bool _sortAscending = true;
  int? get sortColumnIndex => _sortColumnIndex;
  bool get sortAscending => _sortAscending;

  // Pagination-related state
  final int _rowsPerPage = 8;
  int _currentPage = 0;
  int get currentPage => _currentPage;
  int get totalPages => (_filteredOrders.length / _rowsPerPage).ceil();

  // The list of orders for the current page.
  List<Order> get ordersForCurrentPage {
      int start = _currentPage * _rowsPerPage;
      int end = start + _rowsPerPage;
      if (end > _filteredOrders.length) {
        end = _filteredOrders.length;
      }
      return _filteredOrders.getRange(start, end).toList();
  }
  
  // The full list of filtered orders, before pagination is applied.
  List<Order> _filteredOrders = [];


  // --- INITIALIZATION ---
  OrderController() {
    _initializeOrders();
  }

  void _initializeOrders() {
    _allOrders = List.from(mockOrders); // Make a mutable copy
    _applyFiltersAndSort();
  }

  // --- FILTERING AND SORTING LOGIC ---

  void _applyFiltersAndSort() {
    // 1. Apply Filters
    _filteredOrders = _allOrders.where((order) {
      final clientMatch = _selectedClientFilter == null || order.client == _selectedClientFilter;
      final tickerMatch = _selectedTickerFilters.isEmpty || _selectedTickerFilters.contains(order.ticker);
      final searchMatch = _searchQuery.isEmpty ||
          order.ticker.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order.client.toLowerCase().contains(_searchQuery.toLowerCase());
      return clientMatch && tickerMatch && searchMatch;
    }).toList();

    // 2. Apply Sorting
    if (_sortColumnIndex != null) {
      _sortData(_sortColumnIndex!, _sortAscending);
    }
    
    // 3. Reset pagination and notify listeners
    _currentPage = 0;
    notifyListeners();
  }
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFiltersAndSort();
  }

  void setClientFilter(String? client) {
    _selectedClientFilter = client;
    _applyFiltersAndSort();
  }

  void addTickerFilter(String ticker) {
    if (!_selectedTickerFilters.contains(ticker)) {
      _selectedTickerFilters.add(ticker);
      _applyFiltersAndSort();
    }
  }

  void removeTickerFilter(String ticker) {
    _selectedTickerFilters.remove(ticker);
    _applyFiltersAndSort();
  }

  List<String> get activeTickerFilters => _selectedTickerFilters;
  String? get activeClientFilter => _selectedClientFilter;


  // --- DATA TABLE ACTIONS ---

  void sort(int columnIndex) {
    if (_sortColumnIndex == columnIndex) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumnIndex = columnIndex;
      _sortAscending = true;
    }
    _sortData(columnIndex, _sortAscending);
    notifyListeners();
  }

  void _sortData(int columnIndex, bool ascending) {
    _filteredOrders.sort((a, b) {
      int comparison;
      switch (columnIndex) {
        case 0: // Time
          comparison = a.time.compareTo(b.time);
          break;
        case 1: // Client
          comparison = a.client.compareTo(b.client);
          break;
        case 4: // Product
          comparison = a.productString.compareTo(b.productString);
          break;
        default:
          return 0;
      }
      return ascending ? comparison : -comparison;
    });
  }

  void deleteOrder(String id) {
    _allOrders.removeWhere((order) => order.id == id);
    _applyFiltersAndSort();
  }
  
  void cancelAllOrders() {
    _allOrders.clear();
    _applyFiltersAndSort();
  }
  
  void downloadOrders() {
      // In a real app, this would trigger a file download (e.g., CSV).
      // For this assignment, we'll just print to the console.
      print("Downloading orders...");
      for (var order in _filteredOrders) {
        print('Client: ${order.client}, Ticker: ${order.ticker}, Price: ${order.price}');
      }
      print("Download complete.");
  }


  // --- PAGINATION ---

  void nextPage() {
    if ((_currentPage + 1) < totalPages) {
      _currentPage++;
      notifyListeners();
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }
}

