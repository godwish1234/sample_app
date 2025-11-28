import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';

class CreateActivityViewModel extends BaseViewModel {
  // Selection state
  String? _selectedLocation;
  String? _selectedCourt;
  Map<String, TimeSlot> _selectedTimeSlots = {};
  DateTime _selectedDate = DateTime.now();
  double _totalPrice = 0.0;

  // Collapse states
  bool _isLocationCollapsed = false;
  bool _isCourtCollapsed = false;

  // Loading state
  bool _isLoading = false;
  String? _errorMessage;

  // Data
  List<LocationOption> _locations = [];
  Map<String, List<CourtOption>> _courtsByLocation = {};
  List<TimeOfDay> _availableTimeSlots = [];

  // Getters
  String? get selectedLocation => _selectedLocation;
  String? get selectedCourt => _selectedCourt;
  Map<String, TimeSlot> get selectedTimeSlots => _selectedTimeSlots;
  DateTime get selectedDate => _selectedDate;
  double get totalPrice => _totalPrice;
  bool get isLocationCollapsed => _isLocationCollapsed;
  bool get isCourtCollapsed => _isCourtCollapsed;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<LocationOption> get locations => _locations;
  Map<String, List<CourtOption>> get courtsByLocation => _courtsByLocation;
  List<TimeOfDay> get availableTimeSlots => _availableTimeSlots;

  List<CourtOption> get courtsForSelectedLocation {
    if (_selectedLocation == null) return [];
    return _courtsByLocation[_selectedLocation] ?? [];
  }

  CourtOption? get selectedCourtData {
    if (_selectedLocation == null || _selectedCourt == null) return null;
    return _courtsByLocation[_selectedLocation!]
        ?.firstWhere((court) => court.name == _selectedCourt);
  }

