enum MenuCategory { mainCourses, fastFood, beverages, desserts }

extension MenuCategoryX on MenuCategory {
  String get key {
    switch (this) {
      case MenuCategory.mainCourses:
        return 'main_courses';
      case MenuCategory.fastFood:
        return 'fast_food';
      case MenuCategory.beverages:
        return 'beverages';
      case MenuCategory.desserts:
        return 'desserts';
    }
  }

  String get label {
    switch (this) {
      case MenuCategory.mainCourses:
        return 'Main Courses';
      case MenuCategory.fastFood:
        return 'Fast Food';
      case MenuCategory.beverages:
        return 'Beverages';
      case MenuCategory.desserts:
        return 'Desserts';
    }
  }
}
