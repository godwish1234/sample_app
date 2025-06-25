import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sample_app/ui/community/event_view_model.dart';

class EventDetailView extends StatefulWidget {
  final EventItem event;
  final ValueChanged<EventItem> onAttendToggle;

  const EventDetailView({
    super.key,
    required this.event,
    required this.onAttendToggle,
  });

  @override
  State<EventDetailView> createState() => _EventDetailViewState();
}

class _EventDetailViewState extends State<EventDetailView>
    with TickerProviderStateMixin {
  late EventItem event;
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isImageExpanded = false;

  @override
  void initState() {
    super.initState();
    event = widget.event;
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
    final dateFormat = DateFormat('EEEE, MMM d');
    final timeFormat = DateFormat('h:mm a');
    final dayFormat = DateFormat('d');
    final monthFormat = DateFormat('MMM');

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
                    child: GestureDetector(
                      onTap: () =>
                          setState(() => _isImageExpanded = !_isImageExpanded),
                      child: Hero(
                        tag: 'event_image_${event.id}',
                        child: CachedNetworkImage(
                          imageUrl: event.imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.error, size: 40),
                          ),
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
                  // Sport Badge
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getSportColor(event.sportType),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: _getSportColor(event.sportType)
                                .withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        event.sportType,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  // Date Card
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            monthFormat.format(event.eventDate),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            dayFormat.format(event.eventDate),
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
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
                    // Title and Status
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (event.isAttending)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle,
                                    size: 16, color: Colors.green),
                                const SizedBox(width: 4),
                                Text(
                                  'Joined',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
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
                            Icons.access_time,
                            'Time',
                            timeFormat.format(event.eventDate),
                            Colors.blue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.people,
                            'Attendees',
                            '${event.attendees}',
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInfoCard(
                      Icons.location_on,
                      'Location',
                      event.location,
                      Colors.orange,
                      isFullWidth: true,
                    ),
                    const SizedBox(height: 24),
                    // Description Section
                    Text(
                      'About this event',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        event.description,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          height: 1.5,
                          color: Colors.grey[700],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Organizer Section (Mock)
                    Text(
                      'Organizer',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: Text(
                              'JD',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Doe',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Event Organizer',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.message),
                            style: IconButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              foregroundColor: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      // Modern Floating Action Button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                final isNowAttending = !event.isAttending;
                event = event.copyWith(
                  isAttending: isNowAttending,
                  attendees: isNowAttending
                      ? event.attendees + 1
                      : (event.attendees > 0 ? event.attendees - 1 : 0),
                );
              });
              widget.onAttendToggle(event);

              // Show feedback
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    event.isAttending
                        ? 'Joined event successfully!'
                        : 'Left event',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                  ),
                  backgroundColor:
                      event.isAttending ? Colors.green : Colors.orange,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            backgroundColor:
                event.isAttending ? Colors.red : Theme.of(context).primaryColor,
            elevation: 8,
            icon: Icon(
              event.isAttending ? Icons.close : Icons.add,
              color: Colors.white,
            ),
            label: Text(
              event.isAttending ? 'Leave Event' : 'Join Event',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
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
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
    );
  }

  Color _getSportColor(String sportType) {
    switch (sportType.toLowerCase()) {
      case 'basketball':
        return Colors.orange;
      case 'tennis':
        return Colors.green;
      case 'soccer':
        return Colors.blue;
      case 'volleyball':
        return Colors.purple;
      case 'badminton':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
