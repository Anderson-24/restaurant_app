import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'profile_screen.dart'; // *** إضافة 1: استدعاء شاشة الملف الشخصي ***

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                "Your Name",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text("your.email@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  "Y",
                  style: TextStyle(fontSize: 40.0, color: Colors.deepOrange),
                ),
              ),
              decoration: BoxDecoration(color: Colors.deepOrange),
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
      ),

      appBar: AppBar(
        title: Text(
          'Menu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        actions: [
          // *** إضافة 2: تفعيل الزر للانتقال لصفحة الملف الشخصي ***
          IconButton(
            icon: Icon(Icons.person_outline),
            onPressed: () {
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          SizedBox(width: 10),
        ],
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a dish...',
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.deepOrange, width: 2.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                'https://images.unsplash.com/photo-1555396273-367ea4eb4db5?w=800',
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Popular Dishes',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange.shade700,
              ),
            ),
          ),
          SizedBox(height: 10),
          MenuItemCard(
            title: 'Beef Burger',
            description: 'Grilled beef patty with cheese, lettuce, and tomato.',
            price: '\$12.99',
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
          ),
          MenuItemCard(
            title: 'Margherita Pizza',
            description:
                'Italian dough with tomato sauce and mozzarella cheese.',
            price: '\$15.50',
            imageUrl:
                'https://images.unsplash.com/photo-1594007654729-407eedc4be65?w=800',
          ),
        ],
      ),
    );
  }
}

class MenuItemCard extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageUrl;

  const MenuItemCard({
    super.key,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Row(
        children: [
          Image.network(imageUrl, width: 120, height: 120, fit: BoxFit.cover),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.deepOrange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
