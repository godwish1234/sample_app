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

class _EventDetailViewState extends State<EventDetailView> {
  late EventItem event;

  @override
  void initState() {
    super.initState();
    event = widget.event;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('E, MMM d • h:mm a');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          event.title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        children: [
          CachedNetworkImage(
            imageUrl: event.imageUrl,
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              height: 220,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              height: 220,
              child: const Icon(Icons.error),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      dateFormat.format(event.eventDate),
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      event.location,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  event.description,
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Icon(Icons.people, size: 18, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      '${event.attendees} attending',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
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
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: event.isAttending
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      event.isAttending ? 'Cancel Attendance' : 'Attend Event',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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