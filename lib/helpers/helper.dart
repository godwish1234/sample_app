import 'package:easy_localization/easy_localization.dart';
import 'package:sample_app/localizations/locale_keys.g.dart';

class Helper {
  convertStatus(int status) {
    switch (status) {
      case 1:
        return LocaleKeys.initial_count.tr();

      case 2:
        return LocaleKeys.dry.tr();

      case 3:
        return LocaleKeys.pack.tr();
    }
  }
}
