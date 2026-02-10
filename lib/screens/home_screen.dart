import 'package:flutter/material.dart';
import '../models/enums/menu_category.dart';
import '../models/menu_item.dart';
import '../services/cart_service.dart';
import '../services/menu_service.dart';
import '../widgets/app_drawer.dart';
import '../widgets/add_to_cart_dialog.dart';
import '../widgets/menu_item_card.dart';
import 'cart_screen.dart';
import 'profile_screen.dart'; // *** إضافة 1: استدعاء شاشة الملف الشخصي ***

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  MenuCategory _selectedCategory = MenuCategory.mainCourses;
  int _currentPage = 0;
  final int _itemsPerPage = 3;
  final TextEditingController _searchController = TextEditingController();
  final MenuService _menuService = MenuService();
  final CartService _cartService = CartService();
  List<MenuItem> _menuItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    final items = await _menuService.getAllMenuItems();
    if (!mounted) {
      return;
    }
    setState(() {
      _menuItems = items;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _resetPaginationAndSearch() {
    _currentPage = 0;
    _searchController.clear();
  }

  void _onCategorySelected(MenuCategory category) {
    setState(() {
      _selectedCategory = category;
      _resetPaginationAndSearch();
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      _currentPage = 0;
    });
  }

  Future<void> _showAddToCartDialog(MenuItem item) async {
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AddToCartDialog(
          item: item,
          onAdd: (quantity) {
            _cartService.addItem(item, quantity);
            setState(() {});
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.trim().toLowerCase();
    final filteredMenuItems = query.isNotEmpty
        ? _menuItems
              .where((item) => item.title.toLowerCase().contains(query))
              .toList()
        : _menuItems
              .where((item) => item.category == _selectedCategory.key)
              .toList();

    final totalPages = (filteredMenuItems.length / _itemsPerPage).ceil().clamp(
      1,
      9999,
    );
    final safePage = _currentPage.clamp(0, totalPages - 1);
    final offset = safePage * _itemsPerPage;
    final pagedItems = filteredMenuItems
        .skip(offset)
        .take(_itemsPerPage)
        .toList();
    final hasPrevious = safePage > 0;
    final hasNext = safePage < totalPages - 1;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(),

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
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          CartScreen(cartService: _cartService),
                    ),
                  );
                  setState(() {});
                },
              ),
              if (_cartService.totalItemsCount > 0)
                Positioned(
                  right: 4,
                  top: 4,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _cartService.totalItemsCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(width: 10),
        ],
      ),

      body: ListView(
        children: [
          SizedBox(height: 12),
          SizedBox(
            height: 48,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: MenuCategory.values.map((category) {
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),
                  child: ChoiceChip(
                    label: Text(category.label),
                    selected: isSelected,
                    selectedColor: Colors.deepOrange.shade100,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.deepOrange : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => _onCategorySelected(category),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
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
              query.isNotEmpty ? 'Filtered' : _selectedCategory.label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepOrange.shade700,
              ),
            ),
          ),
          SizedBox(height: 10),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Center(child: CircularProgressIndicator()),
            )
          else
            ...pagedItems.map(
              (item) => MenuItemCard(
                item: item,
                onAddToCart: () => _showAddToCartDialog(item),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: hasPrevious
                      ? () {
                          setState(() {
                            _currentPage -= 1;
                          });
                        }
                      : null,
                  child: Text('Previous'),
                ),
                Text('${safePage + 1} / $totalPages'),
                TextButton(
                  onPressed: hasNext
                      ? () {
                          setState(() {
                            _currentPage += 1;
                          });
                        }
                      : null,
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
