import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';
import 'package:sample_app/ui/activities/activities_view_model.dart';

class BookingsView extends StatefulWidget {
  const BookingsView({super.key});

  static MaterialPage page() => const MaterialPage(
        name: AppLinkLocationKeys.bookings,
        key: ValueKey(AppLinkLocationKeys.bookings),
        child: BookingsView(),
      );

  @override
  State<BookingsView> createState() => _BookingsViewState();
}

class _BookingsViewState extends State<BookingsView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _roleFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BookingsViewModel>.reactive(
      viewModelBuilder: () => BookingsViewModel(),
      onViewModelReady: (model) => model.initialize(),
      builder: (context, model, child) {
        final searchText = _searchController.text.toLowerCase();
        final isUpcomingTab = _tabController.index == 0;
        final filtered = model.allBookings.where((booking) {
          final matchesSearch =
              booking.courtName.toLowerCase().contains(searchText) ||
                  booking.location.toLowerCase().contains(searchText) ||
                  booking.sportType.toLowerCase().contains(searchText);

          // Role filter logic
          final matchesRole = _roleFilter == 'All' ||
              (_roleFilter == 'Host' && booking.isHost) ||
              (_roleFilter == 'Attendee' && !booking.isHost);

          if (isUpcomingTab) {
            return booking.startDateTime.isAfter(DateTime.now()) &&
                booking.status == BookingStatus.confirmed &&
                matchesSearch &&
                matchesRole;
          } else {
            return (booking.startDateTime.isBefore(DateTime.now()) ||
                    booking.status == BookingStatus.completed ||
                    booking.status == BookingStatus.cancelled) &&
                matchesSearch &&
                matchesRole;
          }
        }).toList();

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'My Bookings',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              onTap: (_) => setState(() {}),
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
              ],
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
            ),
          ),
          body: model.isBusy
              ? const Center(child: CircularProgressIndicator())
              : SafeArea(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search bookings...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 16),
                          ),
                          textInputAction: TextInputAction.search,
                        ),
                      ),
                      // --- Role Filter Dropdown ---
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            Text(
                              "Role:",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 12),
                            ChoiceChip(
                              label: const Text('All'),
                              selected: _roleFilter == 'All',
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _roleFilter = 'All');
                              },
                              selectedColor: Theme.of(context).primaryColor,
                              labelStyle: TextStyle(
                                color: _roleFilter == 'All'
                                    ? Colors.white
                                    : Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.08),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Host'),
                              selected: _roleFilter == 'Host',
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _roleFilter = 'Host');
                              },
                              selectedColor: Colors.green,
                              labelStyle: TextStyle(
                                color: _roleFilter == 'Host'
                                    ? Colors.white
                                    : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: Colors.green.withOpacity(0.08),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Attendee'),
                              selected: _roleFilter == 'Attendee',
                              onSelected: (selected) {
                                if (selected)
                                  setState(() => _roleFilter = 'Attendee');
                              },
                              selectedColor: Colors.orange,
                              labelStyle: TextStyle(
                                color: _roleFilter == 'Attendee'
                                    ? Colors.white
                                    : Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                              backgroundColor: Colors.orange.withOpacity(0.08),
                            ),
                          ],
                        ),
                      ),
                      // --- End Role Filter ---
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: () => model.refreshBookings(),
                          child: filtered.isEmpty
                              ? _buildEmptyState(_tabController.index)
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: filtered.length,
                                  itemBuilder: (context, index) {
                                    final booking = filtered[index];
                                    return _buildBookingCard(
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

  Widget _buildEmptyState(int filterIndex) {
    String message;
    IconData icon;

    switch (filterIndex) {
      case 0:
        message = 'No upcoming bookings';
        icon = Icons.event_available;
        break;
      default:
        message = 'No past bookings yet';
        icon = Icons.history;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a court to get started',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              final viewModel = BookingsViewModel();
              viewModel.navigateToCreateBooking();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Book Now',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(
      BuildContext context, Booking booking, BookingsViewModel model) {
    final isUpcoming = booking.startDateTime.isAfter(DateTime.now());
    final isOneWeekBefore = booking.startDateTime
        .isAfter(DateTime.now().add(const Duration(days: 7)));

    Color statusColor;
    String statusText;

    switch (booking.status) {
      case BookingStatus.confirmed:
        statusColor = Colors.green;
        statusText = 'Confirmed';
        break;
      case BookingStatus.pending:
        statusColor = Colors.orange;
        statusText = 'Pending';
        break;
      case BookingStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'Cancelled';
        break;
      case BookingStatus.completed:
        statusColor = Colors.blue;
        statusText = 'Completed';
        break;
    }

    // Determine event type and user role
    String eventTypeLabel = '';
    Color eventTypeColor = Colors.blue;
    String roleLabel = '';
    Color roleColor = Colors.grey;

    if (booking.isPublicEvent) {
      eventTypeLabel = 'Public Event';
      eventTypeColor = Colors.deepPurple;
      if (booking.isHost) {
        roleLabel = 'Host';
        roleColor = Colors.green;
      } else {
        roleLabel = 'Member';
        roleColor = Colors.orange;
      }
    } else {
      eventTypeLabel = 'Private Event';
      eventTypeColor = Colors.indigo;
      if (booking.isHost) {
        roleLabel = 'Host';
        roleColor = Colors.green;
      } else {
        roleLabel = 'Member';
        roleColor = Colors.orange;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  booking.courtImageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 40),
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
                // Event type label
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: eventTypeColor.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      eventTypeLabel,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusText,
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 12,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, MMM d, yyyy')
                          .format(booking.startDateTime),
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    // Role label
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: roleColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        roleLabel,
                        style: GoogleFonts.poppins(
                          color: roleColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      '${DateFormat('h:mm a').format(booking.startDateTime)} - ${DateFormat('h:mm a').format(booking.endDateTime)}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.sports_basketball, size: 18),
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
                    Text(
                      '\$${booking.price.toStringAsFixed(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (isUpcoming && booking.status != BookingStatus.cancelled)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Row(
                      children: [
                        if (booking.isHost) ...[
                          // Host: Reschedule (if more than 1 week before), Cancel, Invite
                          if (isOneWeekBefore)
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => model.showRescheduleDialog(
                                    context, booking),
                                icon: const Icon(Icons.edit_calendar, size: 18),
                                label: Text(
                                  'Reschedule',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          if (isOneWeekBefore) const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  model.showCancelDialog(context, booking),
                              icon: const Icon(Icons.close, size: 18),
                              label: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  model.showInviteDialog(context, booking),
                              icon: const Icon(Icons.person_add, size: 18),
                              label: Text(
                                'Invite',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Theme.of(context).primaryColor,
                                side: BorderSide(
                                    color: Theme.of(context).primaryColor),
                              ),
                            ),
                          ),
                        ] else ...[
                          // Attendee: Cancel, Invite friends (if co-host)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () =>
                                  model.showCancelDialog(context, booking),
                              icon: const Icon(Icons.close, size: 18),
                              label: Text(
                                'Cancel',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (booking.isCoHost ?? false)
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () =>
                                    model.showInviteDialog(context, booking),
                                icon: const Icon(Icons.person_add, size: 18),
                                label: Text(
                                  'Invite Friends',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      Theme.of(context).primaryColor,
                                  side: BorderSide(
                                      color: Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
