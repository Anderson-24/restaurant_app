import 'package:firebase_database/firebase_database.dart';
import '../models/menu_item.dart';

class MenuService {
  final DatabaseReference _database;

  MenuService({DatabaseReference? database})
    : _database = database ?? FirebaseDatabase.instance.ref();

  Future<List<MenuItem>> getAllMenuItems() async {
    final snapshot = await _database.child('menuItems').get();
    if (!snapshot.exists) {
      return [];
    }

    final items = <MenuItem>[];
    for (final child in snapshot.children) {
      final value = child.value;
      if (value is! Map) {
        continue;
      }

      final data = Map<dynamic, dynamic>.from(value);
      final idValue = data['id'] ?? child.key;
      final id = idValue is int
          ? idValue
          : int.tryParse(idValue?.toString() ?? '') ?? 0;
      final priceValue = data['price'];
      final price = priceValue is num
          ? priceValue.toDouble()
          : double.tryParse(priceValue?.toString() ?? '') ?? 0.0;
      final availableValue = data['available'];
      final available = availableValue is bool
          ? availableValue
          : availableValue?.toString().toLowerCase() == 'true';

      items.add(
        MenuItem(
          id: id,
          title: (data['title'] ?? '').toString(),
          description: (data['description'] ?? '').toString(),
          price: price,
          imageAsset: (data['imageAsset'] ?? '').toString(),
          category: (data['category'] ?? '').toString(),
          available: available,
        ),
      );
    }

    return items;
  }
}