  // Initialize and load data
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        _loadLocations(),
        _loadCourts(),
        _loadAvailableTimeSlots(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load data: ${e.toString()}';
      notifyListeners();
    }
  }

  // API Methods - Replace with actual API calls
  Future<void> _loadLocations() async {
    // TODO: Replace with actual API call
    // final response = await _apiService.getLocations();
    // _locations = response.data.map((e) => LocationOption.fromJson(e)).toList();

    await Future.delayed(const Duration(milliseconds: 300));
    _locations = _getDummyLocations();
  }

  Future<void> _loadCourts() async {
    // TODO: Replace with actual API call
    // final response = await _apiService.getCourts();
    // _courtsByLocation = response.data;

    await Future.delayed(const Duration(milliseconds: 300));
    _courtsByLocation = _getDummyCourts();
  }

  Future<void> _loadAvailableTimeSlots() async {
    // TODO: Replace with actual API call
    // final response = await _apiService.getAvailableTimeSlots();
    // _availableTimeSlots = response.data;

    await Future.delayed(const Duration(milliseconds: 300));
    _availableTimeSlots = _getDummyTimeSlots();
  }

  // Selection methods
  void selectLocation(String location) {
    _selectedLocation = location;
    _selectedCourt = null;
    _selectedTimeSlots.clear();
    _totalPrice = 0.0;
    _isLocationCollapsed = true;
    _isCourtCollapsed = false;
    notifyListeners();
  }

  void toggleLocationCollapse() {
    _isLocationCollapsed = !_isLocationCollapsed;
    notifyListeners();
  }

  void selectCourt(String court) {
    _selectedCourt = court;
    _selectedTimeSlots.clear();
    _totalPrice = 0.0;
    _isCourtCollapsed = true;
    notifyListeners();
  }

  void toggleCourtCollapse() {
    _isCourtCollapsed = !_isCourtCollapsed;
    notifyListeners();
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void toggleTimeSlot(DateTime date, TimeOfDay time) {
    final key =
        '${DateFormat('yyyy-MM-dd').format(date)}_${time.hour}:${time.minute}';

    if (_selectedTimeSlots.containsKey(key)) {
      _selectedTimeSlots.remove(key);
    } else {
      _selectedTimeSlots[key] = TimeSlot(date: date, time: time);
    }

    _updateTotalPrice();
    notifyListeners();
  }

  bool isTimeSlotSelected(DateTime date, TimeOfDay time) {
    final key =
        '${DateFormat('yyyy-MM-dd').format(date)}_${time.hour}:${time.minute}';
    return _selectedTimeSlots.containsKey(key);
  }

  void _updateTotalPrice() {
    if (selectedCourtData != null) {
      _totalPrice = _selectedTimeSlots.length * selectedCourtData!.pricePerHour;
    } else {
      _totalPrice = 0.0;
    }
  }

  // Dummy data methods
  List<LocationOption> _getDummyLocations() {
    return [
      LocationOption(
        id: '1',
        name: 'Senayan Sports Complex',
        address: 'Jl. Pintu Satu Senayan, Jakarta Pusat',
        distance: '2.1 km',
        city: 'Jakarta Pusat',
        icon: 'location_city',
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
      ),
      LocationOption(
        id: '2',
        name: 'Pondok Indah Sports Center',
        address: 'Jl. Metro Pondok Indah, Jakarta Selatan',
        distance: '5.3 km',
        city: 'Jakarta Selatan',
        icon: 'sports_tennis',
        imageUrl: 'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
      ),
      LocationOption(
        id: '3',
        name: 'Kemayoran Sports Hall',
        address: 'Jl. Benyamin Sueb, Jakarta Utara',
        distance: '3.8 km',
        city: 'Jakarta Utara',
        icon: 'sports_basketball',
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
      ),
      LocationOption(
        id: '4',
        name: 'Cengkareng Sports Center',
        address: 'Jl. Kamal Raya, Jakarta Barat',
        distance: '12.5 km',
        city: 'Jakarta Barat',
        icon: 'sports_volleyball',
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
      ),
      LocationOption(
        id: '5',
        name: 'Rawamangun Sports Complex',
        address: 'Jl. Pemuda, Jakarta Timur',
        distance: '8.7 km',
        city: 'Jakarta Timur',
        icon: 'sports_soccer',
        imageUrl:
            'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
      ),
      LocationOption(
        id: '6',
        name: 'BSD Sports Arena',
        address: 'Jl. BSD Raya, Tangerang Selatan',
        distance: '18.2 km',
        city: 'Tangerang Selatan',
        icon: 'sports',
        imageUrl:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
      ),
    ];
  }

  Map<String, List<CourtOption>> _getDummyCourts() {
    return {
      'Senayan Sports Complex': [
        CourtOption(
          id: 'court_1',
          name: 'Lapangan Basket Utama',
          sport: 'Basketball',
          pricePerHour: 150000.0,
          icon: 'sports_basketball',
          colorValue: 0xFFFF9800,
          isAvailable: true,
          imageUrl:
              'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
          description: 'Lapangan basket indoor dengan lantai kayu profesional',
        ),
        CourtOption(
          id: 'court_2',
          name: 'Lapangan Tenis Outdoor',
          sport: 'Tennis',
          pricePerHour: 200000.0,
          icon: 'sports_tennis',
          colorValue: 0xFF4CAF50,
          isAvailable: true,
          imageUrl: 'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
          description:
              'Lapangan tenis outdoor dengan permukaan keras berkualitas',
        ),
        CourtOption(
          id: 'court_3',
          name: 'Lapangan Voli Indoor',
          sport: 'Volleyball',
          pricePerHour: 120000.0,
          icon: 'sports_volleyball',
          colorValue: 0xFF9C27B0,
          isAvailable: false,
          imageUrl:
              'https://images.unsplash.com/photo-1594736797933-d0d4319e4d11',
          description: 'Lapangan voli indoor dengan net standar internasional',
        ),
      ],
      'Pondok Indah Sports Center': [
        CourtOption(
          id: 'court_4',
          name: 'Court Tenis Premium',
          sport: 'Tennis',
          pricePerHour: 250000.0,
          icon: 'sports_tennis',
          colorValue: 0xFF4CAF50,
          isAvailable: true,
          imageUrl:
              'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
          description:
              'Lapangan tenis clay dengan lampu penerangan untuk malam',
        ),
        CourtOption(
          id: 'court_5',
          name: 'Lapangan Badminton A',
          sport: 'Badminton',
          pricePerHour: 80000.0,
          icon: 'sports',
          colorValue: 0xFFF44336,
          isAvailable: true,
          imageUrl:
              'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
          description: 'Lapangan badminton indoor dengan lantai kayu',
        ),
      ],
      'Kemayoran Sports Hall': [
        CourtOption(
          id: 'court_6',
          name: 'Arena Basket Utama',
          sport: 'Basketball',
          pricePerHour: 180000.0,
          icon: 'sports_basketball',
          colorValue: 0xFFFF9800,
          isAvailable: true,
          imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
          description: 'Arena basket indoor dengan tribun penonton',
        ),
      ],
      'Cengkareng Sports Center': [
        CourtOption(
          id: 'court_7',
          name: 'Lapangan Serbaguna',
          sport: 'Multi-sport',
          pricePerHour: 100000.0,
          icon: 'sports',
          colorValue: 0xFF3F51B5,
          isAvailable: true,
          imageUrl:
              'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
          description:
              'Lapangan serbaguna untuk basket, voli, dan olahraga lainnya',
        ),
      ],
      'Rawamangun Sports Complex': [
        CourtOption(
          id: 'court_8',
          name: 'Lapangan Sepak Bola',
          sport: 'Football',
          pricePerHour: 300000.0,
          icon: 'sports_soccer',
          colorValue: 0xFF4CAF50,
          isAvailable: true,
          imageUrl:
              'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
          description: 'Lapangan sepak bola outdoor dengan rumput alami',
        ),
      ],
      'BSD Sports Arena': [
        CourtOption(
          id: 'court_9',
          name: 'Court Tenis Modern',
          sport: 'Tennis',
          pricePerHour: 220000.0,
          icon: 'sports_tennis',
          colorValue: 0xFF4CAF50,
          isAvailable: true,
          imageUrl:
              'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
          description: 'Lapangan tenis modern dengan fasilitas lengkap',
        ),
      ],
    };
  }

  List<TimeOfDay> _getDummyTimeSlots() {
    return List.generate(16, (index) => TimeOfDay(hour: 6 + index, minute: 0));
  }
}

