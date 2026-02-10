import 'package:flutter/material.dart';
import '../models/app_user.dart';
import 'edit_profile_screen.dart';
import '../services/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserService _userService = UserService();
  late Future<AppUser?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _userService.fetchCurrentUserProfile();
  }

  void _reloadProfile() {
    setState(() {
      _profileFuture = _userService.fetchCurrentUserProfile();
    });
  }

  String _initials(String fullName, String email) {
    final trimmed = fullName.trim();
    if (trimmed.isNotEmpty) {
      return trimmed.characters.first.toUpperCase();
    }
    final emailTrimmed = email.trim();
    if (emailTrimmed.isNotEmpty) {
      return emailTrimmed.characters.first.toUpperCase();
    }
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // شريط علوي بسيط مع زر للرجوع
      appBar: AppBar(
        title: Text(
          'My Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView(
        children: [
          SizedBox(height: 30),
          FutureBuilder<AppUser?>(
            future: _profileFuture,
            builder: (context, snapshot) {
              final fullName = snapshot.data?.fullName ?? 'Your Name';
              final email = snapshot.data?.email ?? 'your.email@example.com';

              return Column(
                children: [
                  // صورة الملف الشخصي
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.deepOrange.shade100,
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.white,
                      child: Text(
                        _initials(fullName, email),
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  // اسم المستخدم والبريد الإلكتروني
                  Center(
                    child: Text(
                      fullName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      email,
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 30),
          Divider(),
          // قائمة الخيارات
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfileScreen(),
                ),
              );
              _reloadProfile();
            },
          ),
          ProfileMenuItem(
            icon: Icons.notifications_none,
            title: 'Notifications',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.payment,
            title: 'Payment Methods',
            onTap: () {},
          ),
          ProfileMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          Divider(),
          ProfileMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: Colors.red, // لون أحمر لتمييز تسجيل الخروج
            onTap: () {
              // يمكنك هنا إضافة الكود للعودة لشاشة تسجيل الدخول
            },
          ),
        ],
      ),
    );
  }
}

// قطعة مخصصة لإنشاء عناصر القائمة بشكل أنيق
class ProfileMenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const ProfileMenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepOrange),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
