// import 'package:isar/isar.dart';
// import 'package:sample_app/enums/language.dart';
// import 'package:sample_app/models/localStorage/user_setting.dart';
// import 'package:sample_app/repository/interfaces/user_settings_repository.dart';

// class UserSettingsRepositoryImpl implements UserSettingsRepository {
//   final Isar isar;

//   UserSettingsRepositoryImpl({required this.isar});

//   @override
//   Future<UserSetting> getUserSetting(String? emailAddress) async {
//     var userSettings =
//         await isar.userSettings.filter().nameEqualTo(emailAddress).findFirst();

//     return userSettings ??
//         UserSetting(
//           isNewUser: true,
//           languageId: Language.bahasa.id,
//           utcLastUpdated: DateTime.now().toUtc(),
//         );
//   }

//   @override
//   Future upsertUserSetting(UserSetting userSetting) async {
//     userSetting.utcLastUpdated = DateTime.now().toUtc();
//     await isar.writeTxn(() async {
//       await isar.userSettings.put(userSetting);
//     });
//   }
// }
