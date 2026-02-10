import 'package:flutter/material.dart';
import '../models/app_user.dart';
import '../screens/login_screen.dart';
import '../services/user_service.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final UserService _userService = UserService();

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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          FutureBuilder<AppUser?>(
            future: _userService.fetchCurrentUserProfile(),
            builder: (context, snapshot) {
              final user = snapshot.data;
              final fullName = user?.fullName ?? 'Your Name';
              final email = user?.email ?? 'your.email@example.com';

              return UserAccountsDrawerHeader(
                accountName: Text(
                  fullName,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                accountEmail: Text(email),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Text(
                    _initials(fullName, email),
                    style: TextStyle(fontSize: 40.0, color: Colors.deepOrange),
                  ),
                ),
                decoration: BoxDecoration(color: Colors.deepOrange),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.restaurant_menu, color: Colors.deepOrange),
            title: Text('Menu'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Order History'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => Navigator.pop(context),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
