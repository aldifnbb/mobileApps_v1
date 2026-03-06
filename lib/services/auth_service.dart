import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register
  Future<User?> register({
    required String name,
    required String email,
    required String password,
  }) async {

    try {

      print("Mulai register");

      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("Auth berhasil");

      User? user = result.user;

      if (user != null) {

        print("Simpan ke firestore");

        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': 'user',
          'createdAt': Timestamp.now(),
        });

        print("Firestore berhasil");
      }

      return user;

    } catch (e) {
      print("Error register: $e");
      rethrow;
    }

  }

  // Login
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return result.user;
    } catch (e) {
      rethrow;
    }
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}