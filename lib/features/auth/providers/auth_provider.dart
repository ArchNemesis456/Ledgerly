import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/firebase_auth_service.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return FirebaseAuthService();
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});
