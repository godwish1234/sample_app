import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sample_app/ui/activities/new_activity/event_details_view.dart';

class CreateActivityView extends StatefulWidget {
  const CreateActivityView({super.key});

  @override
  State<CreateActivityView> createState() => _CreateActivityViewState();
}

class _CreateActivityViewState extends State<CreateActivityView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String? selectedLocation;
  String? selectedCourt;
  Map<String, TimeSlot> selectedTimeSlots = {};
  double totalPrice = 0.0;
  DateTime selectedDate = DateTime.now();
  final PageController _datePageController = PageController();

  // Location data
  final List<LocationOption> locations = [
    LocationOption(
      name: 'Senayan Sports Complex',
      address: 'Jl. Pintu Satu Senayan, Jakarta Pusat',
      distance: '2.1 km',
      city: 'Jakarta Pusat',
      icon: Icons.location_city,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
    ),
    LocationOption(
      name: 'Pondok Indah Sports Center',
      address: 'Jl. Metro Pondok Indah, Jakarta Selatan',
      distance: '5.3 km',
      city: 'Jakarta Selatan',
      icon: Icons.sports_tennis,
      imageUrl: 'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
    ),
    LocationOption(
      name: 'Kemayoran Sports Hall',
      address: 'Jl. Benyamin Sueb, Jakarta Utara',
      distance: '3.8 km',
      city: 'Jakarta Utara',
      icon: Icons.sports_basketball,
      imageUrl: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
    ),
    LocationOption(
      name: 'Cengkareng Sports Center',
      address: 'Jl. Kamal Raya, Jakarta Barat',
      distance: '12.5 km',
      city: 'Jakarta Barat',
      icon: Icons.sports_volleyball,
      imageUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
    ),
    LocationOption(
      name: 'Rawamangun Sports Complex',
      address: 'Jl. Pemuda, Jakarta Timur',
      distance: '8.7 km',
      city: 'Jakarta Timur',
      icon: Icons.sports_soccer,
      imageUrl: 'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
    ),
    LocationOption(
      name: 'BSD Sports Arena',
      address: 'Jl. BSD Raya, Tangerang Selatan',
      distance: '18.2 km',
      city: 'Tangerang Selatan',
      icon: Icons.sports,
      imageUrl: 'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
    ),
  ];

  // Courts data by location
  final Map<String, List<CourtOption>> courtsByLocation = {
    'Senayan Sports Complex': [
      CourtOption(
        name: 'Lapangan Basket Utama',
        sport: 'Basketball',
        pricePerHour: 150000.0,
        icon: Icons.sports_basketball,
        color: Colors.orange,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        description: 'Lapangan basket indoor dengan lantai kayu profesional',
      ),
      CourtOption(
        name: 'Lapangan Tenis Outdoor',
        sport: 'Tennis',
        pricePerHour: 200000.0,
        icon: Icons.sports_tennis,
        color: Colors.green,
        isAvailable: true,
        imageUrl: 'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
        description:
            'Lapangan tenis outdoor dengan permukaan keras berkualitas',
      ),
      CourtOption(
        name: 'Lapangan Voli Indoor',
        sport: 'Volleyball',
        pricePerHour: 120000.0,
        icon: Icons.sports_volleyball,
        color: Colors.purple,
        isAvailable: false,
        imageUrl:
            'https://images.unsplash.com/photo-1594736797933-d0d4319e4d11',
        description: 'Lapangan voli indoor dengan net standar internasional',
      ),
    ],
    'Pondok Indah Sports Center': [
      CourtOption(
        name: 'Court Tenis Premium',
        sport: 'Tennis',
        pricePerHour: 250000.0,
        icon: Icons.sports_tennis,
        color: Colors.green,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
        description: 'Lapangan tenis clay dengan lampu penerangan untuk malam',
      ),
      CourtOption(
        name: 'Lapangan Badminton A',
        sport: 'Badminton',
        pricePerHour: 80000.0,
        icon: Icons.sports,
        color: Colors.red,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
        description: 'Lapangan badminton indoor dengan lantai kayu',
      ),
      CourtOption(
        name: 'Lapangan Squash',
        sport: 'Squash',
        pricePerHour: 100000.0,
        icon: Icons.sports_tennis,
        color: Colors.blue,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        description: 'Lapangan squash dengan dinding kaca transparan',
      ),
    ],
    'Kemayoran Sports Hall': [
      CourtOption(
        name: 'Arena Basket Utama',
        sport: 'Basketball',
        pricePerHour: 180000.0,
        icon: Icons.sports_basketball,
        color: Colors.orange,
        isAvailable: true,
        imageUrl: 'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        description: 'Arena basket indoor dengan tribun penonton',
      ),
      CourtOption(
        name: 'Lapangan Futsal',
        sport: 'Futsal',
        pricePerHour: 200000.0,
        icon: Icons.sports_soccer,
        color: Colors.blue,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        description: 'Lapangan futsal indoor dengan rumput sintetis',
      ),
    ],
    'Cengkareng Sports Center': [
      CourtOption(
        name: 'Lapangan Serbaguna',
        sport: 'Multi-sport',
        pricePerHour: 100000.0,
        icon: Icons.sports,
        color: Colors.indigo,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        description:
            'Lapangan serbaguna untuk basket, voli, dan olahraga lainnya',
      ),
      CourtOption(
        name: 'Lapangan Bulu Tangkis',
        sport: 'Badminton',
        pricePerHour: 70000.0,
        icon: Icons.sports,
        color: Colors.red,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
        description: 'Lapangan badminton dengan 4 court paralel',
      ),
    ],
    'Rawamangun Sports Complex': [
      CourtOption(
        name: 'Lapangan Sepak Bola',
        sport: 'Football',
        pricePerHour: 300000.0,
        icon: Icons.sports_soccer,
        color: Colors.green,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        description: 'Lapangan sepak bola outdoor dengan rumput alami',
      ),
      CourtOption(
        name: 'Lapangan Atletik',
        sport: 'Athletics',
        pricePerHour: 150000.0,
        icon: Icons.directions_run,
        color: Colors.orange,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        description: 'Track atletik 400m dengan fasilitas lompat',
      ),
    ],
    'BSD Sports Arena': [
      CourtOption(
        name: 'Court Tenis Modern',
        sport: 'Tennis',
        pricePerHour: 220000.0,
        icon: Icons.sports_tennis,
        color: Colors.green,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
        description: 'Lapangan tenis modern dengan fasilitas lengkap',
      ),
      CourtOption(
        name: 'Arena Basket Premium',
        sport: 'Basketball',
        pricePerHour: 200000.0,
        icon: Icons.sports_basketball,
        color: Colors.orange,
        isAvailable: true,
        imageUrl:
            'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        description: 'Arena basket premium dengan AC dan sound system',
      ),
    ],
  };

  // Time slots for the next 7 days
  List<DateTime> get availableDates {
    return List.generate(
        365, (index) => DateTime.now().add(Duration(days: index)));
  }

  List<DateTime> get visibleDates {
    int daysSinceToday = selectedDate.difference(DateTime.now()).inDays;
    return List.generate(7,
        (index) => DateTime.now().add(Duration(days: daysSinceToday + index)));
  }

  List<TimeOfDay> get availableTimeSlots {
    return [
      const TimeOfDay(hour: 6, minute: 0),
      const TimeOfDay(hour: 7, minute: 0),
      const TimeOfDay(hour: 8, minute: 0),
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 11, minute: 0),
      const TimeOfDay(hour: 12, minute: 0),
      const TimeOfDay(hour: 13, minute: 0),
      const TimeOfDay(hour: 14, minute: 0),
      const TimeOfDay(hour: 15, minute: 0),
      const TimeOfDay(hour: 16, minute: 0),
      const TimeOfDay(hour: 17, minute: 0),
      const TimeOfDay(hour: 18, minute: 0),
      const TimeOfDay(hour: 19, minute: 0),
      const TimeOfDay(hour: 20, minute: 0),
      const TimeOfDay(hour: 21, minute: 0),
    ];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _datePageController.dispose();
    super.dispose();
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  void _navigateToNextWeek() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 7));
    });
  }

  void _navigateToPreviousWeek() {
    final previousWeek = selectedDate.subtract(const Duration(days: 7));
    if (previousWeek
        .isAfter(DateTime.now().subtract(const Duration(days: 1)))) {
      setState(() {
        selectedDate = previousWeek;
      });
    }
  }

  void _updateTotalPrice() {
    final selectedCourtData = _getSelectedCourtData();
    if (selectedCourtData != null) {
      totalPrice = selectedTimeSlots.length * selectedCourtData.pricePerHour;
    } else {
      totalPrice = 0.0;
    }
  }

  CourtOption? _getSelectedCourtData() {
    if (selectedLocation == null || selectedCourt == null) return null;
    return courtsByLocation[selectedLocation!]
        ?.firstWhere((court) => court.name == selectedCourt);
  }

  void _toggleTimeSlot(DateTime date, TimeOfDay time) {
    final key =
        '${DateFormat('yyyy-MM-dd').format(date)}_${time.hour}:${time.minute}';
    setState(() {
      if (selectedTimeSlots.containsKey(key)) {
        selectedTimeSlots.remove(key);
      } else {
        selectedTimeSlots[key] = TimeSlot(date: date, time: time);
      }
      _updateTotalPrice();
    });
  }

  bool _isTimeSlotSelected(DateTime date, TimeOfDay time) {
    final key =
        '${DateFormat('yyyy-MM-dd').format(date)}_${time.hour}:${time.minute}';
    return selectedTimeSlots.containsKey(key);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            pinned: true,
            backgroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Select Court & Time',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Location Selection
                    _buildLocationSection(),
                    const SizedBox(height: 20),

                    // Court Selection (only show if location is selected)
                    if (selectedLocation != null) ...[
                      _buildCourtSection(),
                      const SizedBox(height: 20),
                    ],

                    // Date & Time Grid (only show if court is selected)
                    if (selectedCourt != null) ...[
                      _buildDateTimeGrid(),
                      const SizedBox(height: 30),
                    ],

                    // Total Price & Continue Button
                    if (selectedTimeSlots.isNotEmpty) ...[
                      _buildPriceSummary(),
                      const SizedBox(height: 20),
                      _buildContinueButton(),
                    ],

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.location_on,
                    color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 12),
              Text(
                'Choose Location',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.95, // Increased to give more height
            ),
            itemCount: locations.length,
            itemBuilder: (context, index) {
              return _buildLocationCard(locations[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(LocationOption location) {
    final isSelected = selectedLocation == location.name;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedLocation = location.name;
          selectedCourt = null; // Reset court selection
          selectedTimeSlots.clear(); // Reset time slots
          totalPrice = 0.0;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor.withOpacity(0.1)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Location Image
            Expanded(
              flex: 2,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: location.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.error),
                      ),
                    ),
                    // City badge
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          location.city,
                          style: GoogleFonts.poppins(
                            fontSize: 8,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Location Details
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row with icon, name, and check
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            location.icon,
                            color: Colors.white,
                            size: 12,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            location.name,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                            size: 14,
                          ),
                      ],
                    ),

                    // Address
                    Text(
                      location.address,
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),

                    // Distance
                    Text(
                      location.distance,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    final selectedCourtData = _getSelectedCourtData();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border:
            Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${selectedTimeSlots.length} jam dipilih',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Rp${NumberFormat('#,###', 'id_ID').format(selectedCourtData?.pricePerHour ?? 0)}/jam',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Rp${NumberFormat('#,###', 'id_ID').format(totalPrice)}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCourtSection() {
    final courts = courtsByLocation[selectedLocation] ?? [];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.sports, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 12),
              Text(
                'Select Court',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Column(
            children: courts.map((court) => _buildCourtCard(court)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtCard(CourtOption court) {
    final isSelected = selectedCourt == court.name;

    return GestureDetector(
      onTap: court.isAvailable
          ? () {
              setState(() {
                selectedCourt = court.name;
                selectedTimeSlots
                    .clear(); // Reset time slots when court changes
                totalPrice = 0.0;
              });
            }
          : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: !court.isAvailable
              ? Colors.grey[100]
              : isSelected
                  ? court.color.withOpacity(0.1)
                  : Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: !court.isAvailable
                ? Colors.grey[300]!
                : isSelected
                    ? court.color
                    : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            // Court Image
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: court.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                  if (!court.isAvailable)
                    Container(
                      height: 100,
                      width: double.infinity,
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: Text(
                          'TIDAK TERSEDIA',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  if (isSelected && court.isAvailable)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: court.color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // Court Details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: !court.isAvailable
                          ? Colors.grey[400]
                          : isSelected
                              ? court.color
                              : Colors.grey[400],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      court.icon,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          court.name,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: !court.isAvailable ? Colors.grey[500] : null,
                          ),
                        ),
                        Text(
                          court.sport,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        if (court.description.isNotEmpty)
                          Text(
                            court.description,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Rp${NumberFormat('#,###', 'id_ID').format(court.pricePerHour)}/jam',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: !court.isAvailable
                              ? Colors.grey[500]
                              : isSelected
                                  ? court.color
                                  : Colors.grey[700],
                        ),
                      ),
                      Text(
                        court.isAvailable ? 'Tersedia' : 'Tidak Tersedia',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: court.isAvailable ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeGrid() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:
                    Icon(Icons.schedule, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Select Date & Time',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Date picker button
              GestureDetector(
                onTap: _showDatePicker,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context).primaryColor.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat('MMM yyyy').format(selectedDate),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Select multiple time slots (each slot = 1 hour)',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),

          // Date navigation and headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Previous week button
              GestureDetector(
                onTap: selectedDate
                        .isAfter(DateTime.now().add(const Duration(days: 6)))
                    ? _navigateToPreviousWeek
                    : null,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: selectedDate.isAfter(
                            DateTime.now().add(const Duration(days: 6)))
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_left,
                    color: selectedDate.isAfter(
                            DateTime.now().add(const Duration(days: 6)))
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                  ),
                ),
              ),

              // Current week indicator
              Text(
                '${DateFormat('MMM d').format(visibleDates.first)} - ${DateFormat('MMM d').format(visibleDates.last)}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Next week button
              GestureDetector(
                onTap: _navigateToNextWeek,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              children: [
                // Date headers
                Row(
                  children: [
                    const SizedBox(width: 80), // Space for time labels
                    ...visibleDates.map((date) {
                      final isToday = DateFormat('yyyy-MM-dd').format(date) ==
                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                      final isPast = date.isBefore(
                          DateTime.now().subtract(const Duration(hours: 1)));

                      return Container(
                        width: 80,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          children: [
                            Text(
                              DateFormat('EEE').format(date),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: isPast
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isToday
                                    ? Theme.of(context).primaryColor
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                DateFormat('d').format(date),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isToday
                                      ? Colors.white
                                      : (isPast
                                          ? Colors.grey[400]
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
                const SizedBox(height: 8),
                // Time slots grid
                ...availableTimeSlots
                    .map((time) => Row(
                          children: [
                            // Time label
                            SizedBox(
                              width: 80,
                              child: Text(
                                time.format(context),
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            // Time slot buttons for each date
                            ...visibleDates
                                .map((date) => _buildTimeSlotButton(date, time))
                                .toList(),
                          ],
                        ))
                    .toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlotButton(DateTime date, TimeOfDay time) {
    final isSelected = _isTimeSlotSelected(date, time);
    final selectedCourtData = _getSelectedCourtData();

    // Check if this time slot is in the past
    final slotDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final isPast = slotDateTime.isBefore(DateTime.now());

    // Disable past time slots
    final isEnabled = !isPast;

    return GestureDetector(
      onTap: isEnabled ? () => _toggleTimeSlot(date, time) : null,
      child: Container(
        width: 80,
        height: 40,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: !isEnabled
              ? Colors.grey[200]
              : isSelected
                  ? selectedCourtData?.color ?? Theme.of(context).primaryColor
                  : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: !isEnabled
                ? Colors.grey[300]!
                : isSelected
                    ? selectedCourtData?.color ?? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
          ),
        ),
        child: Center(
          child: !isEnabled
              ? Icon(
                  Icons.block,
                  color: Colors.grey[400],
                  size: 16,
                )
              : isSelected
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    )
                  : Container(),
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: selectedTimeSlots.isNotEmpty
            ? () {
                // Navigate to event details page
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EventDetailsView(
                      selectedLocation: selectedLocation!,
                      selectedCourt: selectedCourt!,
                      selectedTimeSlots: selectedTimeSlots.values.toList(),
                      totalPrice: totalPrice,
                      courtData: _getSelectedCourtData()!,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.arrow_forward),
            const SizedBox(width: 12),
            Text(
              'Continue to Event Details',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Data models
class LocationOption {
  final String name;
  final String address;
  final String distance;
  final String city;
  final IconData icon;
  final String imageUrl;

  LocationOption({
    required this.name,
    required this.address,
    required this.distance,
    required this.city,
    required this.icon,
    required this.imageUrl,
  });
}

class CourtOption {
  final String name;
  final String sport;
  final double pricePerHour;
  final IconData icon;
  final Color color;
  final bool isAvailable;
  final String imageUrl;
  final String description;

  CourtOption({
    required this.name,
    required this.sport,
    required this.pricePerHour,
    required this.icon,
    required this.color,
    required this.isAvailable,
    required this.imageUrl,
    required this.description,
  });
}

class TimeSlot {
  final DateTime date;
  final TimeOfDay time;

  TimeSlot({
    required this.date,
    required this.time,
  });
}
