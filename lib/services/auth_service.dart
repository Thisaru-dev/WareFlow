// File: lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wareflow/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String? company;

  // Create user model from Firebase user
  UserModel? _userWithFirebaseUid(User? user) {
    return user != null
        ? UserModel(
          uid: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? '',
          photoURL: user.photoURL ?? '',
          companyId: '',
          warehouseId: '',
          role: '',
        )
        : null;
  }

  // Stream auth changes mapped to UserModel
  Stream<UserModel?> get user {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;

      await user.reload();
      user = _auth.currentUser;
      final snapshot = await _db.collection('users').doc(user!.uid).get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      } else {
        return _userWithFirebaseUid(user);
      }
    });
  }

  // Sign up with email and password
  // In AuthService:
  Future<UserModel?> signup(
    String email,
    String password,
    String displayName, [
    String? photoURL,
  ]) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user == null) return null;

      // Update Firebase Auth profile
      await user.updateDisplayName(displayName);

      if (photoURL != null && photoURL.isNotEmpty) {
        await user.updatePhotoURL(
          'https://images.app.goo.gl/REyoCLzthqfGFAYJ8',
        );
      }
      await user.reload();
      user = _auth.currentUser;

      // Write your user doc to Firestore (if you do that here)
      final model = _userWithFirebaseUid(user);
      await _db.collection('users').doc(user!.uid).set(model!.toMap());

      return model;
    } catch (err) {
      return null;
    }
  }

  // Sign in with email and password
  Future<UserModel?> signin(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      if (user != null) {
        final snapshot = await _db.collection('users').doc(user.uid).get();
        if (snapshot.exists) {
          return UserModel.fromMap(snapshot.data()!);
        }
      }
    } catch (err) {
      return null;
    }
    return null;
  }

  // Sign in with Google
  Future<UserModel?> signInWithGmail() async {
    try {
      await signOut();
      await GoogleSignIn().signOut();

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      if (user != null) {
        final userDoc = _db.collection('users').doc(user.uid);
        final snapshot = await userDoc.get();
        if (!snapshot.exists) {
          final userModel = _userWithFirebaseUid(user);
          await userDoc.set(userModel!.toMap());
          return userModel;
        } else {
          return UserModel.fromMap(snapshot.data()!);
        }
      }
    } catch (err) {
      return null;
    }
    return null;
  }

  // Sign out from Firebase and Google
  Future signOut() async {
    try {
      await GoogleSignIn().signOut();
      return await _auth.signOut();
    } catch (err) {
      return null;
    }
  }

  // Create company and assign to user
  Future<void> createCompany(String name) async {
    final uid = _auth.currentUser!.uid;
    final doc = _db.collection('companies').doc();
    await doc.set({
      'name': name,
      'ownerId': uid,
      'createdAt': FieldValue.serverTimestamp(),
    });
    await _db.collection('users').doc(uid).update({'companyId': doc.id});
  }

  // Get current user model
  Future<UserModel?> getCurrentUserModel() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    final snap = await _db.collection('users').doc(user.uid).get();
    return UserModel.fromMap(snap.data()!);
  }
}
