import 'package:flutter/material.dart';
import 'package:sample_app/ui/activity/activity_detail_view.dart';
import 'package:sample_app/ui/activity/past_activity_view.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/ui/activity/activity_view_model.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({super.key});

  static MaterialPage page() => const MaterialPage(
        name: AppLinkLocationKeys.bookings,
        key: ValueKey(AppLinkLocationKeys.bookings),
        child: ActivityView(),
      );

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  final TextEditingController _searchController = TextEditingController();
  String _roleFilter = 'All';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivityViewModel>.reactive(
      viewModelBuilder: () => ActivityViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        final searchText = _searchController.text.toLowerCase();

        // Filter only upcoming bookings
        final upcomingBookings = model.allBookings.where((booking) {
          final matchesSearch =
              booking.courtName.toLowerCase().contains(searchText) ||
                  booking.location.toLowerCase().contains(searchText) ||
                  booking.sportType.toLowerCase().contains(searchText);

          final matchesRole = _roleFilter == 'All' ||
              (_roleFilter == 'Host' && booking.isHost) ||
              (_roleFilter == 'Attendee' && !booking.isHost);

          return booking.startDateTime.isAfter(DateTime.now()) &&
              booking.status == BookingStatus.confirmed &&
              matchesSearch &&
              matchesRole;
        }).toList();

        // Count past bookings for the badge
        final pastBookingsCount = model.allBookings.where((booking) {
          return booking.startDateTime.isBefore(DateTime.now()) ||
              booking.status == BookingStatus.completed ||
              booking.status == BookingStatus.cancelled;
        }).length;

        return Scaffold(
          backgroundColor: Colors.grey[50],
          body: SafeArea(
            child: Column(
              children: [
                // Modern Header with Search and Past Bookings Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row with Title and Past Bookings Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'My Activities',
                            style: GoogleFonts.poppins(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => PastActivityView(
                                    bookings:
                                        model.allBookings.where((booking) {
                                      return booking.startDateTime
                                              .isBefore(DateTime.now()) ||
                                          booking.status ==
                                              BookingStatus.completed ||
                                          booking.status ==
                                              BookingStatus.cancelled;
                                    }).toList(),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .primaryColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.history,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Past',
                                    style: GoogleFonts.poppins(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search upcoming bookings...',
                            hintStyle:
                                GoogleFonts.poppins(color: Colors.grey[500]),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.grey[500]),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Role Filter Chips
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    children: [
                      Text(
                        "Filter by:",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterChip('All', _roleFilter == 'All',
                          Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Host', _roleFilter == 'Host', Colors.green),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Attendee', _roleFilter == 'Attendee', Colors.orange),
                    ],
                  ),
                ),
                // Content - Only Upcoming Bookings
                Expanded(
                  child: model.isBusy
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: () => model.refreshBookings(),
                          child: upcomingBookings.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: upcomingBookings.length,
                                  itemBuilder: (context, index) {
                                    final booking = upcomingBookings[index];
                                    return _buildModernBookingCard(
                                        context, booking, model);
                                  },
                                ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, Color color) {
    return GestureDetector(
      onTap: () => setState(() => _roleFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildModernBookingCard(
      BuildContext context, Booking booking, ActivityViewModel model) {
    final isUpcoming = booking.startDateTime.isAfter(DateTime.now());
    final isOneWeekBefore = booking.startDateTime
        .isAfter(DateTime.now().add(const Duration(days: 7)));

    Color statusColor = _getStatusColor(booking.status);
    String statusText = _getStatusText(booking.status);

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityDetailView(booking: booking),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
          children: [
            // Image Header
            Container(
              height: 140,
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(20)),
                image: DecorationImage(
                  image: NetworkImage(booking.courtImageUrl),
                  fit: BoxFit.cover,
                  onError: (error, stackTrace) {},
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Tap indicator
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                    // Event Type Badge
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: booking.isPublicEvent
                              ? Colors.purple
                              : Colors.indigo,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          booking.isPublicEvent ? 'Public' : 'Private',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Status Badge
                    Positioned(
                      top: 12,
                      right: 50,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    // Court Name
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 50,
                      child: Text(
                        booking.courtName,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Date & Time Row
                  Row(
                    children: [
                      Icon(Icons.calendar_today,
                          size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('EEE, MMM d').format(booking.startDateTime),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.access_time,
                          size: 18, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${DateFormat('h:mm a').format(booking.startDateTime)} - ${DateFormat('h:mm a').format(booking.endDateTime)}',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Sport & Role Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              _getSportIcon(booking.sportType),
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            booking.sportType,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: booking.isHost
                              ? Colors.green.withOpacity(0.1)
                              : Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          booking.isHost ? 'Host' : 'Member',
                          style: GoogleFonts.poppins(
                            color:
                                booking.isHost ? Colors.green : Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Location & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          booking.location,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Rp${NumberFormat('#,###', 'id_ID').format(booking.price)}',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  // Action Buttons
                  if (isUpcoming &&
                      booking.status != BookingStatus.cancelled) ...[
                    const SizedBox(height: 16),
                    _buildActionButtons(
                        booking, model, context, isOneWeekBefore),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons(Booking booking, ActivityViewModel model,
      BuildContext context, bool isOneWeekBefore) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    if (booking.isHost) {
      return Column(
        children: [
          if (isOneWeekBefore) ...[
            _buildActionButton(
              'Reschedule',
              Icons.edit_calendar,
              Theme.of(context).colorScheme.primary,
              () => model.showRescheduleDialog(context, booking),
              isFullWidth: true,
            ),
            const SizedBox(height: 8),
          ],
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  isSmallScreen ? 'Cancel' : 'Cancel',
                  Icons.close,
                  Colors.red,
                  () => model.showCancelDialog(context, booking),
                  isOutlined: true,
                  isCompact: isSmallScreen,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildActionButton(
                  isSmallScreen ? 'Invite' : 'Invite',
                  Icons.person_add,
                  Colors.green,
                  () => model.showInviteDialog(context, booking),
                  isOutlined: true,
                  isCompact: isSmallScreen,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: _buildActionButton(
              isSmallScreen ? 'Cancel' : 'Cancel',
              Icons.close,
              Colors.red,
              () => model.showCancelDialog(context, booking),
              isOutlined: true,
              isCompact: isSmallScreen,
            ),
          ),
          if (booking.isCoHost ?? false) ...[
            const SizedBox(width: 8),
            Expanded(
              child: _buildActionButton(
                isSmallScreen ? 'Invite' : 'Invite',
                Icons.person_add,
                Colors.green,
                () => model.showInviteDialog(context, booking),
                isOutlined: true,
                isCompact: isSmallScreen,
              ),
            ),
          ],
        ],
      );
    }
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed, {
    bool isOutlined = false,
    bool isFullWidth = false,
    bool isCompact = false,
  }) {
    return SizedBox(
      height: isCompact ? 36 : 40,
      width: isFullWidth ? double.infinity : null,
      child: isOutlined
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                foregroundColor: color,
                side: BorderSide(color: color),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 8 : 12,
                  vertical: isCompact ? 4 : 8,
                ),
              ),
              child: isCompact
                  ? Icon(icon, size: 16)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: isCompact ? 12 : 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 8 : 12,
                  vertical: isCompact ? 4 : 8,
                ),
              ),
              child: isCompact
                  ? Icon(icon, size: 16)
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            label,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: isCompact ? 12 : 13,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No upcoming bookings',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a court to get started',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              final viewModel = ActivityViewModel();
              viewModel.navigateToCreateBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
            ),
            child: Text(
              'Book Now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return Colors.green;
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.cancelled:
        return Colors.red;
      case BookingStatus.completed:
        return Colors.blue;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.cancelled:
        return 'Cancelled';
      case BookingStatus.completed:
        return 'Completed';
    }
  }

  IconData _getSportIcon(String sportType) {
    switch (sportType.toLowerCase()) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports;
      case 'futsal':
      case 'soccer':
        return Icons.sports_soccer;
      case 'volleyball':
        return Icons.sports_volleyball;
      case 'squash':
        return Icons.sports_tennis;
      default:
        return Icons.sports;
    }
  }
}
