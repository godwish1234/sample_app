abstract class BookingService {
  Future<List<dynamic>> getBookings();
  Future<bool> cancelBooking(String bookingId);
  Future<bool> rescheduleBooking(String bookingId, DateTime newStartTime, DateTime newEndTime);
}