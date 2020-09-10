import 'package:Sublin/models/booking_class.dart';

class BookingCompleted extends Booking {
  Booking completed;
  BookingCompleted({this.completed}) : super();

  factory BookingCompleted.fromJson(Map data, String documentId) {
    data = data ?? {};
    BookingCompleted bookingCompleted =
        BookingCompleted(completed: Booking.fromJson(data, documentId));
    return bookingCompleted;
  }
}
