import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sample_app/ui/activity/new_activity/create_activity_view.dart';
import 'package:sample_app/ui/home/find_game/find_game_view.dart';
import 'package:sample_app/ui/notifications/notification_view.dart';
import 'package:sample_app/ui/chat/chat_view.dart';
import 'package:stacked/stacked.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/ui/home/home_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

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
  Timer? _autoSlideTimer;

  @override
  void initState() {
    super.initState();
    // TODO: Re-implement auto-slide with ViewModel
    // _startAutoSlide();
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  // TODO: Re-implement auto-slide to work with ViewModel newsItems
  // void _startAutoSlide() {
  //   _autoSlideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
  //     if (_currentPage < vm.newsItems.length - 1) {
  //       _currentPage++;
  //     } else {
  //       _currentPage = 0;
  //     }
  //
  //     if (_pageController.hasClients) {
  //       _pageController.animateToPage(
  //         _currentPage,
  //         duration: const Duration(milliseconds: 600),
  //         curve: Curves.easeInOut,
  //       );
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(),
      onViewModelReady: (vm) => vm.initialize(),
      builder: (context, vm, child) {
        // Show loading state
        if (vm.isLoading && vm.newsItems.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        // Show error state
        if (vm.errorMessage != null && vm.newsItems.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline,
                        color: Theme.of(context).colorScheme.error, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      vm.errorMessage!,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: vm.initialize,
                      child: const Text('Retry'),
                    )
                  ],
                ),
              ),
            ),
          );
        }

        // Main content
        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: CustomScrollView(
            slivers: [
              // Header with Background
              SliverToBoxAdapter(
                child: Stack(
                  children: [
                    // Sports Background Image
                    Container(
                      height: 300,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/bg.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.5),
                              Colors.black.withOpacity(0.3),
                              Colors.black.withOpacity(0.1),
                              Colors.grey[50]!.withOpacity(0.3),
                              Colors.grey[50]!,
                            ],
                            stops: const [0.0, 0.4, 0.7, 0.9, 1.0],
                          ),
                        ),
                      ),
                    ),
                    // Header Content
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Hello, ${vm.user?.displayName ?? 'Guest'}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(Icons.location_on,
                                              size: 16, color: Colors.white70),
                                          const SizedBox(width: 6),
                                          Text(
                                            'Central Jakarta',
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          const Icon(Icons.keyboard_arrow_down,
                                              size: 18, color: Colors.white),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                _buildHeaderIconButton(
                                  Icons.notifications_outlined,
                                  badgeCount: 1,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const NotificationView(),
                                      ),
                                    );
                                  },
                                  isDark: true,
                                ),
                                const SizedBox(width: 10),
                                _buildHeaderIconButton(
                                  Icons.chat_bubble_outline,
                                  badgeCount: 1,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ChatView(),
                                      ),
                                    );
                                  },
                                  isDark: true,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (vm.user != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    // Left side - Membership info
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Icon(Icons.workspace_premium,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              size: 18),
                                          const SizedBox(width: 10),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Sporta Super',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black87)),
                                              Text('Membership >',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Center divider
                                    Container(
                                        width: 1,
                                        height: 32,
                                        color: const Color.fromRGBO(
                                            224, 224, 224, 1)),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(Icons.add_circle_outline,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 16),
                                                  const SizedBox(width: 6),
                                                  Text('500.000',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: Colors
                                                                  .black87)),
                                                ],
                                              ),
                                              Text('Sporta Points',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 11,
                                                      color: Colors.grey[600])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 20,
                      right: 20,
                      child: _buildModernQuickActions(context, vm),
                    ),
                  ],
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 20),
              ),

              // Urgent Reminders
              if (vm.urgentReminders.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildCompactRemindersCard(context, vm),
                ),

              // What's New Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    children: [
                      Icon(Icons.auto_awesome,
                          color: Colors.amber[700], size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'What\'s New',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // News Cards
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: vm.newsItems.length,
                    itemBuilder: (context, index) {
                      return _buildModernNewsCard(context, vm.newsItems[index]);
                    },
                  ),
                ),
              ),

              // Popular Venues Section
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Venues',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Venues List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 240,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: vm.venues.length,
                    itemBuilder: (context, index) {
                      return _buildModernVenueCard(context, vm.venues[index]);
                    },
                  ),
                ),
              ),

              // Bottom Spacing
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompactRemindersCard(BuildContext context, HomeViewModel vm) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Reminder Items
          ...vm.urgentReminders.asMap().entries.map((entry) {
            final index = entry.key;
            final reminder = entry.value;
            final isLast =
                index == vm.urgentReminders.length - 1 && !vm.hasMoreReminders;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: isLast
                      ? BorderSide.none
                      : BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Date Indicator Box (smaller)
                  _buildDateIndicator(reminder.dueDate),
                  const SizedBox(width: 12),
                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reminder.title,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 12, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                reminder.time,
                                style: GoogleFonts.poppins(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Time Until Badge
                  _buildTimeUntilBadge(reminder.dueDate, reminder.type),
                ],
              ),
            );
          }),
          // See All Button
          if (vm.hasMoreReminders)
            InkWell(
              onTap: () {
                // TODO: Navigate to full reminders page
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Showing ${vm.reminders.length} total reminders',
                      style: GoogleFonts.poppins(),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200, width: 1),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'See All Reminders',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 12,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateIndicator(DateTime dueDate) {
    final now = DateTime.now();
    final isToday = dueDate.year == now.year &&
        dueDate.month == now.month &&
        dueDate.day == now.day;
    final isTomorrow =
        dueDate.difference(now).inDays == 0 && dueDate.day == now.day + 1;

    Color bgColor;
    Color textColor;
    if (isToday || dueDate.isBefore(now.add(const Duration(hours: 24)))) {
      bgColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
    } else if (isTomorrow ||
        dueDate.isBefore(now.add(const Duration(days: 2)))) {
      bgColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
    } else {
      bgColor = Colors.blue[50]!;
      textColor = Colors.blue[700]!;
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            DateFormat('d').format(dueDate),
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: textColor,
              height: 1,
            ),
          ),
          const SizedBox(height: 1),
          Text(
            DateFormat('MMM').format(dueDate).toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 8,
              fontWeight: FontWeight.w600,
              color: textColor.withOpacity(0.8),
              letterSpacing: 0.5,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUntilBadge(DateTime dueDate, String type) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    String timeText;
    Color bgColor;
    Color textColor;

    if (difference.isNegative) {
      timeText = 'Overdue';
      bgColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      timeText = hours == 0 ? 'Soon' : '${hours}h';
      bgColor = Colors.red[50]!;
      textColor = Colors.red[700]!;
    } else if (difference.inDays == 1) {
      timeText = 'Tomorrow';
      bgColor = Colors.orange[50]!;
      textColor = Colors.orange[700]!;
    } else if (difference.inDays < 7) {
      timeText = '${difference.inDays}d';
      bgColor = Colors.blue[50]!;
      textColor = Colors.blue[700]!;
    } else {
      timeText = DateFormat('MMM d').format(dueDate);
      bgColor = Colors.grey[100]!;
      textColor = Colors.grey[700]!;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textColor.withOpacity(0.2), width: 1),
      ),
      child: Text(
        timeText,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  Widget _buildModernNewsCard(BuildContext context, NewsItem news) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12, left: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                imageUrl: news.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            // Gradient Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Category Badge
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  news.category,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            // Content
            Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    news.subtitle,
                    style: GoogleFonts.poppins(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
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

  Widget _buildModernVenueCard(BuildContext context, Venue venue) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 12, left: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: venue.imageUrl,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 140,
                    color: Colors.grey[300],
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 140,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  ),
                ),
                // Rating Badge
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          venue.rating.toString(),
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 11,
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
          // Details
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  venue.name,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        venue.distance,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  venue.priceRange,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon,
      {int badgeCount = 0, VoidCallback? onTap, bool isDark = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.2) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon,
                size: 22, color: isDark ? Colors.white : Colors.grey[700]),
          ),
          if (badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    badgeCount.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildModernQuickActions(BuildContext context, HomeViewModel vm) {
    final primaryActions =
        vm.quickActions.where((action) => action.isPrimary).toList();
    final secondaryActions =
        vm.quickActions.where((action) => !action.isPrimary).toList();

    return Column(
      children: [
        // Primary Actions - Large buttons
        Row(
          children: [
            for (int i = 0; i < primaryActions.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(
                child: _buildPrimaryActionButton(
                  context,
                  primaryActions[i],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        // Secondary Actions - Smaller buttons
        Row(
          children: [
            for (int i = 0; i < secondaryActions.length; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: _buildSecondaryActionButton(
                  context,
                  secondaryActions[i],
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildPrimaryActionButton(BuildContext context, QuickAction action) {
    return GestureDetector(
      onTap: action.available
          ? () {
              _handleActionTap(context, action);
            }
          : null,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: action.available
                ? [
                    action.color,
                    action.color.withOpacity(0.8),
                  ]
                : [
                    Colors.grey[300]!,
                    Colors.grey[400]!,
                  ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: action.available
                  ? action.color.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      action.icon,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: Text(
                      action.label,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Coming Soon Badge
            if (!action.available)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'Coming Soon',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionButton(BuildContext context, QuickAction action) {
    return GestureDetector(
      onTap: action.available
          ? () {
              _handleActionTap(context, action);
            }
          : null,
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: action.available
                ? action.color.withOpacity(0.2)
                : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: action.available
                          ? action.color.withOpacity(0.1)
                          : Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      action.icon,
                      color: action.available ? action.color : Colors.grey[500],
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Flexible(
                    child: Text(
                      action.label,
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: action.available
                            ? Colors.black87
                            : Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Coming Soon Badge
            if (!action.available)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange[400]!,
                        Colors.deepOrange[500]!,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Soon',
                    style: GoogleFonts.poppins(
                      fontSize: 7,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _handleActionTap(BuildContext context, QuickAction action) {
    switch (action.id) {
      case 'new_booking':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateActivityView(),
          ),
        );
        break;
      case 'find_game':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FindGameView(),
          ),
        );
        break;
    }
  }
}
