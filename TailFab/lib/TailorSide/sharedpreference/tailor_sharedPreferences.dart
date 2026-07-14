import 'package:shared_preferences/shared_preferences.dart';

class TailorPreferencesService {
  static final TailorPreferencesService _instance = TailorPreferencesService._internal();
  factory TailorPreferencesService() => _instance;
  TailorPreferencesService._internal();

  static SharedPreferences? _preferences;

  // Initialize SharedPreferences
  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Ensure preferences are initialized
  Future<void> _ensureInitialized() async {
    if (_preferences == null) {
      await init();
    }
  }

  // Tailor Profile Data
  Future<void> setTailorName(String name) async {
    await _ensureInitialized();
    await _preferences!.setString('tailor_name', name);
  }

  Future<String> getTailorName() async {
    await _ensureInitialized();
    return _preferences!.getString('tailor_name') ?? 'Tailor';
  }

  Future<void> setShopName(String shopName) async {
    await _ensureInitialized();
    await _preferences!.setString('shop_name', shopName);
  }

  Future<String> getShopName() async {
    await _ensureInitialized();
    return _preferences!.getString('shop_name') ?? 'My Tailor Shop';
  }

  Future<void> setShopLocation(String location) async {
    await _ensureInitialized();
    await _preferences!.setString('shop_location', location);
  }

  Future<String> getShopLocation() async {
    await _ensureInitialized();
    return _preferences!.getString('shop_location') ?? 'Pune';
  }

  Future<void> setShopAddress(String address) async {
    await _ensureInitialized();
    await _preferences!.setString('shop_address', address);
  }

  Future<String> getShopAddress() async {
    await _ensureInitialized();
    return _preferences!.getString('shop_address') ?? '';
  }

  Future<void> setPhoneNumber(String phone) async {
    await _ensureInitialized();
    await _preferences!.setString('tailor_phone', phone);
  }

  Future<String> getPhoneNumber() async {
    await _ensureInitialized();
    return _preferences!.getString('tailor_phone') ?? '';
  }

  // Business Hours
  Future<void> setBusinessHours(Map<String, String> hours) async {
    await _ensureInitialized();
    final hoursList = hours.entries.map((e) => '${e.key}:${e.value}').toList();
    await _preferences!.setStringList('business_hours', hoursList);
  }

  Future<Map<String, String>> getBusinessHours() async {
    await _ensureInitialized();
    final hoursList = _preferences!.getStringList('business_hours') ?? [];
    Map<String, String> hours = {};
    
    for (var hour in hoursList) {
      final parts = hour.split(':');
      if (parts.length == 2) {
        hours[parts[0]] = parts[1];
      }
    }
    
    // Default business hours
    if (hours.isEmpty) {
      hours = {
        'Monday': '9:00 AM - 6:00 PM',
        'Tuesday': '9:00 AM - 6:00 PM',
        'Wednesday': '9:00 AM - 6:00 PM',
        'Thursday': '9:00 AM - 6:00 PM',
        'Friday': '9:00 AM - 6:00 PM',
        'Saturday': '10:00 AM - 4:00 PM',
        'Sunday': 'Closed',
      };
    }
    
    return hours;
  }

  // Service Preferences
  Future<void> setServiceCategories(List<String> categories) async {
    await _ensureInitialized();
    await _preferences!.setStringList('service_categories', categories);
  }

  Future<List<String>> getServiceCategories() async {
    await _ensureInitialized();
    return _preferences!.getStringList('service_categories') ?? [
      'Alterations', 'Custom', 'Repairs', 'Design'
    ];
  }

  // Pricing Settings
  Future<void> setPricingSettings(Map<String, double> pricing) async {
    await _ensureInitialized();
    final pricingList = pricing.entries.map((e) => '${e.key}:${e.value}').toList();
    await _preferences!.setStringList('pricing_settings', pricingList);
  }

  Future<Map<String, double>> getPricingSettings() async {
    await _ensureInitialized();
    final pricingList = _preferences!.getStringList('pricing_settings') ?? [];
    final Map<String, double> pricing = {};
    
    for (var price in pricingList) {
      final parts = price.split(':');
      if (parts.length == 2) {
        pricing[parts[0]] = double.tryParse(parts[1]) ?? 0.0;
      }
    }
    
    return pricing;
  }

  // Order Management Preferences
  Future<void> setDefaultOrderDuration(int days) async {
    await _ensureInitialized();
    await _preferences!.setInt('default_order_duration', days);
  }

  Future<int> getDefaultOrderDuration() async {
    await _ensureInitialized();
    return _preferences!.getInt('default_order_duration') ?? 5;
  }

  Future<void> setAutoAcceptOrders(bool autoAccept) async {
    await _ensureInitialized();
    await _preferences!.setBool('auto_accept_orders', autoAccept);
  }

