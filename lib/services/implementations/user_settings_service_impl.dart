// import 'dart:async';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:get_it/get_it.dart';
// import 'package:sample_app/enums/language.dart';
// import 'package:sample_app/models/localStorage/user_setting.dart';
// import 'package:sample_app/repository/interfaces/user_settings_repository.dart';

// import 'package:sample_app/services/interfaces/user_settings_service.dart';

// class UserSettingsServiceImpl implements UserSettingsService {
//   final _userSettingsRepository = GetIt.instance<UserSettingsRepository>();
//   late UserSetting _setting;
//   late final StreamController<UserSetting> _settingStreamController;

//   UserSettingsServiceImpl() {
//     _settingStreamController = StreamController(onListen: () {
//       _settingStreamController.add(_setting);
//     });
//   }

//   @override
//   Stream<UserSetting> get settingStream => _settingStreamController.stream;

//   @override
//   Future initialize() async {
//     // var user = await _authenticationService.user();
//     // _setting = await _userSettingsRepository.getUserSetting('asdasd');
//     _settingStreamController.add(_setting);
//   }

//   @override
//   String getLanguageId() {
//     return _setting.languageId ?? Language.bahasa.id;
//   }

//   @override
//   Future setLanguageId(String? languageId) async {
//     _setting.languageId = languageId;
//     await _saveSettingToDb();
//   }

//   @override
//   Future<UserSetting> getUserSetting() async {
//     return _setting;
//   }

//   @override
//   Future upsertUserSetting(UserSetting userSetting) async {
//     _setting = userSetting;
//     await _saveSettingToDb();
//   }

//   Future _saveSettingToDb() async {
//     _setting.utcLastUpdated = DateTime.now().toUtc();
//     _settingStreamController.add(_setting);
//     _userSettingsRepository.upsertUserSetting(_setting);
//   }

//   @override
//   bool isDarkMode() {
//     return _setting.isDarkMode ??
//         SchedulerBinding.instance.window.platformBrightness != Brightness.light;
//   }

//   @override
//   Future setDarkMode() async {
//     _setting.isDarkMode = _setting.isDarkMode == true ? false : true;
//     _setting.utcLastUpdated = DateTime.now().toUtc();
//     await _userSettingsRepository.upsertUserSetting(_setting);
//     _settingStreamController.add(_setting);
//   }
// }
