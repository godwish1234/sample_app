import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sample_app/ui/activity/activity_view_model.dart';

class ActivityDetailView extends StatefulWidget {
  final Booking booking;

  const ActivityDetailView({
    super.key,
    required this.booking,
  });

  @override
  State<ActivityDetailView> createState() => _ActivityDetailViewState();
}

class _ActivityDetailViewState extends State<ActivityDetailView>
    with TickerProviderStateMixin {
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;

  final List<BookingPlayer> players = [
    BookingPlayer(
      id: '1',
      name: 'John Doe',
      avatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d',
      isHost: true,
      joinedAt: DateTime.now().subtract(const Duration(days: 5)),
      skillLevel: 4.5,
    ),
    BookingPlayer(
      id: '2',
      name: 'Sarah Wilson',
      avatar: 'https://images.unsplash.com/photo-1494790108755-2616b612b786',
      isHost: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 3)),
      skillLevel: 4.0,
    ),
    BookingPlayer(
      id: '3',
      name: 'Mike Johnson',
      avatar: 'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e',
      isHost: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 2)),
      skillLevel: 3.5,
    ),
    BookingPlayer(
      id: '4',
      name: 'Emily Chen',
      avatar: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80',
      isHost: false,
      joinedAt: DateTime.now().subtract(const Duration(days: 1)),
      skillLevel: 4.2,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMM d, yyyy');
    final timeFormat = DateFormat('h:mm a');
    final isUpcoming = widget.booking.startDateTime.isAfter(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // Modern App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(Icons.share, color: Colors.black),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Hero Image
                  Positioned.fill(
                    child: Hero(
                      tag: 'booking_image_${widget.booking.id}',
                      child: CachedNetworkImage(
                        imageUrl: widget.booking.courtImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, size: 40),
                        ),
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
                            Colors.black.withOpacity(0.7),
                          ],
                          stops: const [0.6, 1.0],
                        ),
                      ),
                    ),
                  ),
                  // Status Badge
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.booking.status),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getStatusColor(widget.booking.status)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        _getStatusText(widget.booking.status),
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Role Badge
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: widget.booking.isHost
                            ? Colors.green
                            : Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (widget.booking.isHost
                                    ? Colors.green
                                    : Colors.orange)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        widget.booking.isHost ? 'Host' : 'Member',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Event Type
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.booking.courtName,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: widget.booking.isPublicEvent
                                ? Colors.purple.withOpacity(0.1)
                                : Colors.indigo.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.booking.isPublicEvent
                                ? 'Public Event'
                                : 'Private Event',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: widget.booking.isPublicEvent
                                  ? Colors.purple
                                  : Colors.indigo,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Info Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.calendar_today,
                            'Date',
                            dateFormat.format(widget.booking.startDateTime),
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.access_time,
                            'Time',
                            '${timeFormat.format(widget.booking.startDateTime)} - ${timeFormat.format(widget.booking.endDateTime)}',
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.sports_basketball,
                            'Sport',
                            widget.booking.sportType,
                            Colors.orange,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.attach_money,
                            'Price',
                            '\$${widget.booking.price.toStringAsFixed(2)}',
                            Colors.purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      Icons.location_on,
                      'Location',
                      widget.booking.location,
                      Colors.red,
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 32),
                    // Players Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Players (${players.length}/8)',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.booking.isHost && isUpcoming)
                          TextButton.icon(
                            onPressed: () {
                              // Show invite dialog
                            },
                            icon: const Icon(Icons.person_add, size: 16),
                            label: Text(
                              'Invite',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Players List
                    ...players
                        .map((player) => _buildPlayerCard(player))
                        .toList(),
                    const SizedBox(height: 24),
                    // Court Details Section
                    Text(
                      'Court Details',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildCourtDetailsCard(),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Action Button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: isUpcoming && widget.booking.status == BookingStatus.confirmed
              ? _buildActionFAB()
              : null,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, Color color,
      {bool isFullWidth = false}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: isFullWidth
          ? Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: color,
                        ),
                      ),
                      Text(
                        value,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
    );
  }

  Widget _buildPlayerCard(BookingPlayer player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: CachedNetworkImageProvider(player.avatar),
                onBackgroundImageError: (exception, stackTrace) {},
                child: player.avatar.isEmpty
                    ? Text(
                        player.name.substring(0, 1).toUpperCase(),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
              if (player.isHost)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      player.name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (player.isHost) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Host',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Skill Level Stars
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < player.skillLevel
                              ? Icons.star
                              : Icons.star_border,
                          size: 14,
                          color: index < player.skillLevel
                              ? Colors.amber
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${player.skillLevel.toStringAsFixed(1)})',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                Text(
                  'Joined ${DateFormat('MMM d').format(player.joinedAt)}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          // Action Button
          IconButton(
            onPressed: () {
              // Show player profile or message
            },
            icon: const Icon(Icons.message),
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourtDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Court Type', 'Indoor Basketball Court'),
          _buildDetailRow('Facilities', 'Locker rooms, Showers, Parking'),
          _buildDetailRow('Equipment', 'Provided (Balls, Nets)'),
          _buildDetailRow('Max Players', '8 players'),
          _buildDetailRow('Court Size', 'Full court (28m x 15m)'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFAB() {
    if (widget.booking.isHost) {
      return FloatingActionButton.extended(
        onPressed: () {
          _showHostActions();
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 8,
        icon: const Icon(Icons.settings, color: Colors.white),
        label: Text(
          'Manage Booking',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    } else {
      return FloatingActionButton.extended(
        onPressed: () {
          _showMemberActions();
        },
        backgroundColor: Colors.red,
        elevation: 8,
        icon: const Icon(Icons.exit_to_app, color: Colors.white),
        label: Text(
          'Leave Booking',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
    }
  }

  void _showHostActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Manage Booking',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            _buildActionTile('Reschedule', Icons.edit_calendar, () {}),
            _buildActionTile('Invite Players', Icons.person_add, () {}),
            _buildActionTile('Cancel Booking', Icons.cancel, () {},
                isDestructive: true),
          ],
        ),
      ),
    );
  }

  void _showMemberActions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Booking Actions',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            if (widget.booking.isCoHost ?? false)
              _buildActionTile('Invite Friends', Icons.person_add, () {}),
            _buildActionTile('Leave Booking', Icons.exit_to_app, () {},
                isDestructive: true),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDestructive ? Colors.red : Theme.of(context).primaryColor)
              .withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive
              ? Colors.red
              : Theme.of(context).colorScheme.primary,
        ),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : null,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
}

// Player data model
class BookingPlayer {
  final String id;
  final String name;
  final String avatar;
  final bool isHost;
  final DateTime joinedAt;
  final double skillLevel;

  BookingPlayer({
    required this.id,
    required this.name,
    required this.avatar,
    required this.isHost,
    required this.joinedAt,
    required this.skillLevel,
  });
}
