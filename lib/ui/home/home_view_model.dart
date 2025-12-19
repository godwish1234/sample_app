import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/services/services.dart';

class HomeViewModel extends BaseViewModel {
  static final notificationService = GetIt.instance.get<NotificationService>();

  // User data
  User? user;

  // Date selection
  DateTime? _selectedStartDate;
  DateTime? get selectedStartDate => _selectedStartDate;

  DateTime? _selectedEndDate;
  DateTime? get selectedEndDate => _selectedEndDate;

  // Data state
  List<NewsItem> _newsItems = [];
  List<Reminder> _reminders = [];
  List<Venue> _venues = [];
  List<QuickAction> _quickActions = [];

  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  List<NewsItem> get newsItems => _newsItems;
  List<Reminder> get reminders => _reminders;
  List<Venue> get venues => _venues;
  List<QuickAction> get quickActions => _quickActions;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get urgent reminders for compact view, sorted by nearest due date
  List<Reminder> get urgentReminders {
    final reminders = List<Reminder>.from(_reminders);
    reminders.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    return reminders.take(3).toList();
  }

  bool get hasMoreReminders => _reminders.length > 3;

  Future<void> initialize() async {
    user = FirebaseAuth.instance.currentUser;

    DateTime startDate = DateTime.now().subtract(const Duration(days: 4));
    await updateDate(
        DateTime(startDate.year, startDate.month, startDate.day, 0, 0),
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day,
            23, 59));

