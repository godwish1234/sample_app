import 'dart:async';
import 'package:flutter/material.dart';
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
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> newsItems = [
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1511067007398-7e4b90cfa4bc',
      'title': 'City Championship Finals This Weekend',
      'location': 'Ariana Sports Center',
      'date': 'April 12-14, 2025'
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1526232761682-d26e03ac148e',
      'title': 'New Tennis Courts Opening Next Month',
      'location': 'Greenfield Park',
      'date': 'May 1, 2025'
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1613741616446-1fcdec4d1ba5',
      'title': 'Basketball League Registration Open',
      'location': 'Various Venues',
      'date': 'Registration ends April 30'
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1612872087720-bb876e2e67d1',
      'title': 'Pro Training Workshop by National Team',
      'location': 'Olympic Sports Hall',
      'date': 'April 15-16, 2025'
    },
    {
      'imageUrl':
          'https://images.unsplash.com/photo-1431324155629-1a6deb1dec8d',
      'title': 'Maintenance Schedule for Downtown Courts',
      'location': 'City Center Sports Complex',
      'date': 'April 20-25, 2025'
    },
  ];

  final List<Map<String, String>> reminders = [
    {
      'type': 'Event',
      'title': 'Your Tennis Booking',
      'subtitle': 'Tomorrow, 10:00 AM at Eastside Tennis Club',
      'icon': 'sports_tennis'
    },
    {
      'type': 'Payment',
      'title': 'Payment Due',
      'subtitle': 'Basketball Arena - \$30, pay before Apr 12',
      'icon': 'credit_card'
    },
    {
      'type': 'Competition',
      'title': 'Internal League Match',
      'subtitle': 'Apr 15, 7:00 PM at Olympic Sports Hall',
      'icon': 'emoji_events'
    },
  ];

  // Dummy competitions
  final List<Map<String, String>> competitions = [
    {
      'title': 'Internal Tennis Doubles',
      'date': 'Apr 20, 2025',
      'location': 'Greenfield Park',
      'status': 'Registration Open'
    },
    {
      'title': 'Basketball 3v3 Challenge',
      'date': 'Apr 25, 2025',
      'location': 'Downtown Arena',
      'status': 'Ongoing'
    },
    {
      'title': 'Badminton Friendly',
      'date': 'May 2, 2025',
      'location': 'Sunset Courts',
      'status': 'Upcoming'
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
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_currentPage < newsItems.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Row(
              children: [
                Icon(Icons.sports,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'CourtRental',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () {},
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                await vm.refreshData();
              },
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // News Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                      child: Text(
                        'Latest News',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 200,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (int page) {
                          setState(() {
                            _currentPage = page;
                          });
                        },
                        itemCount: newsItems.length,
                        itemBuilder: (context, index) {
                          return _buildNewsItem(newsItems[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: SmoothPageIndicator(
                          controller: _pageController,
                          count: newsItems.length,
                          effect: ExpandingDotsEffect(
                            dotHeight: 8,
                            dotWidth: 8,
                            activeDotColor:
                                Theme.of(context).colorScheme.primary,
                            dotColor: Colors.grey[300]!,
                          ),
                        ),
                      ),
                    ),
                    // Reminder Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Text(
                        'Reminders',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: reminders
                            .map((reminder) => _buildReminderCard(reminder))
                            .toList(),
                      ),
                    ),
                    // Competition Section
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                      child: Text(
                        'Internal Competitions',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: competitions
                            .map((comp) => _buildCompetitionCard(comp))
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNewsItem(Map<String, dynamic> news) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Image
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: news['imageUrl'],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
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
                    stops: const [0.6, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news['title'],
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news['location'],
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        color: Colors.white.withOpacity(0.9),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        news['date'],
                        style: GoogleFonts.poppins(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
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

  Widget _buildReminderCard(Map<String, String> reminder) {
    IconData icon;
    switch (reminder['icon']) {
      case 'sports_tennis':
        icon = Icons.sports_tennis;
        break;
      case 'credit_card':
        icon = Icons.credit_card;
        break;
      case 'emoji_events':
        icon = Icons.emoji_events;
        break;
      default:
        icon = Icons.notifications;
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(
          reminder['title'] ?? '',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          reminder['subtitle'] ?? '',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        trailing: reminder['type'] == 'Payment'
            ? Icon(Icons.warning, color: Colors.red)
            : null,
      ),
    );
  }

  Widget _buildCompetitionCard(Map<String, String> comp) {
    Color statusColor;
    switch (comp['status']) {
      case 'Registration Open':
        statusColor = Colors.green;
        break;
      case 'Ongoing':
        statusColor = Colors.orange;
        break;
      case 'Upcoming':
        statusColor = Theme.of(context).colorScheme.primary;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withOpacity(0.1),
          child: Icon(Icons.emoji_events, color: statusColor),
        ),
        title: Text(
          comp['title'] ?? '',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${comp['date']} • ${comp['location']}',
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            comp['status'] ?? '',
            style: GoogleFonts.poppins(
              color: statusColor,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}
