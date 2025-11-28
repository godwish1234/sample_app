import 'package:stacked/stacked.dart';

class EquipmentViewModel extends BaseViewModel {
  // State variables
  String _selectedVenue = 'GOR Senayan';
  String _selectedCategory = 'All';
  bool _isRental = true;
  final Map<String, int> _cart = {};
  List<Equipment> _equipmentList = [];
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  String get selectedVenue => _selectedVenue;
  String get selectedCategory => _selectedCategory;
  bool get isRental => _isRental;
  Map<String, int> get cart => Map.unmodifiable(_cart);
  List<Equipment> get equipmentList => _equipmentList;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<String> get venues => [
        'GOR Senayan',
        'Pondok Indah Sports',
        'Kemayoran Sports',
        'BSD Sports Center',
        'Kelapa Gading Arena',
        'Menteng Sports',
      ];

  List<String> get categories => [
        'All',
        'Basketball',
        'Tennis',
        'Badminton',
        'Futsal',
        'Volleyball',
        'Accessories',
      ];

  List<Equipment> get filteredEquipment {
    final venueEquipment = _equipmentList
        .where((e) => e.availableVenues.contains(_selectedVenue))
        .toList();

    if (_selectedCategory == 'All') {
      return venueEquipment;
    }
    return venueEquipment
        .where((e) => e.category == _selectedCategory)
        .toList();
  }

  List<Equipment> get availableEquipment {
    return filteredEquipment.where((e) {
      return _isRental ? e.rentalPrice != null : e.buyPrice != null;
    }).toList();
  }