  Future<bool> getAutoAcceptOrders() async {
    await _ensureInitialized();
    return _preferences!.getBool('auto_accept_orders') ?? false;
  }

  // Notification Preferences
  Future<void> setOrderNotifications(bool enabled) async {
    await _ensureInitialized();
    await _preferences!.setBool('order_notifications', enabled);
  }

  Future<bool> getOrderNotifications() async {
    await _ensureInitialized();
    return _preferences!.getBool('order_notifications') ?? true;
  }

  Future<void> setMessageNotifications(bool enabled) async {
    await _ensureInitialized();
    await _preferences!.setBool('message_notifications', enabled);
  }

  Future<bool> getMessageNotifications() async {
    await _ensureInitialized();
    return _preferences!.getBool('message_notifications') ?? true;
  }

  Future<void> setReviewNotifications(bool enabled) async {
    await _ensureInitialized();
    await _preferences!.setBool('review_notifications', enabled);
  }

  Future<bool> getReviewNotifications() async {
    await _ensureInitialized();
    return _preferences!.getBool('review_notifications') ?? true;
  }

  // Search History (Tailor-specific)
  Future<void> addToSearchHistory(String query) async {
    await _ensureInitialized();
    List<String> history = getSearchHistory() as List<String>;
    
    // Remove if already exists to avoid duplicates
    history.remove(query);
    
    // Add to beginning
    history.insert(0, query);
    
    // Keep only last 10 searches
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    
    await _preferences!.setStringList('tailor_search_history', history);
  }

  Future<List<String>> getSearchHistory() async {
    await _ensureInitialized();
    return _preferences!.getStringList('tailor_search_history') ?? [];
  }

  Future<void> setSearchHistory(List<String> history) async {
    await _ensureInitialized();
    await _preferences!.setStringList('tailor_search_history', history);
  }

  // App Usage Tracking
  Future<void> setLastAppUsage(DateTime dateTime) async {
    await _ensureInitialized();
    await _preferences!.setString('last_app_usage', dateTime.toIso8601String());
  }

  Future<DateTime?> getLastAppUsage() async {
    await _ensureInitialized();
    final dateString = _preferences!.getString('last_app_usage');
    return dateString != null ? DateTime.parse(dateString) : null;
  }

  // Theme and UI Preferences
  Future<void> setDarkMode(bool darkMode) async {
    await _ensureInitialized();
    await _preferences!.setBool('dark_mode', darkMode);
  }

  Future<bool> getDarkMode() async {
    await _ensureInitialized();
    return _preferences!.getBool('dark_mode') ?? false;
  }

  Future<void> setLanguage(String language) async {
    await _ensureInitialized();
    await _preferences!.setString('app_language', language);
  }

  Future<String> getLanguage() async {
    await _ensureInitialized();
    return _preferences!.getString('app_language') ?? 'en';
  }

  // Statistics and Analytics
  Future<void> setTotalOrders(int count) async {
    await _ensureInitialized();
    await _preferences!.setInt('total_orders', count);
  }

  Future<int> getTotalOrders() async {
    await _ensureInitialized();
    return _preferences!.getInt('total_orders') ?? 0;
  }

  Future<void> setTotalEarnings(double earnings) async {
    await _ensureInitialized();
    await _preferences!.setDouble('total_earnings', earnings);
  }

  Future<double> getTotalEarnings() async {
    await _ensureInitialized();
    return _preferences!.getDouble('total_earnings') ?? 0.0;
  }

  Future<void> setAverageRating(double rating) async {
    await _ensureInitialized();
    await _preferences!.setDouble('average_rating', rating);
  }

  Future<double> getAverageRating() async {
    await _ensureInitialized();
    return _preferences!.getDouble('average_rating') ?? 0.0;
  }

  // Clear all data (for logout)
  Future<void> clearAllData() async {
    await _ensureInitialized();
    await _preferences!.clear();
  }

  // Clear only search history
  Future<void> clearSearchHistory() async {
    await _ensureInitialized();
    await _preferences!.remove('tailor_search_history');
  }

  // Check if first launch
  Future<bool> isFirstLaunch() async {
    await _ensureInitialized();
    final firstLaunch = _preferences!.getBool('first_launch') ?? true;
    if (firstLaunch) {
      await _preferences!.setBool('first_launch', false);
    }
    return firstLaunch;
  }

  // Get all stored data (for debugging)
  Future<Map<String, dynamic>> getAllStoredData() async {
    await _ensureInitialized();
    final keys = _preferences!.getKeys();
    final Map<String, dynamic> data = {};
    
    for (String key in keys) {
      final value = _preferences!.get(key);
      data[key] = value;
    }
    
    return data;
  }
}