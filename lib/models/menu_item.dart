class MenuItem {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageAsset;
  final String category;
  final bool available;

  const MenuItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageAsset,
    required this.category,
    required this.available,
  });
}
