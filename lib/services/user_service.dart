import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/app_user.dart';

class UserService {
  final FirebaseAuth _auth;
  final DatabaseReference _database;

  UserService({FirebaseAuth? auth, DatabaseReference? database})
    : _auth = auth ?? FirebaseAuth.instance,
      _database = database ?? FirebaseDatabase.instance.ref();

  Future<AppUser?> fetchCurrentUserProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }

    final snapshot = await _database.child('users').child(user.uid).get();
    if (!snapshot.exists || snapshot.value == null) {
      return AppUser(
        uid: user.uid,
        fullName: user.displayName ?? '',
        email: user.email ?? '',
        phone: '',
        address: '',
        imageProfile: '',
        createdAt: null,
      );
    }

    final data = snapshot.value as Map<dynamic, dynamic>;
    return AppUser.fromMap(user.uid, data);
  }

  Future<void> updateCurrentUserProfile({
    required String fullName,
    required String email,
    required String phone,
    required String address,
    required String imageProfile,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      return;
    }

    await _database.child('users').child(user.uid).update({
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'address': address,
      'imageProfile': imageProfile,
    });
  }
}
