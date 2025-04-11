// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';
// import 'package:sample_app/models/localStorage/user_setting.dart';
// import 'package:sample_app/providers/interfaces/user_settings_provider.dart';
// import 'package:sample_app/services/interfaces/user_settings_service.dart';

// class UserSettingsProviderImpl extends ChangeNotifier
//     implements UserSettingsProvider {
//   final _userSettingService = GetIt.I<UserSettingsService>();

//   late StreamSubscription _userSettingSubscription;
//   UserSetting _userSetting = UserSetting.empty();

//   UserSettingsProviderImpl() {
//     _userSettingSubscription = _userSettingService.settingStream.listen(
//       (setting) {
//         _userSetting = setting;
//         notifyListeners();
//       },
//     );
//   }

//   @override
//   UserSetting get userSetting => _userSetting;

//   @override
//   void dispose() {
//     super.dispose();
//     _userSettingSubscription.cancel();
//   }
// }
