import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CafeMenuViewModel extends BaseViewModel {
  // State variables
  List<MenuCategory> _categories = [];
  String? _selectedCategory;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<MenuCategory> get categories => _categories;
  String? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<MenuItem> get filteredItems {
    if (_selectedCategory == null || _selectedCategory == 'All') {
      return _categories.expand((cat) => cat.items).toList();
    }
    final category = _categories.firstWhere(
      (cat) => cat.name == _selectedCategory,
      orElse: () => _categories.first,
    );
    return category.items;
  }

  // Initialize
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await loadMenuData();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to load menu';
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load menu data
  Future<void> loadMenuData() async {
    // TODO: Replace with actual API call
    await Future.delayed(const Duration(milliseconds: 500));
    _categories = _getDummyMenuData();
    _selectedCategory = 'All';
  }

  // Refresh data
  Future<void> refreshData() async {
    _errorMessage = null;
    await loadMenuData();
  }

  // Set selected category
  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  // Dummy data
  List<MenuCategory> _getDummyMenuData() {
    return [
      MenuCategory(
        id: '1',
        name: 'Coffee',
        icon: Icons.coffee,
        items: [
          MenuItem(
            id: '1',
            name: 'Espresso',
            description: 'Strong and bold espresso shot',
            price: 25000,
            imageUrl:
                'https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04',
            category: 'Coffee',
            isAvailable: true,
          ),
          MenuItem(
            id: '2',
            name: 'Cappuccino',
            description: 'Espresso with steamed milk and foam',
            price: 35000,
            imageUrl:
                'https://images.unsplash.com/photo-1572442388796-11668a67e53d',
            category: 'Coffee',
            isAvailable: true,
          ),
          MenuItem(
            id: '3',
            name: 'Latte',
            description: 'Smooth espresso with steamed milk',
            price: 38000,
            imageUrl:
                'https://images.unsplash.com/photo-1561882468-9110e03e0f78',
            category: 'Coffee',
            isAvailable: true,
          ),
          MenuItem(
            id: '4',
            name: 'Americano',
            description: 'Espresso with hot water',
            price: 30000,
            imageUrl:
                'https://images.unsplash.com/photo-1514432324607-a09d9b4aefdd',
            category: 'Coffee',
            isAvailable: true,
          ),
        ],
      ),
      MenuCategory(
        id: '2',
        name: 'Non-Coffee',
        icon: Icons.local_drink,
        items: [
          MenuItem(
            id: '5',
            name: 'Green Tea Latte',
            description: 'Smooth green tea with steamed milk',
            price: 32000,
            imageUrl:
                'https://images.unsplash.com/photo-1556679343-c7306c1976bc',
            category: 'Non-Coffee',
            isAvailable: true,
          ),
          MenuItem(
            id: '6',
            name: 'Chocolate',
            description: 'Rich hot chocolate with whipped cream',
            price: 35000,
            imageUrl:
                'https://images.unsplash.com/photo-1517578239113-b03992dcdd25',
            category: 'Non-Coffee',
            isAvailable: true,
          ),
          MenuItem(
            id: '7',
            name: 'Fresh Orange Juice',
            description: 'Freshly squeezed orange juice',
            price: 28000,
            imageUrl:
                'https://images.unsplash.com/photo-1600271886742-f049cd451bba',
            category: 'Non-Coffee',
            isAvailable: true,
          ),
        ],
      ),
      MenuCategory(
        id: '3',
        name: 'Snacks',
        icon: Icons.fastfood,
        items: [
          MenuItem(
            id: '8',
            name: 'Croissant',
            description: 'Buttery and flaky French pastry',
            price: 25000,
            imageUrl:
                'https://images.unsplash.com/photo-1555507036-ab1f4038808a',
            category: 'Snacks',
            isAvailable: true,
          ),
          MenuItem(
            id: '9',
            name: 'Sandwich',
            description: 'Club sandwich with fresh vegetables',
            price: 45000,
            imageUrl:
                'https://images.unsplash.com/photo-1528735602780-2552fd46c7af',
            category: 'Snacks',
            isAvailable: true,
          ),
          MenuItem(
            id: '10',
            name: 'Blueberry Muffin',
            description: 'Soft muffin with fresh blueberries',
            price: 28000,
            imageUrl:
                'https://images.unsplash.com/photo-1607958996333-41aef7caefaa',
            category: 'Snacks',
            isAvailable: true,
          ),
        ],
      ),
      MenuCategory(
        id: '4',
        name: 'Meals',
        icon: Icons.restaurant,
        items: [
          MenuItem(
            id: '11',
            name: 'Pasta Carbonara',
            description: 'Creamy pasta with bacon and parmesan',
            price: 55000,
            imageUrl:
                'https://images.unsplash.com/photo-1612874742237-6526221588e3',
            category: 'Meals',
            isAvailable: true,
          ),
          MenuItem(
            id: '12',
            name: 'Nasi Goreng',
            description: 'Indonesian fried rice with chicken',
            price: 48000,
            imageUrl:
                'https://images.unsplash.com/photo-1603133872878-684f208fb84b',
            category: 'Meals',
            isAvailable: true,
          ),
          MenuItem(
            id: '13',
            name: 'Chicken Burger',
            description: 'Grilled chicken burger with fries',
            price: 52000,
            imageUrl:
                'https://images.unsplash.com/photo-1568901346375-23c9450c58cd',
            category: 'Meals',
            isAvailable: false,
          ),
        ],
      ),
    ];
  }
}

// Models
class MenuCategory {
  final String id;
  final String name;
  final IconData icon;
  final List<MenuItem> items;

  MenuCategory({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });
}

class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final bool isAvailable;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.isAvailable,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      category: json['category'] as String,
      isAvailable: json['isAvailable'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'isAvailable': isAvailable,
    };
  }
}
