import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_app/localizations/locale_keys.g.dart';
import 'package:sample_app/providers/app_state_manager.dart';
import 'package:sample_app/services/interfaces/authentication_service.dart';

class AuthenticationServiceImpl implements AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _appStateManager = GetIt.I<AppStateManager>();

  @override
  Future<User?> signInWithEmailAndPassword(
      String phoneno, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: phoneno, password: password);
      return credential.user;
    } catch (e) {
      Fluttertoast.showToast(
          msg: LocaleKeys.login_validation.tr(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    return null;
  }

  @override
  Future<bool> isAlreadyLoggedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void signOut() async {
    await FirebaseAuth.instance.signOut();
    _appStateManager.completeLogout();
  }
}
