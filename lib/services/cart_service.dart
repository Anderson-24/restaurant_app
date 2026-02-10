import '../models/cart_item.dart';
import '../models/menu_item.dart';

class CartService {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => Map.unmodifiable(_items);

  List<CartItem> get itemsList => _items.values.toList();

  int get totalItemsCount =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.values.fold(0, (sum, item) => sum + (item.price * item.quantity));

  void addItem(MenuItem menuItem, int quantity) {
    final existing = _items[menuItem.id];
    if (existing != null) {
      _items[menuItem.id] = CartItem(
        menuItemId: existing.menuItemId,
        title: existing.title,
        price: existing.price,
        quantity: existing.quantity + quantity,
        imageAsset: existing.imageAsset,
      );
      return;
    }

    _items[menuItem.id] = CartItem(
      menuItemId: menuItem.id,
      title: menuItem.title,
      price: menuItem.price,
      quantity: quantity,
      imageAsset: menuItem.imageAsset,
    );
  }

  void updateQuantity(int menuItemId, int quantity) {
    final existing = _items[menuItemId];
    if (existing == null) {
      return;
    }
    final clamped = quantity.clamp(1, 999);
    _items[menuItemId] = CartItem(
      menuItemId: existing.menuItemId,
      title: existing.title,
      price: existing.price,
      quantity: clamped,
      imageAsset: existing.imageAsset,
    );
  }

  void removeItem(int menuItemId) {
    _items.remove(menuItemId);
  }

  void clear() {
    _items.clear();
  }
}
