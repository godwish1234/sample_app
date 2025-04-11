import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/services/interfaces/user_settings_service.dart';

class AppStateManager extends ChangeNotifier {
  // final _userSettingsService = GetIt.I<UserSettingsService>();

  var _currentScreen = AppLinkLocationKeys.home;
  String get currentScreen => _currentScreen;

  var _docID = "";
  String get docID => _docID;

  var _loggedIn = false;
  bool get isLoggedIn => _loggedIn;
  set setIsLoggedIn(isLoggedIn) {
    _loggedIn = isLoggedIn;
  }

  bool get homePage => _currentScreen == AppLinkLocationKeys.home;
  bool get bookingsPage => _currentScreen == AppLinkLocationKeys.bookings;
  bool get communityPage => _currentScreen == AppLinkLocationKeys.community;
  bool get profilePage => _currentScreen == AppLinkLocationKeys.profile;

  // bool get isDarkMode => _userSettingsService.isDarkMode();

  // ThemeMode get mode => isDarkMode == true ? ThemeMode.dark : ThemeMode.light;

  Locale _locale = const Locale("id");
  Locale get locale => _locale;

  bool _hideCompleted = true;
  bool get hideCompleted => _hideCompleted;

  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
  }

  // Future toggleMode() async {
  //   _ptfiConopsTelemetryService.trackEvent('Switch Dark Mode');
  //   await _userSettingsService.setDarkMode();
  //   notifyListeners();
  // }

  Future completeLogin() async {
    _loggedIn = true;
    _currentScreen = AppLinkLocationKeys.home;
    notifyListeners();
  }

  void completeLogout() {
    _currentScreen = AppLinkLocationKeys.login;
    _loggedIn = false;
    notifyListeners();
  }

  void showHomePage() {
    _currentScreen = AppLinkLocationKeys.home;
    notifyListeners();
  }

  void showBookingsPage() {
    _currentScreen = AppLinkLocationKeys.bookings;
    notifyListeners();
  }

  void showCommunityPage() {
    _currentScreen = AppLinkLocationKeys.community;
    notifyListeners();
  }

  void showProfilePage() {
    _currentScreen = AppLinkLocationKeys.profile;
    notifyListeners();
  }

  void showMembershipDetailPage(String docID) {
    _currentScreen = AppLinkLocationKeys.membershipDetail;
    setDocID(docID);
    notifyListeners();
  }

  DateTime getTimeNow() {
    DateTime dt = DateTime.now();
    return dt;
  }

  void setDocID(String docId) {
    _docID = docId;
  }

  void setShowCompleted(bool completed) {
    _hideCompleted = completed;
    notifyListeners();
  }
}
