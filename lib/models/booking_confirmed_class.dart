import 'package:Sublin/models/booking_class.dart';

class BookingConfirmed extends Booking {
  Booking confirmed;
  BookingConfirmed({this.confirmed}) : super();

  factory BookingConfirmed.fromJson(Map data, String documentId) {
    data = data ?? {};
    BookingConfirmed bookingConfirmed =
        BookingConfirmed(confirmed: Booking.fromJson(data, documentId));
    return bookingConfirmed;
  }
}
