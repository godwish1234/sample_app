import 'package:flutter/material.dart';

abstract class ProfileService {
  ValueNotifier get profile;
  Future initialize({bool forceRefresh = false});
}
