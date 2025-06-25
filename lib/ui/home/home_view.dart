import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sample_app/ui/venue/venue_detail_view.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/ui/home/home_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  static MaterialPage page() => const MaterialPage(
        name: AppLinkLocationKeys.home,
        key: ValueKey(AppLinkLocationKeys.home),
        child: HomeView(),
      );

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final PageController _pageController = PageController(viewportFraction: 0.85);
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> newsItems = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1511067007398-7e4b90cfa4bc',
      'title': 'Jakarta Tennis Championship',
      'subtitle': 'This Weekend at Senayan',
      'category': 'Tournament',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1526232761682-d26e03ac148e',
      'title': 'New Badminton Courts',
      'subtitle': 'Opening at Kemayoran Sports Hall',
      'category': 'Facility',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1613741616446-1fcdec4d1ba5',
      'title': 'Futsal League Registration',
      'subtitle': 'Now Open - BSD Sports Arena',
      'category': 'Registration',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
      'title': 'Basketball Tournament',
      'subtitle': 'Pondok Indah Sports Center',
      'category': 'Competition',
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
      'title': 'Swimming Pool Renovation',
      'subtitle': 'Completed at Cengkareng Center',
      'category': 'Update',
    },
  ];

  final List<Map<String, dynamic>> quickActions = [
    {'icon': Icons.qr_code_scanner, 'label': 'Check In', 'color': Colors.blue},
    {'icon': Icons.emoji_events, 'label': 'Tournaments', 'color': Colors.green},
    {
      'icon': Icons.fitness_center,
      'label': 'Equipment',
      'color': Colors.orange
    },
    {'icon': Icons.local_cafe, 'label': 'Cafe Menu', 'color': Colors.brown},
  ];

  final List<Map<String, String>> reminders = [
    {
      'type': 'Event',
      'title': 'Badminton Match',
      'time': 'Tomorrow 2:00 PM - Senayan',
      'icon': 'sports_tennis'
    },
    {
      'type': 'Payment',
      'title': 'Court Booking Payment',
      'time': 'Rp 150,000 - Due Apr 12',
      'icon': 'credit_card'
    },
    {
      'type': 'Competition',
      'title': 'Jakarta Futsal League',
      'time': 'Apr 15, 7:00 PM - BSD Arena',
      'icon': 'emoji_events'
    },
    {
      'type': 'Event',
      'title': 'Tennis Coaching Session',
      'time': 'Apr 10, 10:00 AM - Pondok Indah',
      'icon': 'sports_tennis'
    },
    {
      'type': 'Reminder',
      'title': 'Equipment Return',
      'time': 'Racket rental due tomorrow',
      'icon': 'fitness_center'
    },
    {
      'type': 'Event',
      'title': 'Swimming Practice',
      'time': 'Every Tuesday 6:00 AM - Kemayoran',
      'icon': 'pool'
    },
  ];

  final List<Map<String, dynamic>> venues = [
    {
      'id': 'senayan',
      'name': 'Senayan Sports Complex',
      'address': 'Jl. Pintu Satu Senayan, Jakarta Pusat',
      'distance': '2.1 km',
      'rating': 4.8,
      'reviewCount': 156,
      'imageUrl':
          'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
      'priceRange': 'Rp 120,000 - 200,000',
      'category': 'Premium',
      'features': ['Basketball', 'Tennis', 'Volleyball'],
      'openHours': '06:00 - 22:00',
      'description':
          'Premier sports complex in the heart of Jakarta with world-class facilities and professional courts.',
      'images': [
        'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b',
        'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
      ],
      'reviews': [
        {
          'name': 'Ahmad Rizki',
          'rating': 5,
          'comment':
              'Excellent facilities and well-maintained courts. Staff is very professional.',
          'date': '2 days ago'
        },
        {
          'name': 'Sarah Putri',
          'rating': 4,
          'comment': 'Great location but can get crowded during peak hours.',
          'date': '1 week ago'
        },
      ]
    },
    {
      'id': 'pondok_indah',
      'name': 'Pondok Indah Sports Center',
      'address': 'Jl. Metro Pondok Indah, Jakarta Selatan',
      'distance': '5.3 km',
      'rating': 4.6,
      'reviewCount': 89,
      'imageUrl': 'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
      'priceRange': 'Rp 80,000 - 250,000',
      'category': 'Premium',
      'features': ['Tennis', 'Badminton', 'Squash'],
      'openHours': '06:00 - 23:00',
      'description':
          'Upscale sports center with premium courts and modern amenities in South Jakarta.',
      'images': [
        'https://images.unsplash.com/photo-1544965503-7ad531123fcf',
        'https://images.unsplash.com/photo-1622279457486-62dcc4a431d6',
        'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
      ],
      'reviews': [
        {
          'name': 'Budi Santoso',
          'rating': 5,
          'comment':
              'Top-notch tennis courts with excellent lighting for night games.',
          'date': '3 days ago'
        },
        {
          'name': 'Lisa Chen',
          'rating': 4,
          'comment':
              'Clean facilities and friendly staff. Parking can be limited.',
          'date': '5 days ago'
        },
      ]
    },
    {
      'id': 'kemayoran',
      'name': 'Kemayoran Sports Hall',
      'address': 'Jl. Benyamin Sueb, Jakarta Utara',
      'distance': '3.8 km',
      'rating': 4.4,
      'reviewCount': 67,
      'imageUrl':
          'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
      'priceRange': 'Rp 80,000 - 200,000',
      'category': 'Standard',
      'features': ['Basketball', 'Futsal', 'Badminton'],
      'openHours': '06:00 - 22:00',
      'description':
          'Modern indoor sports hall with multiple courts and good ventilation system.',
      'images': [
        'https://images.unsplash.com/photo-1574629810360-7efbbe195018',
        'https://images.unsplash.com/photo-1546519638-68e109498ffc',
        'https://images.unsplash.com/photo-1578662996442-48f60103fc96',
      ],
      'reviews': [
        {
          'name': 'Andi Pratama',
          'rating': 4,
          'comment': 'Good value for money. Courts are well-maintained.',
          'date': '1 week ago'
        },
        {
          'name': 'Maya Sari',
          'rating': 4,
          'comment': 'Great for futsal games. Easy booking process.',
          'date': '2 weeks ago'
        },
      ]
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_currentPage < newsItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (vm) => vm.initialize(),
      builder: (context, vm, child) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => await vm.refreshData(),
              child: CustomScrollView(
                slivers: [
                  // 1. Simple Sticky App Bar - Just greeting and notification
                  SliverAppBar(
                    expandedHeight: 100,
                    pinned: true,
                    backgroundColor: Theme.of(context).primaryColor,
                    elevation: 0,
                    automaticallyImplyLeading: false,
                    flexibleSpace: FlexibleSpaceBar(
                      titlePadding: const EdgeInsets.only(
                          left: 20, bottom: 12, right: 20),
                      title: SizedBox(
                        height: 50,
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Selamat Pagi! 👋',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.white.withOpacity(0.8),
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Ready to play?',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      height: 1.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.notifications_none,
                                    color: Colors.white),
                                onPressed: () {},
                                iconSize: 18,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 2. Compact Reminders - Right after greeting
                  SliverToBoxAdapter(
                    child: _buildCompactRemindersSection(),
                  ),

                  // 3. What's New Section Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                      child: Text(
                        'What\'s New',
                        style: GoogleFonts.poppins(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  // 4. News Section
                  SliverToBoxAdapter(
                    child: Container(
                      height: 180,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemCount: newsItems.length,
                        itemBuilder: (context, index) {
                          return _buildNewsCard(
                              newsItems[index], index == _currentPage);
                        },
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: newsItems.length,
                        effect: WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Theme.of(context).colorScheme.primary,
                          dotColor: Colors.grey[300]!,
                        ),
                      ),
                    ),
                  ),

                  // 5. Quick Actions
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Quick Actions',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: quickActions.map((action) {
                              return Expanded(
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 10,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: (action['color'] as Color)
                                              .withOpacity(0.1),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          action['icon'] as IconData,
                                          color: action['color'] as Color,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        action['label'] as String,
                                        style: GoogleFonts.poppins(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 6. Popular Venues Section
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Popular Venues',
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to all venues page
                            },
                            child: Text(
                              'View All',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Container(
                      height: 300,
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: venues.length,
                        itemBuilder: (context, index) {
                          return _buildVenueCard(venues[index]);
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 100)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCompactRemindersSection() {
    // Filter only urgent reminders (next 2-3 items)
    final urgentReminders = reminders
        .where((reminder) {
          return reminder['type'] == 'Payment' ||
              reminder['type'] == 'Event' &&
                  (reminder['time']?.contains('Tomorrow') ?? false);
        })
        .take(2)
        .toList();

    if (urgentReminders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Colors.orange,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Reminders',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.orange[800],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Navigate to full reminders page
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Reminder Items
          Column(
            children: urgentReminders.map((reminder) {
              return _buildMiniReminderItem(reminder);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniReminderItem(Map<String, String> reminder) {
    IconData icon;
    Color iconColor;
    switch (reminder['icon']) {
      case 'sports_tennis':
        icon = Icons.sports_tennis;
        iconColor = Colors.blue;
        break;
      case 'credit_card':
        icon = Icons.credit_card;
        iconColor = Colors.red;
        break;
      case 'emoji_events':
        icon = Icons.emoji_events;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['title'] ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  reminder['time'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          if (reminder['type'] == 'Payment')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Due',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              // Dismiss reminder
            },
            child: Icon(
              Icons.close,
              size: 16,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueCard(Map<String, dynamic> venue) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => VenueDetailView(venue: venue),
          ),
        );
      },
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(right: 16),
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
            // Venue Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: venue['imageUrl'],
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
                    // Category Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: venue['category'] == 'Premium'
                              ? Colors.orange
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          venue['category'],
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Rating Badge
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              venue['rating'].toString(),
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Venue Details
            Container(
              height: 110, // Fixed height to prevent overflow
              padding: const EdgeInsets.all(12), // Reduced padding
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title and location
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        venue['name'],
                        style: GoogleFonts.poppins(
                          fontSize: 13, // Slightly smaller
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2), // Reduced spacing
                      Row(
                        children: [
                          Icon(Icons.location_on,
                              size: 11, color: Colors.grey[600]),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              venue['distance'],
                              style: GoogleFonts.poppins(
                                fontSize: 10, // Smaller font
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Sports Tags
                  SizedBox(
                    height: 20, // Fixed height for tags
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            (venue['features'] as List).take(2).map((feature) {
                          return Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              feature,
                              style: GoogleFonts.poppins(
                                fontSize: 8,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  // Price
                  Text(
                    venue['priceRange'],
                    style: GoogleFonts.poppins(
                      fontSize: 11, // Smaller font
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(
        horizontal: isActive ? 8 : 12,
        vertical: isActive ? 0 : 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isActive ? 0.15 : 0.08),
            blurRadius: isActive ? 20 : 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: news['imageUrl'],
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
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  news['category'],
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    news['subtitle'],
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactReminderCard(Map<String, String> reminder) {
    IconData icon;
    Color iconColor;
    switch (reminder['icon']) {
      case 'sports_tennis':
        icon = Icons.sports_tennis;
        iconColor = Colors.blue;
        break;
      case 'credit_card':
        icon = Icons.credit_card;
        iconColor = Colors.red;
        break;
      case 'emoji_events':
        icon = Icons.emoji_events;
        iconColor = Colors.orange;
        break;
      case 'fitness_center':
        icon = Icons.fitness_center;
        iconColor = Colors.green;
        break;
      case 'pool':
        icon = Icons.pool;
        iconColor = Colors.cyan;
        break;
      default:
        icon = Icons.notifications;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder['title'] ?? '',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  reminder['time'] ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          if (reminder['type'] == 'Payment')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Due',
                style: GoogleFonts.poppins(
                  color: Colors.red,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
