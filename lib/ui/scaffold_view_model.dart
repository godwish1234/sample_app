import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/enums/language.dart';
import 'package:sample_app/providers/app_state_manager.dart';
import 'package:sample_app/providers/interfaces/user_settings_provider.dart';
import 'package:sample_app/services/interfaces/profile_service.dart';
import 'package:sample_app/services/interfaces/user_settings_service.dart';

class ScaffoldViewModel extends BaseViewModel {
  // Services
  final _appStateManager = GetIt.I<AppStateManager>();
  // final _userSettingsService = GetIt.instance<UserSettingsService>();
  // final _userSettingProvider = GetIt.instance<UserSettingsProvider>();
  // final _profileService = GetIt.instance<ProfileService>();

  User? user;

  // View Model States
  var _currentNavIndex = 0;
  int get currentNavIndex => _currentNavIndex;

  Locale _locale = Language.englishUS.toLocale();
  Locale get locale => _locale;

  List<Language> get availableLanguages => Language.values;

  void initialize() async {
    user = FirebaseAuth.instance.currentUser;

    // await _profileService.initialize(forceRefresh: true);

    // var languageId =
    //     _userSettingProvider.userSetting.languageId?.replaceAll('-', '_');
    // final splitted = languageId?.split('_');
    // _locale = Locale(splitted![0], splitted[1]);

    // _appStateManager.setLocale(_locale);

    _appStateManager.addListener(_appStateUpdated);
    _appStateUpdated();
    // _userSettingProvider.addListener(update);

    notifyListeners();
  }

  Future<void> update() async {
    // var languageIdd = _userSettingsService.getLanguageId();

    // final splitted = languageIdd.replaceAll('-', '_').split('_');
    // _locale = Locale(splitted[0], splitted[1]);

    _appStateManager.setLocale(_locale);

    notifyListeners();
  }

  void _appStateUpdated() {
    if (_appStateManager.homePage) {
      _currentNavIndex = 0;
    } else if (_appStateManager.bookingsPage) {
      _currentNavIndex = 1;
    }
    else if (_appStateManager.communityPage) {
      _currentNavIndex = 2;
    }
    else if (_appStateManager.profilePage) {
      _currentNavIndex = 3;
    }

    notifyListeners();
  }

  void onNavigationItemClicked(int index) async {
    switch (index) {
      case 0: // Home
        _appStateManager.showHomePage();
        break;
      case 1: // bookings
        _appStateManager.showBookingsPage();
        break;
        case 2: // community
        _appStateManager.showCommunityPage();
        break;
        case 3: // profile
        _appStateManager.showProfilePage();
        break;
    }
  }

  @override
  void dispose() {
    _appStateManager.removeListener(_appStateUpdated);
    // _userSettingProvider.removeListener(update);
    super.dispose();
  }

  void setLanguage(Locale locale) async {
    // await _userSettingsService.setLanguageId(locale.toString());
    update();
  }
}
