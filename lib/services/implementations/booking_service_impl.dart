import 'package:sample_app/services/interfaces/booking_service.dart';
import 'package:sample_app/ui/bookings/bookings_view_model.dart';

class BookingServiceImpl implements BookingService {
  @override
  Future<List<Booking>> getBookings() async {
    // Simulate fetching bookings from a database or API
    await Future.delayed(Duration(seconds: 1));

    // Sample data
    return [
      Booking(
        id: '1',
        courtName: 'Court A',
        courtImageUrl: 'https://example.com/court_a.jpg',
        location: 'Location A',
        startDateTime: DateTime.now().add(Duration(days: 1)),
        endDateTime: DateTime.now().add(Duration(days: 1, hours: 2)),
        sportType: 'Tennis',
        price: 20.0,
        status: BookingStatus.confirmed,
      ),
      Booking(
        id: '2',
        courtName: 'Court B',
        courtImageUrl: 'https://example.com/court_b.jpg',
        location: 'Location B',
        startDateTime: DateTime.now().subtract(Duration(days: 2)),
        endDateTime: DateTime.now().subtract(Duration(days: 2, hours: 2)),
        sportType: 'Badminton',
        price: 15.0,
        status: BookingStatus.completed,
      ),
    ];
  }

  Future<bool> cancelBooking(String bookingId) async {
    // Simulate cancelling a booking
    await Future.delayed(Duration(seconds: 1));
    return true; // Return true if cancellation was successful
  }

  Future<bool> rescheduleBooking(
      String bookingId, DateTime newStartTime, DateTime newEndTime) async {
    // Simulate rescheduling a booking
    await Future.delayed(Duration(seconds: 1));
    return true; // Return true if rescheduling was successful
  }
}
