import 'cart_item.dart';

class Order {
  final String orderId;
  final String userId;
  final String status;
  final int createdAt;
  final double totalAmount;
  final Map<String, CartItem> items;
  final Map<String, dynamic> contactInfo;

  const Order({
    required this.orderId,
    required this.userId,
    required this.status,
    required this.createdAt,
    required this.totalAmount,
    required this.items,
    required this.contactInfo,
  });
}
