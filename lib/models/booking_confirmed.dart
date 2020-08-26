import 'package:Sublin/models/booking.dart';
import 'package:Sublin/models/step.dart';

class BookingConfirmed extends Booking {
  BookingConfirmed(
    String bookingId,
    String userId,
    Step sublinStartStep,
    Step sublinEndStep,
    Function fromMap,
  ) : super();
}
