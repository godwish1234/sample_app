import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sample_app/ui/activity/new_activity/activity_summary_view.dart';
import 'package:sample_app/ui/activity/new_activity/create_activity_view_model.dart';

class EventDetailsView extends StatefulWidget {
  final String selectedLocation;
  final String selectedCourt;
  final List<TimeSlot> selectedTimeSlots;
  final double totalPrice;
  final CourtOption courtData;

  const EventDetailsView({
    super.key,
    required this.selectedLocation,
    required this.selectedCourt,
    required this.selectedTimeSlots,
    required this.totalPrice,
    required this.courtData,
  });

  @override
  State<EventDetailsView> createState() => _EventDetailsViewState();
}

class _EventDetailsViewState extends State<EventDetailsView> {
  bool isPublic = true;
  String eventName = '';
  int peopleLimit = 10;
  List<String> invitedPhones = [];
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _inviteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _eventNameController.text = widget.selectedCourt;
    eventName = widget.selectedCourt;
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _inviteController.dispose();
    super.dispose();
  }

  Future<void> _pickContact() async {
    final status = await Permission.contacts.request();
    if (status.isGranted) {
      final contact = await ContactsService.openDeviceContactPicker();
      if (contact != null &&
          contact.phones != null &&
          contact.phones!.isNotEmpty) {
        final phone = contact.phones!.first.value ?? '';
        if (phone.isNotEmpty && !invitedPhones.contains(phone)) {
          setState(() {
            invitedPhones.add(phone);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Event Details',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Event Type Selection
            _buildModernCard(
              title: 'Event Type',
              icon: Icons.public,
              child: Row(
                children: [
                  Expanded(
                    child: _buildEventTypeChip(
                      'Public',
                      'Open to everyone',
                      Icons.public,
                      isPublic,
                      () => setState(() {
                        isPublic = true;
                        _eventNameController.text = widget.selectedCourt;
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildEventTypeChip(
                      'Private',
                      'Invite only',
                      Icons.lock,
                      !isPublic,
                      () => setState(() {
                        isPublic = false;
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Event Details
            _buildModernCard(
              title: 'Event Details',
              icon: Icons.edit,
              child: Column(
                children: [
                  // Event Name
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _eventNameController,
                      decoration: const InputDecoration(
                        hintText: 'Event Name',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        prefixIcon: Icon(Icons.event),
                      ),
                      onChanged: (val) => setState(() => eventName = val),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // People Limit (only for public events)
                  if (isPublic) ...[
                    Row(
                      children: [
                        Icon(Icons.people,
                            color: Theme.of(context).primaryColor),
                        const SizedBox(width: 12),
                        Text(
                          'People Limit',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$peopleLimit people',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 4,
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 8),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 16),
                      ),
                      child: Slider(
                        value: peopleLimit.toDouble(),
                        min: 2,
                        max: 50,
                        divisions: 48,
                        onChanged: (val) {
                          setState(() {
                            peopleLimit = val.round();
                          });
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                        inactiveColor:
                            Theme.of(context).primaryColor.withOpacity(0.2),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Invite Friends
            _buildModernCard(
              title: 'Invite Friends',
              icon: Icons.person_add,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _inviteController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintText: 'Enter phone number',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(16),
                              prefixIcon: Icon(Icons.phone),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: () {
                            final phone = _inviteController.text.trim();
                            if (phone.isNotEmpty &&
                                !invitedPhones.contains(phone)) {
                              setState(() {
                                invitedPhones.add(phone);
                                _inviteController.clear();
                              });
                            }
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          onPressed: _pickContact,
                          icon: Icon(Icons.contacts, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  if (invitedPhones.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: invitedPhones
                          .map((phone) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
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
                                    Text(
                                      phone,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          invitedPhones.remove(phone);
                                        });
                                      },
                                      child: Icon(
                                        Icons.close,
                                        size: 16,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Continue to Summary Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: eventName.isNotEmpty
                    ? () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ActivitySummaryView(
                              selectedLocation: widget.selectedLocation,
                              selectedCourt: widget.selectedCourt,
                              selectedTimeSlots: widget.selectedTimeSlots,
                              totalPrice: widget.totalPrice,
                              courtData: widget.courtData,
                              isPublic: isPublic,
                              eventName: eventName,
                              peopleLimit: peopleLimit,
                              invitedPhones: invitedPhones,
                            ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
                    const Icon(Icons.summarize),
                    const SizedBox(width: 12),
                    Text(
                      'Review Summary',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildModernCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
                child: Icon(icon, color: Theme.of(context).primaryColor),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildEventTypeChip(
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: isSelected ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
