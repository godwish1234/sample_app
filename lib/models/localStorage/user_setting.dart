// import 'package:isar/isar.dart';
// import 'package:sample_app/enums/language.dart';

// part 'user_setting.g.dart';

// @collection
// @Name("UserSetting")
// class UserSetting {

//   Id id = Isar.autoIncrement;

//   bool? isDarkMode;
//   bool isNewUser = false;
//   String? languageId;
//   String? name;
//   String? phoneno;

//   @Index()
//   DateTime utcLastUpdated;

//   UserSetting({
//     this.isDarkMode,
//     this.isNewUser = false,
//     this.languageId,
//     this.name,
//     this.phoneno,
//     required this.utcLastUpdated,
//   });

//   factory UserSetting.empty() => UserSetting(
//       languageId: Language.bahasa.id, utcLastUpdated: DateTime.now().toUtc());
// }