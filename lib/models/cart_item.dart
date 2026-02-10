class CartItem {
  final int menuItemId;
  final String title;
  final double price;
  final int quantity;
  final String imageAsset;

  const CartItem({
    required this.menuItemId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.imageAsset,
  });
}
