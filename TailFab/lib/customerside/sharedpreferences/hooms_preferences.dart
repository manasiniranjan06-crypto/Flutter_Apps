import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static SharedPreferences? _preferences;

  SharedPreferencesService._internal();

  static Future<SharedPreferencesService> getInstance() async {
    _instance ??= SharedPreferencesService._internal();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // User Data
  Future<bool> setUserName(String name) async {
    return await _preferences!.setString('user_name', name);
  }

  String getUserName() {
    return _preferences!.getString('user_name') ?? 'User';
  }

  Future<bool> setUserLocation(String location) async {
    return await _preferences!.setString('user_location', location);
  }

  String getUserLocation() {
    return _preferences!.getString('user_location') ?? 'Pune';
  }

  Future<bool> setUserEmail(String email) async {
    return await _preferences!.setString('user_email', email);
  }

  String getUserEmail() {
    return _preferences!.getString('user_email') ?? '';
  }

  // Search History
  Future<bool> setSearchHistory(List<String> searches) async {
    return await _preferences!.setStringList('search_history', searches);
  }

  List<String> getSearchHistory() {
    return _preferences!.getStringList('search_history') ?? [];
  }

  Future<void> addToSearchHistory(String searchTerm) async {
    if (searchTerm.trim().isEmpty) return;
    
    List<String> history = getSearchHistory();
    history.remove(searchTerm);
    history.insert(0, searchTerm);
    
    if (history.length > 10) {
      history = history.sublist(0, 10);
    }
    
    await setSearchHistory(history);
  }

  // App Preferences
  Future<bool> setLastAppUsage(DateTime dateTime) async {
    return await _preferences!.setString('last_app_usage', dateTime.toIso8601String());
  }

  DateTime getLastAppUsage() {
    final dateString = _preferences!.getString('last_app_usage');
    return dateString != null ? DateTime.parse(dateString) : DateTime.now();
  }

  Future<bool> setNotificationsEnabled(bool enabled) async {
    return await _preferences!.setBool('notifications_enabled', enabled);
  }

  bool getNotificationsEnabled() {
    return _preferences!.getBool('notifications_enabled') ?? true;
  }

  // Clear user data
  Future<void> clearUserData() async {
    await _preferences!.remove('user_name');
    await _preferences!.remove('user_location');
    await _preferences!.remove('user_email');
    await _preferences!.remove('search_history');
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _preferences!.clear();
  }
}