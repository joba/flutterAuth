import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseAnalytics _analytics;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseAnalytics? analytics})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _analytics = analytics ?? FirebaseAnalytics.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _analytics.logEvent(name: 'login', parameters: {'method': 'email'});
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _analytics.logEvent(
        name: 'sign_up',
        parameters: {'method': 'email'},
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _analytics.logEvent(name: 'logout');
  }
}
