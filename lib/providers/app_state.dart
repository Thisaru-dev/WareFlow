import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  bool _isLoading = true;
  bool _isFirstTime = true;

  bool get isLoading => _isLoading;
  bool get isFirstTime => _isFirstTime;

  AppState() {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Optional delay to show splash screen for smoother UX
    await Future.delayed(Duration(seconds: 2));

    // Check if user has opened app before
    _isFirstTime = prefs.getBool('isFirstTime') ?? true;

    _isLoading = false;
    notifyListeners();
  }

  // Call this when the user presses "Get Started" in WelcomeScreen
  Future<void> completeWelcomeFlow() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstTime', false);
    _isFirstTime = false;
    notifyListeners();
  }
}