// Models
class LocationOption {
  final String id;
  final String name;
  final String address;
  final String distance;
  final String city;
  final String icon;
  final String imageUrl;

  LocationOption({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.city,
    required this.icon,
    required this.imageUrl,
  });

  factory LocationOption.fromJson(Map<String, dynamic> json) {
    return LocationOption(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      distance: json['distance'] as String,
      city: json['city'] as String,
      icon: json['icon'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'city': city,
      'icon': icon,
      'imageUrl': imageUrl,
    };
  }
}

class CourtOption {
  final String id;
  final String name;
  final String sport;
  final double pricePerHour;
  final String icon;
  final int colorValue;
  final bool isAvailable;
  final String imageUrl;
  final String description;

  CourtOption({
    required this.id,
    required this.name,
    required this.sport,
    required this.pricePerHour,
    required this.icon,
    required this.colorValue,
    required this.isAvailable,
    required this.imageUrl,
    required this.description,
  });

  Color get color => Color(colorValue);

  factory CourtOption.fromJson(Map<String, dynamic> json) {
    return CourtOption(
      id: json['id'] as String,
      name: json['name'] as String,
      sport: json['sport'] as String,
      pricePerHour: (json['pricePerHour'] as num).toDouble(),
      icon: json['icon'] as String,
      colorValue: json['colorValue'] as int,
      isAvailable: json['isAvailable'] as bool,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sport': sport,
      'pricePerHour': pricePerHour,
      'icon': icon,
      'colorValue': colorValue,
      'isAvailable': isAvailable,
      'imageUrl': imageUrl,
      'description': description,
    };
  }
}

class TimeSlot {
  final DateTime date;
  final TimeOfDay time;

  TimeSlot({
    required this.date,
    required this.time,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'hour': time.hour,
      'minute': time.minute,
    };
  }
}
