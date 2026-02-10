class AppUser {
  final String uid;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String imageProfile;
  final int? createdAt;

  const AppUser({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.imageProfile,
    this.createdAt,
  });

  factory AppUser.fromMap(String uid, Map<dynamic, dynamic> data) {
    return AppUser(
      uid: uid,
      fullName: (data['fullName'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      address: (data['address'] ?? '').toString(),
      imageProfile: (data['imageProfile'] ?? '').toString(),
      createdAt: data['createdAt'] is int ? data['createdAt'] as int : null,
    );
  }
}
