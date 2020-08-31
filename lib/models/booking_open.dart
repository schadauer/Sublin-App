import 'package:Sublin/models/booking.dart';

class BookingOpen extends Booking {
  Booking open;
  BookingOpen({this.open}) : super();

  factory BookingOpen.fromJson(Map data, String documentId) {
    data = data ?? {};
    BookingOpen bookingOpen =
        BookingOpen(open: Booking.fromJson(data, documentId));
    return bookingOpen;
  }
}
