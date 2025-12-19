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
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActivityViewModel>.reactive(
      viewModelBuilder: () => ActivityViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        // Filter all upcoming bookings
        final upcomingBookings = model.allBookings.where((booking) {
          return booking.startDateTime.isAfter(DateTime.now()) &&
              booking.status == BookingStatus.confirmed;
        }).toList();

        // Sort by date (closest first)
        upcomingBookings
            .sort((a, b) => a.startDateTime.compareTo(b.startDateTime));

        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 0,
            title: Text(
              'My Activities',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.history, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => PastActivityView(
                        bookings: model.allBookings.where((booking) {
                          return booking.startDateTime
                                  .isBefore(DateTime.now()) ||
                              booking.status == BookingStatus.completed ||
                              booking.status == BookingStatus.cancelled;
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () => model.refreshBookings(),
                  child: upcomingBookings.isEmpty
                      ? _buildEmptyState(
                          icon: Icons.event_busy,
                          title: 'No Upcoming Activities',
                          subtitle: 'Your booked activities will appear here',
                        )
                      : _buildGroupedActivitiesList(upcomingBookings, model),
                ),
        );
      },
    );
  }

  Widget _buildGroupedActivitiesList(
    List<Booking> bookings,
    ActivityViewModel model,
  ) {
    // Group bookings by date
    final Map<String, List<Booking>> groupedBookings = {};

    for (var booking in bookings) {
      final dateKey = DateFormat('yyyy-MM-dd').format(booking.startDateTime);
      if (!groupedBookings.containsKey(dateKey)) {
        groupedBookings[dateKey] = [];
      }
      groupedBookings[dateKey]!.add(booking);
    }

    // Sort the dates
    final sortedDates = groupedBookings.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: sortedDates.length,
      itemBuilder: (context, dateIndex) {
        final dateKey = sortedDates[dateIndex];
        final dateBookings = groupedBookings[dateKey]!;
        final date = DateTime.parse(dateKey);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateHeader(date),
            const SizedBox(height: 6),
            ...dateBookings.map((booking) {
              return _buildActivityCard(context, booking, model);
            }),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final targetDate = DateTime(date.year, date.month, date.day);

    String dateLabel;

    if (targetDate == today) {
      dateLabel = 'Today';
    } else if (targetDate == tomorrow) {
      dateLabel = 'Tomorrow';
    } else if (targetDate.difference(today).inDays < 7) {
      dateLabel = DateFormat('EEEE').format(date);
    } else {
      dateLabel = DateFormat('EEEE, MMM d').format(date);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        dateLabel,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildActivityCard(
    BuildContext context,
    Booking booking,
    ActivityViewModel model,
  ) {
    final daysUntil = booking.startDateTime.difference(DateTime.now()).inDays;
    final hoursUntil = booking.startDateTime.difference(DateTime.now()).inHours;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ActivityDetailView(booking: booking),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
        ),
        child: Stack(
          children: [
            Row(
              children: [
                // Left Side: Image
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.8),
                          Theme.of(context).colorScheme.primary,
                        ],
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          booking.courtImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.1),
                              child: Icon(
                                _getSportIcon(booking.sportType),
                                size: 48,
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.5),
                              ),
                            );
                          },
                        ),
                        // Time Until Badge Overlay
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: _getTimeUntilColor(daysUntil),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getTimeUntilText(daysUntil, hoursUntil),
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Right Side: Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Sport Badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    _getSportIcon(booking.sportType),
                                    size: 12,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    booking.sportType,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Court Name
                            Text(
                              booking.courtName,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            // Location
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 2),
                                Expanded(
                                  child: Text(
                                    booking.location,
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
                            const SizedBox(height: 6),
                            // Date & Time
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    size: 12, color: Colors.grey[500]),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    '${DateFormat('MMM d').format(booking.startDateTime)} • ${DateFormat('HH:mm').format(booking.startDateTime)}',
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
                        // Bottom: Event Type & Price
                        Row(
                          children: [
                            // Event Type Icon
                            Icon(
                              booking.isPublicEvent ? Icons.public : Icons.lock,
                              size: 12,
                              color: booking.isPublicEvent
                                  ? Colors.green
                                  : Colors.grey[600],
                            ),
                            const Spacer(),
                            // Price
                            Text(
                              'Rp ${NumberFormat('#,###', 'id_ID').format(booking.price)}',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Host Badge (overlay on top-right corner)
            if (booking.isHost)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.shade400,
                        Colors.orange.shade500,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(16),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stars,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Host',
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
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

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: Colors.grey[400]),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getSportIcon(String sportType) {
    switch (sportType.toLowerCase()) {
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports_tennis;
      case 'futsal':
      case 'football':
        return Icons.sports_soccer;
      case 'volleyball':
        return Icons.sports_volleyball;
      default:
        return Icons.sports;
    }
  }

  Color _getTimeUntilColor(int daysUntil) {
    if (daysUntil == 0) return Colors.red;
    if (daysUntil <= 2) return Colors.orange;
    return Colors.green;
  }

  String _getTimeUntilText(int daysUntil, int hoursUntil) {
    if (daysUntil == 0) {
      if (hoursUntil == 0) return 'Starting soon';
      return 'Today';
    } else if (daysUntil == 1) {
      return 'Tomorrow';
    } else {
      return 'In $daysUntil days';
    }
  }
}
