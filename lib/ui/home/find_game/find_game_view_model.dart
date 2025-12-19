import 'package:stacked/stacked.dart';

class FindGameViewModel extends BaseViewModel {
  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  List<PublicGame> _games = [];
  List<PublicGame> get games => _games;

  // Filter properties
  List<String> _selectedSports = [];
  List<String> get selectedSports => _selectedSports;

  List<String> _selectedSkillLevels = [];
  List<String> get selectedSkillLevels => _selectedSkillLevels;

  double _minPrice = 0;
  double get minPrice => _minPrice;

  double _maxPrice = 200000;
  double get maxPrice => _maxPrice;

  int _maxDistance = 50; // km
  int get maxDistance => _maxDistance;

  bool get hasActiveFilters =>
      _selectedSports.isNotEmpty ||
      _selectedSkillLevels.isNotEmpty ||
      _minPrice > 0 ||
      _maxPrice < 200000 ||
      _maxDistance < 50;

  List<PublicGame> get filteredGames {
    return _games.where((game) {
      // Date filter
      bool dateMatch = game.date.year == _selectedDate.year &&
          game.date.month == _selectedDate.month &&
          game.date.day == _selectedDate.day;

      if (!dateMatch) return false;

      // Sport filter
      if (_selectedSports.isNotEmpty && !_selectedSports.contains(game.sport)) {
        return false;
      }

      // Skill level filter
      if (_selectedSkillLevels.isNotEmpty &&
          !_selectedSkillLevels.contains(game.skillLevel)) {
        return false;
      }

      // Price filter
      if (game.pricePerPerson < _minPrice || game.pricePerPerson > _maxPrice) {
        return false;
      }

      return true;
    }).toList();
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    await loadGames();
  }

  Future<void> loadGames() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // TODO: Replace with actual API call
      await Future.delayed(const Duration(milliseconds: 500));
      _games = _getDummyGames();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Failed to load games: ${e.toString()}';
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  void toggleSportFilter(String sport) {
    if (_selectedSports.contains(sport)) {
      _selectedSports.remove(sport);
    } else {
      _selectedSports.add(sport);
    }
    notifyListeners();
  }

  void toggleSkillLevelFilter(String level) {
    if (_selectedSkillLevels.contains(level)) {
      _selectedSkillLevels.remove(level);
    } else {
      _selectedSkillLevels.add(level);
    }
    notifyListeners();
  }

  void updatePriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void updateMaxDistance(int distance) {
    _maxDistance = distance;
    notifyListeners();
  }

  void clearFilters() {
    _selectedSports.clear();
    _selectedSkillLevels.clear();
    _minPrice = 0;
    _maxPrice = 200000;
    _maxDistance = 50;
    notifyListeners();
  }

  Future<void> joinGame(String gameId) async {
    // TODO: Implement join game API call
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      // Show success message or navigate to game details
    } catch (e) {
      _errorMessage = 'Failed to join game: ${e.toString()}';
      notifyListeners();
    }
  }

  List<PublicGame> _getDummyGames() {
    final now = DateTime.now();
    return [
      PublicGame(
        id: 'game1',
        title: 'Badminton Singles Match',
        sport: 'Badminton',
        venue: 'Senayan Sports Complex',
        address: 'Jl. Pintu Satu Senayan, Jakarta Pusat',
        date: now,
        startTime: '18:00',
        endTime: '20:00',
        currentPlayers: 3,
        maxPlayers: 4,
        skillLevel: 'Intermediate',
        pricePerPerson: 50000,
        hostName: 'Ahmad Rizki',
        hostImage:
            'https://ui-avatars.com/api/?name=Ahmad+Rizki&background=2563EB&color=fff',
        description: 'Looking for 1 more player for badminton singles!',
        imageUrl:
            'https://images.unsplash.com/photo-1626224583764-f87db24ac4ea?w=400',
      ),
      PublicGame(
        id: 'game2',
        title: 'Friendly Futsal Match',
        sport: 'Futsal',
        venue: 'BSD Sports Arena',
        address: 'Jl. BSD Raya, Tangerang Selatan',
        date: now,
        startTime: '19:00',
        endTime: '21:00',
        currentPlayers: 8,
        maxPlayers: 10,
        skillLevel: 'Beginner',
        pricePerPerson: 75000,
        hostName: 'Sarah Putri',
        hostImage:
            'https://ui-avatars.com/api/?name=Sarah+Putri&background=10B981&color=fff',
        description: 'Casual futsal game, all levels welcome!',
        imageUrl:
            'https://images.unsplash.com/photo-1613741616446-1fcdec4d1ba5?w=400',
      ),
      PublicGame(
        id: 'game3',
        title: 'Morning Basketball',
        sport: 'Basketball',
        venue: 'Pondok Indah Sports Center',
        address: 'Jl. Metro Pondok Indah, Jakarta Selatan',
        date: now.add(const Duration(days: 1)),
        startTime: '07:00',
        endTime: '09:00',
        currentPlayers: 6,
        maxPlayers: 10,
        skillLevel: 'Advanced',
        pricePerPerson: 60000,
        hostName: 'Budi Santoso',
        hostImage:
            'https://ui-avatars.com/api/?name=Budi+Santoso&background=F59E0B&color=fff',
        description: 'Early morning basketball session for advanced players.',
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=400',
      ),
      PublicGame(
        id: 'game4',
        title: 'Tennis Doubles Practice',
        sport: 'Tennis',
        venue: 'Kemayoran Sports Hall',
        address: 'Jl. Kemayoran Gempol, Jakarta Pusat',
        date: now.add(const Duration(days: 1)),
        startTime: '16:00',
        endTime: '18:00',
        currentPlayers: 2,
        maxPlayers: 4,
        skillLevel: 'Intermediate',
        pricePerPerson: 80000,
        hostName: 'Diana Lestari',
        hostImage:
            'https://ui-avatars.com/api/?name=Diana+Lestari&background=EC4899&color=fff',
        description: 'Looking for a doubles partner for tennis practice.',
        imageUrl:
            'https://images.unsplash.com/photo-1511067007398-7e4b90cfa4bc?w=400',
      ),
      PublicGame(
        id: 'game5',
        title: 'Volleyball Beach Session',
        sport: 'Volleyball',
        venue: 'Ancol Beach Sports',
        address: 'Jl. Lodan Timur, Jakarta Utara',
        date: now.add(const Duration(days: 2)),
        startTime: '09:00',
        endTime: '11:00',
        currentPlayers: 4,
        maxPlayers: 8,
        skillLevel: 'All Levels',
        pricePerPerson: 40000,
        hostName: 'Eko Prasetyo',
        hostImage:
            'https://ui-avatars.com/api/?name=Eko+Prasetyo&background=8B5CF6&color=fff',
        description: 'Beach volleyball fun for everyone!',
        imageUrl:
            'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1?w=400',
      ),
    ];
  }
}

class PublicGame {
  final String id;
  final String title;
  final String sport;
  final String venue;
  final String address;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int currentPlayers;
  final int maxPlayers;
  final String skillLevel;
  final int pricePerPerson;
  final String hostName;
  final String hostImage;
  final String description;
  final String imageUrl;

  PublicGame({
    required this.id,
    required this.title,
    required this.sport,
    required this.venue,
    required this.address,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.currentPlayers,
    required this.maxPlayers,
    required this.skillLevel,
    required this.pricePerPerson,
    required this.hostName,
    required this.hostImage,
    required this.description,
    required this.imageUrl,
  });

  bool get isFull => currentPlayers >= maxPlayers;
  int get spotsLeft => maxPlayers - currentPlayers;
}