    await loadHomeData();
  }

  // Load all home data
  Future<void> loadHomeData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Load data in parallel
      await Future.wait([
        _loadNews(),
        _loadReminders(),
        _loadVenues(),
        _loadQuickActions(),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load data: ${e.toString()}';
      notifyListeners();
    }
  }

  // Refresh all data
  Future<void> refreshData() async {
    await loadHomeData();
  }

  // API Methods - Replace with actual API calls

  Future<void> _loadNews() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.getNews();
      // _newsItems = response.data.map((e) => NewsItem.fromJson(e)).toList();

      // Simulating API call with dummy data
      await Future.delayed(const Duration(milliseconds: 300));
      _newsItems = _getDummyNews();
    } catch (e) {
      throw Exception('Failed to load news: $e');
    }
  }

  Future<void> _loadReminders() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.getReminders();
      // _reminders = response.data.map((e) => Reminder.fromJson(e)).toList();

      // Simulating API call with dummy data
      await Future.delayed(const Duration(milliseconds: 300));
      _reminders = _getDummyReminders();
    } catch (e) {
      throw Exception('Failed to load reminders: $e');
    }
  }

  Future<void> _loadVenues() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.getVenues();
      // _venues = response.data.map((e) => Venue.fromJson(e)).toList();

      // Simulating API call with dummy data
      await Future.delayed(const Duration(milliseconds: 300));
      _venues = _getDummyVenues();
    } catch (e) {
      throw Exception('Failed to load venues: $e');
    }
  }

  Future<void> _loadQuickActions() async {
    try {
      // TODO: Replace with actual API call
      // final response = await _apiService.getQuickActions();
      // _quickActions = response.data.map((e) => QuickAction.fromJson(e)).toList();

      // Simulating API call with dummy data
      await Future.delayed(const Duration(milliseconds: 300));
      _quickActions = _getDummyQuickActions();
    } catch (e) {
      throw Exception('Failed to load quick actions: $e');
    }
  }

  Future<void> bookCourt(String courtId) async {
    // TODO: Implement court booking API call
  }

  Future updateDate(DateTime startDate, DateTime endDate) async {
    _selectedStartDate = startDate;
    _selectedEndDate = endDate;
    notifyListeners();
  }

  // Dummy data methods - Replace with API calls

  List<NewsItem> _getDummyNews() {
    return [
      NewsItem(
        id: 'news1',
        imageUrl:
            'https://images.unsplash.com/photo-1511067007398-7e4b90cfa4bc',
        title: 'Jakarta Tennis Championship',
        subtitle: 'This Weekend at Senayan',
        category: 'Tournament',
      ),
      NewsItem(
        id: 'news2',
        imageUrl:
            'https://images.unsplash.com/photo-1526232761682-d26e03ac148e',
        title: 'New Badminton Courts',
        subtitle: 'Opening at Kemayoran Sports Hall',
        category: 'Facility',
      ),
      NewsItem(
        id: 'news3',
        imageUrl:
            'https://images.unsplash.com/photo-1613741616446-1fcdec4d1ba5',
        title: 'Futsal League Registration',
        subtitle: 'Now Open - BSD Sports Arena',
        category: 'Registration',
      ),
      NewsItem(
        id: 'news4',
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        title: 'Basketball Tournament',
        subtitle: 'Pondok Indah Sports Center',
        category: 'Competition',
      ),
      NewsItem(
        id: 'news5',
        imageUrl:
            'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
        title: 'Swimming Pool Renovation',
        subtitle: 'Completed at Cengkareng Center',
        category: 'Update',
      ),
    ];
  }

  List<Reminder> _getDummyReminders() {
    final now = DateTime.now();
    return [
      Reminder(
        id: 'rem1',
        type: 'Event',
        title: 'Badminton Match',
        time: 'Tomorrow 2:00 PM - Senayan',
        icon: 'sports_tennis',
        dueDate: now.add(const Duration(days: 1)),
      ),
      Reminder(
        id: 'rem2',
        type: 'Payment',
        title: 'Court Booking Payment',
        time: 'Rp 150,000 - Due in 3 days',
        icon: 'credit_card',
        dueDate: now.add(const Duration(days: 3)),
      ),
      Reminder(
        id: 'rem3',
        type: 'Competition',
        title: 'Jakarta Futsal League',
        time: '7:00 PM - BSD Arena',
        icon: 'emoji_events',
        dueDate: now.add(const Duration(days: 5)),
      ),
      Reminder(
        id: 'rem4',
        type: 'Event',
        title: 'Tennis Coaching Session',
        time: '10:00 AM - Pondok Indah',
        icon: 'sports_tennis',
        dueDate: now.add(const Duration(days: 2)),
      ),
      Reminder(
        id: 'rem5',
        type: 'Reminder',
        title: 'Equipment Return',
        time: 'Racket rental due',
        icon: 'fitness_center',
        dueDate: now.add(const Duration(hours: 8)),
      ),
      Reminder(
        id: 'rem6',
        type: 'Event',
        title: 'Swimming Practice',
        time: '6:00 AM - Kemayoran',
        icon: 'pool',
        dueDate: now.add(const Duration(days: 7)),
      ),
    ];
  }

  List<Venue> _getDummyVenues() {
    return [
      Venue(
        id: 'senayan',
        name: 'Senayan Sports Complex',
        address: 'Jl. Pintu Satu Senayan, Jakarta Pusat',
        distance: '2.1 km',
        rating: 4.8,
        reviewCount: 156,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        priceRange: 'Rp 120,000 - 200,000',
        category: 'Premium',
        features: ['Basketball', 'Tennis', 'Volleyball'],
        openHours: '06:00 - 22:00',
        description:
            'Premier sports complex in the heart of Jakarta with world-class facilities and professional courts.',
        images: [
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
          'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
        ],
        reviews: [
          VenueReview(
            name: 'Ahmad Rizki',
            rating: 5,
            comment:
                'Excellent facilities and well-maintained courts. Staff is very professional.',
            date: '2 days ago',
          ),
          VenueReview(
            name: 'Sarah Putri',
            rating: 4,
            comment: 'Great location but can get crowded during peak hours.',
            date: '1 week ago',
          ),
        ],
      ),
      Venue(
        id: 'pondok_indah',
        name: 'Pondok Indah Sports Center',
        address: 'Jl. Metro Pondok Indah, Jakarta Selatan',
        distance: '5.3 km',
        rating: 4.6,
        reviewCount: 98,
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        priceRange: 'Rp 100,000 - 180,000',
        category: 'Standard',
        features: ['Badminton', 'Tennis', 'Squash'],
        openHours: '07:00 - 21:00',
        description:
            'Family-friendly sports center with modern amenities and professional coaching available.',
        images: [
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        ],
        reviews: [],
      ),
      Venue(
        id: 'kemayoran',
        name: 'Kemayoran Sports Hall',
        address: 'Jl. Kemayoran Gempol, Jakarta Pusat',
        distance: '3.8 km',
        rating: 4.5,
        reviewCount: 124,
        imageUrl: 'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
        priceRange: 'Rp 80,000 - 150,000',
        category: 'Budget',
        features: ['Badminton', 'Futsal', 'Volleyball'],
        openHours: '06:00 - 23:00',
        description:
            'Affordable sports hall with good facilities for recreational and competitive play.',
        images: [
          'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
        ],
        reviews: [],
      ),
    ];
  }

  List<QuickAction> _getDummyQuickActions() {
    return [
      // Primary Actions - Main features
      QuickAction(
        id: 'new_booking',
        icon: Icons.calendar_month_rounded,
        label: 'New Booking',
        color: const Color(0xFF2563EB), // Blue
        available: true,
        isPrimary: true,
      ),
      QuickAction(
        id: 'find_game',
        icon: Icons.sports_tennis_rounded,
        label: 'Find Game',
        color: const Color(0xFF10B981), // Green
        available: true,
        isPrimary: true,
      ),
    ];
  }
}

