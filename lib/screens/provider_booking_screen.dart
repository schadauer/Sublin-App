import 'dart:async';

import 'package:Sublin/models/provider_type.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/step.dart' as step;

import 'package:Sublin/models/booking_class.dart';
import 'package:Sublin/models/booking_completed_class.dart';
import 'package:Sublin/models/booking_confirmed_class.dart';
import 'package:Sublin/models/booking_open_class.dart';
import 'package:Sublin/models/booking_status_enum.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:Sublin/utils/get_date_format.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';

class ProviderBookingScreen extends StatefulWidget {
  static const routeName = './providerBookingScreen';
  @override
  _ProviderBookingScreenState createState() => _ProviderBookingScreenState();
}

class _ProviderBookingScreenState extends State<ProviderBookingScreen> {
  int _selectedIndex = 0;
  // static const TextStyle optionStyle =
  //     TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _loadingIndex;
  int _now;
  Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<Auth>(context);
    final ProviderUser providerUser = Provider.of<ProviderUser>(context);
    final openBookings = Provider.of<List<BookingOpen>>(context);
    final confirmedBookings = Provider.of<List<BookingConfirmed>>(context);
    final completedBookings = Provider.of<List<BookingCompleted>>(context);
    _now = DateTime.now().millisecondsSinceEpoch;

