import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationService<T> {
  Future<User?> signInWithEmailAndPassword(String phoneno, String password);
  Future<bool> isAlreadyLoggedIn();
  void signOut();
}
