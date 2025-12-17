import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sample_app/ui/activity/new_activity/create_activity_view_model.dart';
import 'package:sample_app/ui/payment/payment.dart';

class ActivitySummaryView extends StatelessWidget {
  final String selectedLocation;
  final String selectedCourt;
  final List<TimeSlot> selectedTimeSlots;
  final double totalPrice;
  final CourtOption courtData;
  final bool isPublic;
  final String eventName;
  final int peopleLimit;
  final List<String> invitedPhones;

  const ActivitySummaryView({
    super.key,
    required this.selectedLocation,
    required this.selectedCourt,
    required this.selectedTimeSlots,
    required this.totalPrice,
    required this.courtData,
    required this.isPublic,
    required this.eventName,
    required this.peopleLimit,
    required this.invitedPhones,
  });

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
          'Booking Summary',
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
            // Event Overview Card
            _buildSummaryCard(
              title: 'Event Overview',
              icon: Icons.event,
              children: [
                _buildSummaryRow('Event Name', eventName),
                _buildSummaryRow(
                    'Type', isPublic ? 'Public Event' : 'Private Event'),
                if (isPublic)
                  _buildSummaryRow('People Limit', '$peopleLimit people'),
                if (invitedPhones.isNotEmpty)
                  _buildSummaryRow(
                      'Invited Friends', '${invitedPhones.length} contacts'),
              ],
            ),
            const SizedBox(height: 16),

            // Location & Court Card
            _buildSummaryCard(
              title: 'Location & Court',
              icon: Icons.location_on,
              children: [
                _buildSummaryRow('Location', selectedLocation),
                _buildSummaryRow('Court', selectedCourt),
                _buildSummaryRow('Sport', courtData.sport),
                _buildSummaryRow('Rate',
                    '\$${courtData.pricePerHour.toStringAsFixed(0)}/hour'),
              ],
            ),
            const SizedBox(height: 16),

            // Schedule Card
            _buildSummaryCard(
              title: 'Schedule',
              icon: Icons.schedule,
              children: [
                _buildSummaryRow(
                    'Duration', '${selectedTimeSlots.length} hour(s)'),
                const SizedBox(height: 8),
                ...selectedTimeSlots
                    .map((slot) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: courtData.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${DateFormat('EEE, MMM d').format(slot.date)} at ${slot.time.format(context)}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
            const SizedBox(height: 16),

            // Invited Contacts (if any)
            if (invitedPhones.isNotEmpty) ...[
              _buildSummaryCard(
                title: 'Invited Friends',
                icon: Icons.people,
                children: [
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
                              ),
                              child: Text(
                                phone,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],

            // Price Breakdown Card
            _buildPriceCard(),
            const SizedBox(height: 30),

            // Proceed to Payment Button
            Container(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PaymentPage(),
                    ),
                  );
                },
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
                    const Icon(Icons.payment),
                    const SizedBox(width: 12),
                    Text(
                      'Proceed to Payment',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(\$${totalPrice.toStringAsFixed(2)})',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
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

  Widget _buildSummaryCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: courtData.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, color: courtData.color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceCard() {
    final subtotal = selectedTimeSlots.length * courtData.pricePerHour;
    final tax = subtotal * 0.1; // 10% tax
    final total = subtotal + tax;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: courtData.color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: courtData.color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: courtData.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(Icons.receipt, color: courtData.color, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                'Price Breakdown',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPriceRow(
            '${selectedTimeSlots.length} hours × \$${courtData.pricePerHour.toStringAsFixed(0)}',
            '\$${subtotal.toStringAsFixed(2)}',
          ),
          _buildPriceRow('Tax (10%)', '\$${tax.toStringAsFixed(2)}'),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: courtData.color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