  int get cartItemCount {
    return _cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  double get cartTotal {
    double total = 0;
    _cart.forEach((id, quantity) {
      final equipment = _equipmentList.firstWhere((e) => e.id == id);
      final price = _isRental ? equipment.rentalPrice : equipment.buyPrice;
      if (price != null) {
        total += price * quantity;
      }
    });
    return total;
  }

  // Initialize - load data
  Future<void> initialize() async {
    await loadEquipment();
  }

  // API Methods - Replace with actual API calls
  Future<void> loadEquipment() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.getEquipment();
      // _equipmentList = response.data;

      // Simulating API call with dummy data
      await Future.delayed(const Duration(milliseconds: 500));
      _equipmentList = _getDummyEquipment();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load equipment: ${e.toString()}';
      notifyListeners();
    }
  }

  Future<void> refreshEquipment() async {
    await loadEquipment();
  }

  // Cart operations
  void addToCart(String equipmentId) {
    _cart[equipmentId] = (_cart[equipmentId] ?? 0) + 1;
    notifyListeners();
  }

  void removeFromCart(String equipmentId) {
    if (_cart[equipmentId] != null) {
      if (_cart[equipmentId]! > 1) {
        _cart[equipmentId] = _cart[equipmentId]! - 1;
      } else {
        _cart.remove(equipmentId);
      }
      notifyListeners();
    }
  }

  void updateCartQuantity(String equipmentId, int quantity) {
    if (quantity <= 0) {
      _cart.remove(equipmentId);
    } else {
      _cart[equipmentId] = quantity;
    }
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Filter operations
  void setVenue(String venue) {
    _selectedVenue = venue;
    clearCart(); // Clear cart when changing venue
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setRentalMode(bool isRental) {
    _isRental = isRental;
    clearCart(); // Clear cart when switching modes
    notifyListeners();
  }

  // Checkout - Replace with actual API call
  Future<bool> checkout() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.checkout({
      //   'venue': _selectedVenue,
      //   'isRental': _isRental,
      //   'items': _cart,
      //   'total': cartTotal,
      // });

      // Simulating API call
      await Future.delayed(const Duration(milliseconds: 800));

      clearCart();
      return true;
    } catch (e) {
      _errorMessage = 'Checkout failed: ${e.toString()}';
      notifyListeners();
      return false;
    }
  }

  Equipment? getEquipmentById(String id) {
    try {
      return _equipmentList.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  int getCartQuantity(String equipmentId) {
    return _cart[equipmentId] ?? 0;
  }

  bool isInCart(String equipmentId) {
    return _cart.containsKey(equipmentId);
  }

  // Dummy data - Replace with API response model
  List<Equipment> _getDummyEquipment() {
    return [
      Equipment(
        id: 'eq1',
        name: 'Spalding Basketball',
        brand: 'Spalding',
        description:
            'Official size basketball with superior grip and durability. Perfect for indoor and outdoor courts.',
        category: 'Basketball',
        imageUrl:
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
        rentalPrice: 25000,
        buyPrice: 450000,
        stock: 15,
        availableVenues: [
          'GOR Senayan',
          'Pondok Indah Sports',
          'BSD Sports Center'
        ],
      ),
      Equipment(
        id: 'eq2',
        name: 'Wilson Tennis Racket',
        brand: 'Wilson',
        description:
            'Professional tennis racket with carbon fiber frame. Excellent power and control for all skill levels.',
        category: 'Tennis',
        imageUrl:
            'https://images.unsplash.com/photo-1622279457486-62bcc00d73c7?w=400',
        rentalPrice: 50000,
        buyPrice: 1200000,
        stock: 8,
        availableVenues: ['GOR Senayan', 'Kemayoran Sports', 'Menteng Sports'],
      ),
      Equipment(
        id: 'eq3',
        name: 'Yonex Badminton Racket',
        brand: 'Yonex',
        description:
            'Premium badminton racket with lightweight design and enhanced sweet spot for better performance.',
        category: 'Badminton',
        imageUrl:
            'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400',
        rentalPrice: 35000,
        buyPrice: 850000,
        stock: 12,
        availableVenues: [
          'GOR Senayan',
          'Pondok Indah Sports',
          'Kelapa Gading Arena',
          'Menteng Sports'
        ],
      ),
      Equipment(
        id: 'eq4',
        name: 'Nike Futsal Ball',
        brand: 'Nike',
        description:
            'High-quality futsal ball with optimal bounce and control. Suitable for indoor play.',
        category: 'Futsal',
        imageUrl:
            'https://images.unsplash.com/photo-1614632537423-1e6c2e7e0aac?w=400',
        rentalPrice: 30000,
        buyPrice: 350000,
        stock: 20,
        availableVenues: [
          'BSD Sports Center',
          'Kemayoran Sports',
          'Kelapa Gading Arena'
        ],
      ),
      Equipment(
        id: 'eq5',
        name: 'Mikasa Volleyball',
        brand: 'Mikasa',
        description:
            'Professional-grade volleyball with excellent flight characteristics and durability.',
        category: 'Volleyball',
        imageUrl:
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400',
        rentalPrice: 25000,
        buyPrice: 400000,
        stock: 10,
        availableVenues: ['GOR Senayan', 'BSD Sports Center', 'Menteng Sports'],
      ),
      Equipment(
        id: 'eq6',
        name: 'Nike Basketball Shoes',
        brand: 'Nike',
        description:
            'High-performance basketball shoes with excellent ankle support and cushioning. Available in multiple sizes.',
        category: 'Basketball',
        imageUrl:
            'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400',
        rentalPrice: null,
        buyPrice: 1500000,
        stock: 5,
        availableVenues: [
          'GOR Senayan',
          'Pondok Indah Sports',
          'BSD Sports Center'
        ],
      ),
      Equipment(
        id: 'eq7',
        name: 'Adidas Training Jersey',
        brand: 'Adidas',
        description:
            'Breathable sports jersey with moisture-wicking technology. Perfect for all sports activities.',
        category: 'Accessories',
        imageUrl:
            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400',
        rentalPrice: null,
        buyPrice: 250000,
        stock: 25,
        availableVenues: [
          'GOR Senayan',
          'Pondok Indah Sports',
          'Kemayoran Sports',
          'BSD Sports Center',
          'Kelapa Gading Arena',
          'Menteng Sports'
        ],
      ),
      Equipment(
        id: 'eq8',
        name: 'Head Squash Racket',
        brand: 'Head',
        description:
            'Professional squash racket with titanium frame. Provides exceptional power and precision.',
        category: 'Tennis',
        imageUrl:
            'https://images.unsplash.com/photo-1617883861744-faf14ca36c8c?w=400',
        rentalPrice: 40000,
        buyPrice: 950000,
        stock: 6,
        availableVenues: ['GOR Senayan', 'Menteng Sports'],
      ),
      Equipment(
        id: 'eq9',
        name: 'Li-Ning Badminton Shuttlecock',
        brand: 'Li-Ning',
        description:
            'Tournament-grade feather shuttlecocks. Pack of 12. Excellent flight stability and durability.',
        category: 'Badminton',
        imageUrl:
            'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400',
        rentalPrice: null,
        buyPrice: 180000,
        stock: 30,
        availableVenues: [
          'GOR Senayan',
          'Pondok Indah Sports',
          'Kelapa Gading Arena',
          'Menteng Sports'
        ],
      ),
      Equipment(
        id: 'eq10',
        name: 'Puma Gym Bag',
        brand: 'Puma',
        description:
            'Spacious sports bag with multiple compartments. Water-resistant material and adjustable shoulder strap.',
        category: 'Accessories',
        imageUrl:
            'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400',
        rentalPrice: null,
        buyPrice: 350000,
        stock: 15,
        availableVenues: [
          'GOR Senayan',
          'Pondok Indah Sports',
          'Kemayoran Sports',
          'BSD Sports Center',
          'Kelapa Gading Arena',
          'Menteng Sports'
        ],
      ),
      Equipment(
        id: 'eq11',
        name: 'Wilson Basketball Net',
        brand: 'Wilson',
        description:
            'Durable all-weather basketball net. Heavy-duty construction suitable for outdoor use.',
        category: 'Basketball',
        imageUrl:
            'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400',
        rentalPrice: null,
        buyPrice: 75000,
        stock: 0,
        availableVenues: ['GOR Senayan', 'BSD Sports Center'],
      ),
      Equipment(
        id: 'eq12',
        name: 'Dunlop Tennis Balls',
        brand: 'Dunlop',
        description:
            'Premium tennis balls with extra-long life. Can of 3 balls. ITF approved for tournaments.',
        category: 'Tennis',
        imageUrl:
            'https://images.unsplash.com/photo-1622279457486-62bcc00d73c7?w=400',
        rentalPrice: null,
        buyPrice: 120000,
        stock: 40,
        availableVenues: ['GOR Senayan', 'Kemayoran Sports', 'Menteng Sports'],
      ),
    ];
  }
}

// Equipment Model - Should be moved to models folder in production
class Equipment {
  final String id;
  final String name;
  final String brand;
  final String description;
  final String category;
  final String imageUrl;
  final double? rentalPrice;
  final double? buyPrice;
  final int stock;
  final List<String> availableVenues;

  Equipment({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.category,
    required this.imageUrl,
    this.rentalPrice,
    this.buyPrice,
    required this.stock,
    required this.availableVenues,
  });

  // Factory constructor for API response
  factory Equipment.fromJson(Map<String, dynamic> json) {
    return Equipment(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      rentalPrice: json['rentalPrice'] != null
          ? (json['rentalPrice'] as num).toDouble()
          : null,
      buyPrice: json['buyPrice'] != null
          ? (json['buyPrice'] as num).toDouble()
          : null,
      stock: json['stock'] as int,
      availableVenues: (json['availableVenues'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'description': description,
      'category': category,
      'imageUrl': imageUrl,
      'rentalPrice': rentalPrice,
      'buyPrice': buyPrice,
      'stock': stock,
      'availableVenues': availableVenues,
    };
  }
}
