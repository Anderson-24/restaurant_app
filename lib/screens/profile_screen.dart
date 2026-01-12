import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
          // صورة الملف الشخصي
          CircleAvatar(
            radius: 70,
            backgroundColor: Colors.deepOrange.shade100,
            child: CircleAvatar(
              radius: 65,
              backgroundImage: NetworkImage(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=800',
              ), // صورة مستخدم افتراضية
            ),
          ),
          SizedBox(height: 15),
          // اسم المستخدم والبريد الإلكتروني
          Center(
            child: Text(
              'Your Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'your.email@example.com',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 30),
          Divider(),
          // قائمة الخيارات
          ProfileMenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            onTap: () {},
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
