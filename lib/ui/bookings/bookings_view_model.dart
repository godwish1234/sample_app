import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:get_it/get_it.dart';
import 'package:sample_app/services/interfaces/booking_service.dart';
import 'package:sample_app/services/interfaces/navigation_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sample_app/routing/app_link_location_keys.dart';

// Enum for booking status
enum BookingStatus { confirmed, pending, cancelled, completed }

// Booking data model
class Booking {
  final String id;
  final String courtName;
  final String courtImageUrl;
  final String location;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String sportType;
  final double price;
  final BookingStatus status;

  Booking({
    required this.id,
    required this.courtName,
    required this.courtImageUrl,
    required this.location,
    required this.startDateTime,
    required this.endDateTime,
    required this.sportType,
    required this.price,
    required this.status,
  });
}

class BookingsViewModel extends BaseViewModel {
  final _bookingService = GetIt.instance<BookingService>();
  final _navigationService = GetIt.instance<NavigationService>();

  List<Booking> _allBookings = [];
  List<Booking> get allBookings => _allBookings;

  List<Booking> get filteredBookings {
    switch (_currentFilterIndex) {
      case 0:
        return _allBookings
            .where((booking) =>
                booking.startDateTime.isAfter(DateTime.now()) &&
                booking.status != BookingStatus.cancelled)
            .toList();
      case 1:
        return _allBookings
            .where((booking) =>
                booking.startDateTime.isBefore(DateTime.now()) ||
                booking.status == BookingStatus.completed)
            .toList();
      case 2:
      default:
        return _allBookings;
    }
  }

  int _currentFilterIndex = 0;
  int get currentFilterIndex => _currentFilterIndex;

  void setFilterIndex(int index) {
    _currentFilterIndex = index;
    notifyListeners();
  }

  Future<void> initialize() async {
    await fetchBookings();
  }

  Future<void> fetchBookings() async {
    setBusy(true);
    try {
      _allBookings = _getSampleBookings();

      _allBookings.sort((a, b) => b.startDateTime.compareTo(a.startDateTime));
    } catch (e) {
      // Handle error
      debugPrint('Error fetching bookings: $e');
    } finally {
      setBusy(false);
    }
  }

  Future<void> refreshBookings() async {
    return fetchBookings();
  }

  void navigateToCreateBooking() {
    _navigationService.navigateTo(AppLinkLocationKeys.createBooking);
  }

  Future<void> showCancelDialog(BuildContext context, Booking booking) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Cancel Booking',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to cancel your booking at ${booking.courtName}?',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 12),
            Text(
              'Date: ${DateFormat('EEE, MMM d, yyyy').format(booking.startDateTime)}',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            Text(
              'Time: ${DateFormat('h:mm a').format(booking.startDateTime)} - ${DateFormat('h:mm a').format(booking.endDateTime)}',
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No, Keep It',
              style: GoogleFonts.poppins(),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Yes, Cancel',
              style: GoogleFonts.poppins(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (result == true) {
      await cancelBooking(booking.id);
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    setBusy(true);
    try {
      await Future.delayed(const Duration(seconds: 1));

      final index = _allBookings.indexWhere((b) => b.id == bookingId);
      if (index >= 0) {
        final booking = _allBookings[index];
        _allBookings[index] = Booking(
          id: booking.id,
          courtName: booking.courtName,
          courtImageUrl: booking.courtImageUrl,
          location: booking.location,
          startDateTime: booking.startDateTime,
          endDateTime: booking.endDateTime,
          sportType: booking.sportType,
          price: booking.price,
          status: BookingStatus.cancelled,
        );
      }
    } catch (e) {
      debugPrint('Error cancelling booking: $e');
    } finally {
      setBusy(false);
      notifyListeners();
    }
  }

  Future<void> showRescheduleDialog(
      BuildContext context, Booking booking) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Reschedule functionality would open a date/time picker'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  List<Booking> _getSampleBookings() {
    final now = DateTime.now();

    return [
      Booking(
        id: '1',
        courtName: 'Downtown Basketball Court',
        courtImageUrl:
            'https://images.unsplash.com/photo-1619468129361-605ebea04b44',
        location: 'Downtown Sports Center',
        startDateTime: now.add(const Duration(days: 2, hours: 3)),
        endDateTime: now.add(const Duration(days: 2, hours: 4)),
        sportType: 'Basketball',
        price: 35.00,
        status: BookingStatus.confirmed,
      ),
      Booking(
        id: '2',
        courtName: 'Westside Tennis Club',
        courtImageUrl:
            'https://images.unsplash.com/photo-1562552476-8ac59b2a2e46',
        location: 'Westside Recreation Area',
        startDateTime: now.subtract(const Duration(days: 3)),
        endDateTime:
            now.subtract(const Duration(days: 3)).add(const Duration(hours: 2)),
        sportType: 'Tennis',
        price: 45.00,
        status: BookingStatus.completed,
      ),
      Booking(
        id: '3',
        courtName: 'Greenfield Badminton Courts',
        courtImageUrl:
            'https://images.unsplash.com/photo-1536122985607-4fe00b283652',
        location: 'Greenfield Community Center',
        startDateTime: now.add(const Duration(days: 1)),
        endDateTime: now.add(const Duration(days: 1, hours: 1, minutes: 30)),
        sportType: 'Badminton',
        price: 25.00,
        status: BookingStatus.pending,
      ),
      Booking(
        id: '4',
        courtName: 'Lakeside Soccer Field',
        courtImageUrl:
            'https://images.unsplash.com/photo-1486882430381-e76d701e0a3e',
        location: 'Lakeside Park',
        startDateTime: now.subtract(const Duration(days: 10)),
        endDateTime: now
            .subtract(const Duration(days: 10))
            .add(const Duration(hours: 2)),
        sportType: 'Soccer',
        price: 60.00,
        status: BookingStatus.cancelled,
      ),
      Booking(
        id: '5',
        courtName: 'Sunset Volleyball Courts',
        courtImageUrl:
            'https://images.unsplash.com/photo-1619468129361-605ebea04b44',
        location: 'Sunset Beach',
        startDateTime: now.add(const Duration(days: 5)),
        endDateTime: now.add(const Duration(days: 5, hours: 2)),
        sportType: 'Volleyball',
        price: 30.00,
        status: BookingStatus.confirmed,
      ),
    ];
  }
}
