import 'package:Sublin/models/provider_plan.dart';
import 'package:Sublin/models/provider_type.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/step.dart';

class Booking {
  String bookingId;
  String userId;
  Step sublinStartStep;
  Step sublinEndStep;
  Booking({
    this.bookingId,
    this.userId,
    this.sublinStartStep,
    this.sublinEndStep,
  });

  factory Booking.fromMap(Map data, String documentId) {
    Step defaultValueStep = Step();
    Booking defaultValueBooking = Booking();
    ProviderUser defaultValueProviderUser = ProviderUser();

    data = data ?? {};

    Booking booking = Booking(
      bookingId: data['bookingId'] ?? defaultValueBooking.bookingId,
      userId: data['userId'] ?? defaultValueBooking.userId,
      sublinEndStep: (data['sublinEndStep'] == null)
          ? defaultValueBooking.sublinEndStep
          : Step(
              id: documentId,
              bookedTime: data['sublinEndStep']['bookedTime'] ??
                  defaultValueStep.bookedTime,
              confirmed: data['sublinEndStep']['confirmed'] ??
                  defaultValueStep.confirmed,
              confirmedTime: data['sublinEndStep']['confirmedTime'] ??
                  defaultValueStep.confirmedTime,
              completedTime: data['sublinEndStep']['completedTime'] ??
                  defaultValueStep.completedTime,
              noShow:
                  data['sublinEndStep']['noShow'] ?? defaultValueStep.noShow,
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
      sublinStartStep: (data['sublinStartStep'] == null)
          ? defaultValueBooking.sublinStartStep
          : Step(
              id: documentId,
              bookedTime: data['sublinStartStep']['bookedTime'] ??
                  defaultValueStep.bookedTime,
              confirmed: data['sublinStartStep']['confirmed'] ??
                  defaultValueStep.confirmed,
              confirmedTime: data['sublinStartStep']['confirmedTime'] ??
                  defaultValueStep.confirmedTime,
              completedTime: data['sublinStartStep']['completedTime'] ??
                  defaultValueStep.completedTime,
              noShow:
                  data['sublinStartStep']['noShow'] ?? defaultValueStep.noShow,
              endAddress: data['sublinStartStep']['endAddress'] ??
                  defaultValueStep.endAddress,
              startAddress: data['sublinStartStep']['startAddress'] ??
                  defaultValueStep.startAddress,
              startTime: data['sublinStartStep']['startTime'] ??
                  defaultValueStep.startTime,
              endTime: data['sublinStartStep']['endTime'] ??
                  defaultValueStep.endTime,
              provider: (data['sublinStartStep']['provider'] == null)
                  ? defaultValueStep.provider
                  : ProviderUser(
                      providerType: ProviderType.values.firstWhere(
                          (e) =>
                              e.toString() ==
                              'ProviderType.' +
                                  data['sublinStartStep']['provider']
                                      ['providerType'],
                          orElse: () => defaultValueProviderUser.providerType),
                      providerPlan: ProviderPlan.values.firstWhere(
                          (e) =>
                              e.toString() ==
                              'providerPlan.' +
                                  data['sublinStartStep']['provider']
                                      ['providerPlan'],
                          orElse: () => defaultValueProviderUser.providerPlan),
                      providerName: data['sublinStartStep']['provider']
                              ['providerName'] ??
                          defaultValueProviderUser.providerName,
                      id: data['sublinStartStep']['provider']['id'] ??
                          defaultValueProviderUser.id,
                      timeStart: data['sublinStartStep']['provider']
                              ['timeStart'] ??
                          defaultValueProviderUser.timeStart,
                      timeEnd: data['sublinStartStep']['provider']['timeEnd'] ??
                          defaultValueProviderUser.timeEnd,
                    ),
              distance: data['sublinStartStep']['distance'] ??
                  defaultValueStep.distance,
              duration: data['sublinStartStep']['duration'] ??
                  defaultValueStep.duration,
            ),
    );
    return booking;
  }
}
