import 'package:flutter/material.dart';

enum Language {
  englishUS("en-US", "en", "US", "English"),
  bahasa("id-ID", "id", "ID", "Bahasa");

  final String id;
  final String languageCode;
  final String countryCode;
  final String title;

  const Language(this.id, this.languageCode, this.countryCode, this.title);

  Locale toLocale() {
    return Locale(languageCode, countryCode);
  }

  static Language? fromLocale(Locale locale) {
    var list = Language.values.where((l) =>
        l.languageCode == locale.languageCode &&
        l.countryCode == locale.countryCode);

    if (list.isEmpty) return null;
    return list.first;
  }

  static Language byId(String id) {
    return Language.values.firstWhere(
      (l) => l.id.toLowerCase() == id.toLowerCase().replaceAll("_", "-"),
      orElse: () => Language.bahasa,
    );
  }
}