// Models - Should be moved to models folder in production

class NewsItem {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String category;

  NewsItem({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.category,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      category: json['category'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imageUrl': imageUrl,
      'title': title,
      'subtitle': subtitle,
      'category': category,
    };
  }
}

class Reminder {
  final String id;
  final String type;
  final String title;
  final String time;
  final String icon;
  final DateTime dueDate;

  Reminder({
    required this.id,
    required this.type,
    required this.title,
    required this.time,
    required this.icon,
    required this.dueDate,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      time: json['time'] as String,
      icon: json['icon'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'time': time,
      'icon': icon,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}

class Venue {
  final String id;
  final String name;
  final String address;
  final String distance;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String priceRange;
  final String category;
  final List<String> features;
  final String openHours;
  final String description;
  final List<String> images;
  final List<VenueReview> reviews;

  Venue({
    required this.id,
    required this.name,
    required this.address,
    required this.distance,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.priceRange,
    required this.category,
    required this.features,
    required this.openHours,
    required this.description,
    required this.images,
    required this.reviews,
  });

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      distance: json['distance'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['reviewCount'] as int,
      imageUrl: json['imageUrl'] as String,
      priceRange: json['priceRange'] as String,
      category: json['category'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      openHours: json['openHours'] as String,
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      reviews: (json['reviews'] as List<dynamic>)
          .map((e) => VenueReview.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'distance': distance,
      'rating': rating,
      'reviewCount': reviewCount,
      'imageUrl': imageUrl,
      'priceRange': priceRange,
      'category': category,
      'features': features,
      'openHours': openHours,
      'description': description,
      'images': images,
      'reviews': reviews.map((e) => e.toJson()).toList(),
    };
  }
}

class VenueReview {
  final String name;
  final int rating;
  final String comment;
  final String date;

  VenueReview({
    required this.name,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory VenueReview.fromJson(Map<String, dynamic> json) {
    return VenueReview(
      name: json['name'] as String,
      rating: json['rating'] as int,
      comment: json['comment'] as String,
      date: json['date'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'rating': rating,
      'comment': comment,
      'date': date,
    };
  }
}

class QuickAction {
  final String id;
  final IconData icon;
  final String label;
  final Color color;
  final bool available;
  final bool isPrimary;

  QuickAction({
    required this.id,
    required this.icon,
    required this.label,
    required this.color,
    this.available = true,
    this.isPrimary = false,
  });

  factory QuickAction.fromJson(Map<String, dynamic> json) {
    // TODO: When API is ready, implement icon and color parsing from strings
    // For now, this won't be called as we use local data
    return QuickAction(
      id: json['id'] as String,
      icon: Icons.help_outline, // Default icon
      label: json['label'] as String,
      color: Colors.blue, // Default color
      available: json['available'] as bool? ?? true,
      isPrimary: json['isPrimary'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    // TODO: When API is ready, convert IconData and Color to strings
    return {
      'id': id,
      'icon': icon.codePoint.toString(),
      'label': label,
      'color': color.value.toString(),
      'available': available,
      'isPrimary': isPrimary,
    };
  }
}
