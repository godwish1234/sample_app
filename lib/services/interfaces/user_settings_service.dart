import 'package:sample_app/models/localStorage/user_setting.dart';

abstract class UserSettingsService {
  // Stream<UserSetting> get settingStream;

  Future initialize();

  String getLanguageId();
  Future setLanguageId(String? languageId);

  // Future<UserSetting> getUserSetting();
  // Future upsertUserSetting(UserSetting userSetting);

  bool isDarkMode();
  Future setDarkMode();
}
