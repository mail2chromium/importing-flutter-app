import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  static final Auth _instance = Auth._internal();
  FirebaseAuth? _firebaseAuth;
  User? _user;

  factory Auth() {
    return _instance;
  }

  Auth._internal() {
    _firebaseAuth = FirebaseAuth.instance;
  }

  Future<bool> isLoggedIn() async {
    _user = _firebaseAuth?.currentUser;
    if (_user == null) {
      return false;
    }
    return true;
  }
}
