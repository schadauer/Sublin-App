import 'package:Sublin/models/provider_plan.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/step.dart';

class Booking {
  Step sublinStartStep;
  Step sublinEndStep;
  Booking({
    this.sublinStartStep,
    this.sublinEndStep,
  });

  factory Booking.fromMap(Map data, String documentId) {
    Step defaultValueStep = Step();
    Booking defaultValueBooking = Booking();
    ProviderUser defaultValueProviderUser = ProviderUser();
    // print(data.values);
    data = data ?? {};
    // print(documentId);
    Booking booking = Booking(
      sublinEndStep: (data['sublinEndStep'] == null)
          ? defaultValueBooking.sublinEndStep
          : Step(
              id: documentId,
              endAddress: data['sublinEndStep']['endAddress'] ??
                  defaultValueStep.endAddress,
              startAddress: data['sublinEndStep']['startAddress'] ??
                  defaultValueStep.startAddress,
              startTime: data['sublinEndStep']['startTime'] ??
                  defaultValueStep.startTime,
              endTime:
                  data['sublinEndStep']['endTime'] ?? defaultValueStep.endTime,
              provider: (data['sublinEndStep']['provider'] == null)
                  ? defaultValueStep.provider
                  : ProviderUser(
                      providerType: ProviderType.values.firstWhere(
                          (e) =>
                              e.toString() ==
                              'ProviderType.' +
                                  data['sublinEndStep']['provider']
                                      ['providerType'],
                          orElse: () => defaultValueProviderUser.providerType),
                      providerPlan: ProviderPlan.values.firstWhere(
                          (e) =>
                              e.toString() ==
                              'providerPlan.' +
                                  data['sublinEndStep']['provider']
                                      ['providerPlan'],
                          orElse: () => defaultValueProviderUser.providerPlan),
                      providerName: data['sublinEndStep']['provider']
                              ['providerName'] ??
                          defaultValueProviderUser.providerName,
                      id: data['sublinEndStep']['provider']['id'] ??
                          defaultValueProviderUser.id,
                      timeStart: data['sublinEndStep']['provider']
                              ['timeStart'] ??
                          defaultValueProviderUser.timeStart,
                      timeEnd: data['sublinEndStep']['provider']['timeEnd'] ??
                          defaultValueProviderUser.timeEnd,
                    ),
              distance: data['sublinEndStep']['distance'] ??
                  defaultValueStep.distance,
              duration: data['sublinEndStep']['duration'] ??
                  defaultValueStep.duration,
            ),
    );
    return booking;
  }

  factory Booking.initialData() {
    return Booking(
        sublinEndStep: Step(
      distance: 5,
    ));
  }
}

class BookingList {
  List<Booking> bookingList;

  BookingList({
    this.bookingList,
  });

  factory BookingList.fromMap(Map data) {
    BookingList list;
    // for (var i = 0; i < data.length; i++) {
    //   list = [Booking()]
    // }
    return list;
  }
}
