import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../models/app_user.dart';
import '../services/cart_service.dart';
import '../services/user_service.dart';
import 'edit_profile_screen.dart';

class CartScreen extends StatefulWidget {
  final CartService cartService;

  const CartScreen({super.key, required this.cartService});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final UserService _userService = UserService();
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  AppUser? _contactInfo;
  bool _contactConfirmed = false;

  @override
  void initState() {
    super.initState();
    _loadContactInfo();
  }

  Future<void> _loadContactInfo() async {
    final user = await _userService.fetchCurrentUserProfile();
    if (!mounted) return;
    setState(() {
      _contactInfo = user;
    });
  }

  Future<void> _confirmContactInfo() async {
    await _loadContactInfo();
    if (!mounted) return;
    setState(() {
      _contactConfirmed = true;
    });
  }

  void _showTopSuccess(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showTopWarning(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.deepOrange,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 12, left: 16, right: 16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _updateQuantity(int menuItemId, int value) {
    setState(() {
      widget.cartService.updateQuantity(menuItemId, value);
    });
  }

  Future<void> _saveOrder() async {
    if (!_contactConfirmed) {
      _showTopWarning('Please confirm your contact data');
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _contactInfo == null) {
      _showTopWarning('Please confirm your contact data');
      return;
    }

    final orderRef = _database.child('orders').push();
    final orderId = orderRef.key ?? '';
    final now = DateTime.now().millisecondsSinceEpoch;
    final items = widget.cartService.itemsList;

    final itemsMap = <String, Map<String, dynamic>>{};
    for (var i = 0; i < items.length; i += 1) {
      final item = items[i];
      itemsMap[i.toString()] = {
        'menuItemId': item.menuItemId,
        'title': item.title,
        'price': item.price,
        'quantity': item.quantity,
        'imageAsset': item.imageAsset,
      };
    }

    await orderRef.set({
      'orderId': orderId,
      'userId': user.uid,
      'status': 'pending',
      'createdAt': now,
      'totalAmount': widget.cartService.totalAmount,
      'items': itemsMap,
      'contactInfo': {
        'fullName': _contactInfo?.fullName ?? '',
        'email': _contactInfo?.email ?? '',
        'phone': _contactInfo?.phone ?? '',
        'address': _contactInfo?.address ?? '',
      },
    });

    widget.cartService.clear();
    if (!mounted) return;
    _showTopSuccess('Done! your order has been saved.');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.cartService.itemsList;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? Center(child: Text('Your cart is empty.'))
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Contact Info',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(_contactInfo?.fullName ?? '—'),
                          Text(_contactInfo?.email ?? '—'),
                          Text(_contactInfo?.phone ?? '—'),
                          Text(_contactInfo?.address ?? '—'),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black87,
                                  backgroundColor: Colors.grey.shade200,
                                ),
                                onPressed: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const EditProfileScreen(),
                                    ),
                                  );
                                  await _loadContactInfo();
                                  setState(() {
                                    _contactConfirmed = false;
                                  });
                                },
                                child: const Text('Edit'),
                              ),
                              const SizedBox(width: 8),
                              if (_contactConfirmed)
                                ElevatedButton(
                                  onPressed: _confirmContactInfo,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Icon(Icons.check),
                                )
                              else
                                ElevatedButton(
                                  onPressed: _confirmContactInfo,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepOrange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Confirm'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final total = item.price * item.quantity;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      item.imageAsset,
                                      width: 70,
                                      height: 70,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.title,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '\$${item.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.remove_circle_outline,
                                                  ),
                                                  onPressed: item.quantity > 1
                                                      ? () => _updateQuantity(
                                                          item.menuItemId,
                                                          item.quantity - 1,
                                                        )
                                                      : null,
                                                ),
                                                SizedBox(
                                                  width: 50,
                                                  child: Text(
                                                    item.quantity.toString(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.add_circle_outline,
                                                  ),
                                                  onPressed: item.quantity < 999
                                                      ? () => _updateQuantity(
                                                          item.menuItemId,
                                                          item.quantity + 1,
                                                        )
                                                      : null,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              '\$${total.toStringAsFixed(2)}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.deepOrange,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.all(6),
                                  minimumSize: const Size(32, 32),
                                  side: const BorderSide(color: Colors.red),
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    widget.cartService.removeItem(
                                      item.menuItemId,
                                    );
                                  });
                                },
                                child: const Icon(
                                  Icons.delete_outline,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${widget.cartService.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.deepOrange,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _saveOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('PURCHASE'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
