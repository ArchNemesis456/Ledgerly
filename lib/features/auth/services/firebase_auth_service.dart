import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';

class FirebaseAuthService implements AuthRepository {
  FirebaseAuthService({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  UserModel? _mapUser(User? user) {
    if (user == null) return null;

    return UserModel(
      uid: user.uid,
      name: user.displayName,
      email: user.email ?? '',
      photoUrl: user.photoURL,
    );
  }

  @override
  Stream<UserModel?> authStateChanges() {
    return _firebaseAuth.authStateChanges().map(_mapUser);
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return _mapUser(_firebaseAuth.currentUser);
  }

  @override
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final credential =
        await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return _mapUser(credential.user)!;
  }

  @override
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();

    final updatedUser = _firebaseAuth.currentUser;

    return _mapUser(updatedUser)!;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}