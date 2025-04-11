import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/providers/app_state_manager.dart';
import 'package:sample_app/services/interfaces/authentication_service.dart';
import 'package:sample_app/services/interfaces/profile_service.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';


class LoginViewModel extends BaseViewModel {
  final _auth = GetIt.I<AuthenticationService>();
  late final AppStateManager _appStateManager;
  late final AnimationController _fadeTransitionController;
  late final Animation<double> fadeTransitionAnimation;
  // late final ProfileService _profileService;

  LoginViewModel(TickerProviderStateMixin<StatefulWidget> loginView) {
    _appStateManager = GetIt.instance.get<AppStateManager>();
    // _profileService = GetIt.instance<ProfileService>();

    _fadeTransitionController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: loginView,
    )..repeat(reverse: true);

    fadeTransitionAnimation = CurvedAnimation(
      parent: _fadeTransitionController,
      curve: Curves.easeIn,
    );
  }

  initialize() async {}

  void signIn(String phoneno, String password) async {
    setBusy(true);

    try {
      User? user = await _auth.signInWithEmailAndPassword(phoneno, password);

      if (user != null) {
        // await _profileService.initialize(forceRefresh: true);
        await _appStateManager.completeLogin();
      } else {
        debugPrint('error occurred');
      }
    } catch (e) {
      debugPrint('error occurred: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> signInWithGoogle() async {
  setBusy(true);
  
  try {
    // Initialize Google Sign In
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    
    if (googleUser == null) {
      // User canceled the sign-in flow
      setBusy(false);
      return;
    }
    
    // Get authentication details
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    
    // Create credential for Firebase
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    
    // Sign in with Firebase
    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    final user = userCredential.user;
    
    if (user != null) {
      // await _profileService.initialize(forceRefresh: true);
      await _appStateManager.completeLogin();
    }
  } catch (e) {
    debugPrint('Google sign in error: $e');
    notifyListeners();
  } finally {
    setBusy(false);
  }
}

Future<void> signInWithFacebook() async {
  setBusy(true);
  
  try {
    // Initialize Facebook login
    final LoginResult result = await FacebookAuth.instance.login();
    
    if (result.status == LoginStatus.success) {
      // Get access token
      final AccessToken accessToken = result.accessToken!;
      
      // Create credential for Firebase
      final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.token);
      
      // Sign in with Firebase
      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final user = userCredential.user;
      
      if (user != null) {
        // await _profileService.initialize(forceRefresh: true);
        await _appStateManager.completeLogin();
      }
    } else if (result.status == LoginStatus.cancelled) {
      // User canceled login
      debugPrint('Facebook login canceled');
    } else {
      debugPrint('Facebook login failed with status: ${result.status}');
      notifyListeners();
    }
  } catch (e) {
    debugPrint('Facebook sign in error: $e');
    notifyListeners();
  } finally {
    setBusy(false);
  }
}

  @override
  void dispose() {
    _fadeTransitionController.dispose();
    super.dispose();
  }
}