    // * For sponsors and sponsorshuttles we only need done bookings
    if (providerUser.providerType == ProviderType.sponsor ||
        providerUser.providerType == ProviderType.sponsorShuttle)
      _selectedIndex = 2;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppbarWidget(title: 'Aufträge'),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (providerUser.providerType == ProviderType.taxi ||
                  providerUser.providerType == ProviderType.shuttle)
                SizedBox(
                    height: 80,
                    child: Container(
                      color: Theme.of(context).primaryColor,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              child: _BookingFilterOption(
                                bookings: openBookings,
                                title: 'Offene',
                                active: _selectedIndex == 0,
                                bookingStatus: BookingStatus.open,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 1;
                                });
                              },
                              child: _BookingFilterOption(
                                bookings: confirmedBookings,
                                title: 'Bestätigte',
                                active: _selectedIndex == 1,
                                bookingStatus: BookingStatus.confirmed,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedIndex = 2;
                                });
                              },
                              child: _BookingFilterOption(
                                bookings: completedBookings,
                                title: 'Erledigte',
                                active: _selectedIndex == 2,
                                bookingStatus: BookingStatus.completed,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              (() {
                switch (_selectedIndex) {
                  case 0:
                    return Expanded(
                      flex: 10,
                      child: _bookingList(openBookings),
                    );
                    break;
                  case 1:
                    return Expanded(
                      child: _bookingList(confirmedBookings),
                    );
                    break;
                  case 2:
                    return Expanded(
                      child: _bookingList(completedBookings),
                    );
                    // return BottomSheetNavigation();
                    break;
                  case 3:
                    return Expanded(
                      child: Text('3'),
                    );
                    break;
                }
              }()),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBarWidget(
          isProvider: true,
          setNavigationIndex: 0,
          providerUser: providerUser,
        ));
  }

  ProviderUser _getProviderUser(Booking booking) {
    if (booking.sublinStartStep?.provider != null) {
      return ProviderUser(
        id: booking.sublinStartStep.provider.id,
      );
    } else if (booking.sublinEndStep?.provider != null)
      return ProviderUser(
        id: booking.sublinEndStep.provider.id,
      );
    else {
      return ProviderUser();
    }
  }

  Widget _bookingList(List<dynamic> bookings) {
    return bookings.isEmpty
        ? Center(child: Text('Derzeit keine offenen Aufträge'))
        : ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (BuildContext context, int index) {
              if (bookings != null) {
                Booking booking;
                if (bookings[index] is BookingOpen)
                  booking = bookings[index].open;
                if (bookings[index] is BookingConfirmed)
                  booking = bookings[index].confirmed;
                if (bookings[index] is BookingCompleted)
                  booking = bookings[index].completed;
                step.Step bookingStep = step.Step(
                    bookedTime: booking.sublinEndStep?.bookedTime ??
                        booking.sublinStartStep?.bookedTime,
                    confirmed: booking.sublinEndStep?.confirmed ??
                        booking.sublinStartStep?.confirmed,
                    completed: booking.sublinEndStep?.completed ??
                        booking.sublinStartStep?.completed,
                    startAddress: booking.sublinEndStep?.startAddress ??
                        booking.sublinStartStep?.startAddress,
                    endAddress: booking.sublinEndStep?.endAddress ??
                        booking.sublinStartStep.endAddress,
                    startTime: booking.sublinEndStep?.startTime ??
                        booking.sublinStartStep.startTime,
                    endTime: booking.sublinEndStep?.endTime ??
                        booking.sublinStartStep.endTime,
                    userName: booking.sublinEndStep?.userName ??
                        booking.sublinStartStep.userName,
                    provider: _getProviderUser(booking));
                bool isEndStep =
                    booking.sublinEndStep?.bookedTime != null ? true : false;
                int _timeRemaining =
                    (bookingStep.startTime * 1000 - _now) ~/ 60000;
                int _timeFromBooking = (_now - bookingStep.bookedTime) ~/ 60000;
                return Card(
                  // color: Theme.of(context).primaryColor,
                  margin: EdgeInsets.all(5.0),
                  child: Padding(
                    padding: ThemeConstants.mediumPadding,
                    child: Column(
                      children: [
                        Container(
                          height: 140,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (bookingStep?.confirmed == true &&
                                  bookingStep?.completed == false)
                                SizedBox(
                                  width: 70,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        'noch',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        maxLines: 2,
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color:
                                              Theme.of(context).backgroundColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _timeRemaining.toString(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      AutoSizeText(
                                        'Min',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        maxLines: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              if (bookingStep?.confirmed == false)
                                SizedBox(
                                  width: 70,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      AutoSizeText(
                                        'vor',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        maxLines: 2,
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: (_timeFromBooking < 5)
                                              ? Theme.of(context).primaryColor
                                              : Theme.of(context).errorColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            _timeFromBooking.toString(),
                                            style: TextStyle(
                                              fontSize: 25,
                                              fontFamily: 'Lato',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      AutoSizeText(
                                        'Minuten gebucht',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 110,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Abholung um ' +
                                          getDateFormat(bookingStep.startTime),
                                      style:
                                          Theme.of(context).textTheme.headline2,
                                    ),
                                    Text(
                                      bookingStep.userName,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      'von: ' +
                                          getReadableAddressFromFormattedAddress(
                                              bookingStep.startAddress),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      'nach: ' +
                                          getReadableAddressFromFormattedAddress(
                                              bookingStep.endAddress),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        if (bookingStep?.confirmed == false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton(
                                onPressed: () async {
                                  // _loadingFunction(index);
                                  int numberOfOpens = bookings.length;

                                  await BookingService().confirmBooking(
                                      providerId: bookingStep.provider.id,
                                      userId: booking.userId,
                                      isSublinEndStep: isEndStep,
                                      index: index);
                                  // If we have accepted the last one jump to the confirmed list
                                  if (numberOfOpens == 1) {
                                    setState(() {
                                      _selectedIndex = 1;
                                    });
                                  }
                                },
                                child: Text('Bestätigen'),
                              ),
                            ],
                          ),
                        if (bookingStep?.confirmed == true &&
                            bookingStep?.completed == false)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RaisedButton(
                                onPressed: (_timeRemaining < 0)
                                    ? () {
                                        _loadingFunction(index);
                                        BookingService().noShowBooking(
                                            providerId: bookingStep.provider.id,
                                            userId: booking.userId,
                                            isSublinEndStep: isEndStep,
                                            index: index);
                                      }
                                    : null,
                                child: Text('Nicht erschienen'),
                              ),
                              RaisedButton(
                                onPressed: (_timeRemaining < 0)
                                    ? () {
                                        _loadingFunction(index);
                                        BookingService().completedBooking(
                                            providerId: bookingStep.provider.id,
                                            userId: booking.userId,
                                            isSublinEndStep: isEndStep,
                                            index: index);
                                      }
                                    : null,
                                child: Text('Abgeschlossen'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                );
              } else
                return null;
            });
  }

  void _loadingFunction(int index) {
    setState(() {
      _loadingIndex = index;
    });
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
}

class _BookingFilterOption extends StatelessWidget {
  const _BookingFilterOption({
    Key key,
    @required this.title,
    @required this.bookings,
    @required this.active,
    @required this.bookingStatus,
  }) : super(key: key);

  final String title;
  final List<dynamic> bookings;
  final bool active;
  final BookingStatus bookingStatus;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: active ? Colors.white : Theme.of(context).primaryColor,
      child: Padding(
        padding: ThemeConstants.mediumPadding,
        child: bookingStatus != BookingStatus.completed
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Center(
                        child: Text(
                      bookings.length.toString(),
                      style:
                          TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                    )),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  AutoSizeText(
                    title,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              )
            : Center(
                child: AutoSizeText(
                  title,
                  style: Theme.of(context).textTheme.caption,
                ),
              ),
      ),
    );
  }
}

// class BottomSheetNavigation extends StatefulWidget {
//   @override
//   _BottomSheetNavigationState createState() => _BottomSheetNavigationState();
// }

// class _BottomSheetNavigationState extends State<BottomSheetNavigation> {
//   PersistentBottomSheetController _controller;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _controller = showBottomSheet(
//           context: context,
//           builder: (context) => Container(child: Text('asdfs')));
//     });
//   }

//   // @override
//   // void dispose() {
//   //   _controller.close;
//   //   super.dispose();
//   // }

//   @override
//   PersistentBottomSheetController build(BuildContext context) {
//     return Scaffold.of(context).showBottomSheet((context) => null)

//   }
// }
