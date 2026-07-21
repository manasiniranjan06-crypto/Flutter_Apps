

// controllers/alteration_controller.dart
import 'package:firebaseauth/TailorSide/controller/alternat_controller.dart';
import 'package:firebaseauth/TailorSide/model/alternationpage.dart';
import 'package:firebaseauth/TailorSide/respotory/alternat_Respotory.dart';
import 'package:flutter/material.dart';


class AlterationController extends ChangeNotifier {
  final AlterationRepository _repository;

  // State
  List<AlterationService> _services = [];
  List<AlterationCategory> _categories = [];
  List<AlterationRequest> _requests = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;
  String _errorMessage = '';
  List<AlterationService> _filteredServices = [];

  // Getters
  List<AlterationService> get services => _filteredServices;
  List<AlterationCategory> get categories => _categories;
  List<AlterationRequest> get requests => _requests;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AlterationController({required AlterationRepository repository})
      : _repository = repository;

  // Initialization
  Future<void> initialize() async {
    try {
      _setLoading(true);
      await _loadCategories();
      await _loadServices();
      _startRequestsListener();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to initialize: $e');
      _setLoading(false);
    }
  }

  // Load categories
  Future<void> _loadCategories() async {
    try {
      _categories = await _repository.getAlterationCategories();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load categories: $e');
    }
  }

  // Load services
  Future<void> _loadServices() async {
    try {
      _services = await _repository.getAlterationServices();
      _filterServices();
      notifyListeners();
    } catch (e) {
      _setError('Failed to load services: $e');
    }
  }

  // Start listening to requests
  void _startRequestsListener() {
    _repository.getAlterationRequests().listen((requests) {
      _requests = requests;
      notifyListeners();
    }, onError: (e) {
      _setError('Failed to load requests: $e');
    });
  }

  // Filter services based on category and search
  void _filterServices() {
    List<AlterationService> filtered = _services;

    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((service) => service.category == _selectedCategory).toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((service) =>
          service.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          service.description.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    _filteredServices = filtered;
  }

  // Update selected category
  void updateSelectedCategory(String category) {
    _selectedCategory = category;
    _filterServices();
    notifyListeners();
  }

  // Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _filterServices();
    notifyListeners();
  }

  // Update request status
  Future<void> updateRequestStatus(String requestId, String status) async {
    try {
      await _repository.updateRequestStatus(requestId, status);
      // The stream will automatically update the list
    } catch (e) {
      _setError('Failed to update status: $e');
      rethrow;
    }
  }

  // Add price quote
  Future<void> addPriceQuote(String requestId, double price, String notes) async {
    try {
      await _repository.addPriceQuote(requestId, price, notes);
      // The stream will automatically update the list
    } catch (e) {
      _setError('Failed to add price quote: $e');
      rethrow;
    }
  }

  // Get requests by status
  List<AlterationRequest> getRequestsByStatus(String status) {
    return _requests.where((request) => request.status == status).toList();
  }

  // Get popular services
  List<AlterationService> get popularServices {
    return _services.where((service) => service.isPopular).toList();
  }

  // Refresh data
  Future<void> refreshData() async {
    _setLoading(true);
    _clearError();
    await _loadServices();
    _setLoading(false);
  }

  // State management helpers
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}