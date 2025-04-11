// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get_it/get_it.dart';
// import 'package:sample_app/enums/language.dart';
// import 'package:sample_app/services/interfaces/profile_service.dart';
// import 'package:sample_app/services/interfaces/user_settings_service.dart';

// class ProfileServiceImpl implements ProfileService {
//   // final _profileRepository = GetIt.I<ProfileRepository>();
//   final _userSettingService = GetIt.I<UserSettingsService>();

//   final ValueNotifier _profile = ValueNotifier(null);

//   @override
//   ValueNotifier get profile => _profile;

//   @override
//   Future initialize({bool forceRefresh = false}) async {
//     var userSetting = await _userSettingService.getUserSetting();

//     userSetting.isDarkMode = userSetting.isDarkMode ??
//         SchedulerBinding.instance.window.platformBrightness != Brightness.light;

//     if (forceRefresh) {
//       if (userSetting.isNewUser) {
//         userSetting.isNewUser = false;
//         userSetting.languageId = userSetting.languageId ?? Language.bahasa.id;
//       }
//       await _userSettingService.upsertUserSetting(userSetting);
//     }

//     _profile.value = userSetting;
//   }
// }
