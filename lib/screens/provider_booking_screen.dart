import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/booking.dart';
import 'package:Sublin/models/booking_completed.dart';
import 'package:Sublin/models/booking_confirmed.dart';
import 'package:Sublin/models/booking_open.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/step.dart' as step;

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
  // Timer _timer;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now().millisecondsSinceEpoch;
  }

  @override
  Widget build(BuildContext context) {
    // final auth = Provider.of<Auth>(context);
    final openBookings = Provider.of<List<BookingOpen>>(context);
    final confirmedBookings = Provider.of<List<BookingConfirmed>>(context);
    final completedBookings = Provider.of<List<BookingCompleted>>(context);

    return Scaffold(
        appBar: AppbarWidget(title: 'Aufträge'),
        endDrawer: DrawerSideNavigationWidget(
          authService: AuthService(),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 0;
                            });
                          },
                          child: _BookingFilterOption(
                            bookings: openBookings,
                            title: 'Offene',
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 1;
                            });
                          },
                          child: _BookingFilterOption(
                            bookings: confirmedBookings,
                            title: 'Bestätigte',
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _selectedIndex = 2;
                            });
                          },
                          child: _BookingFilterOption(
                            bookings: completedBookings,
                            title: 'Erledigte',
                          ),
                        ),
                      ),
                    ],
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
        bottomNavigationBar: NavigationBarWidget(isProvider: true));
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
        ? Center(child: Text('Derzeit keine Aufträge'))
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
                    provider: _getProviderUser(booking));
                bool isEndStep =
                    booking.sublinEndStep?.bookedTime != null ? true : false;
                int _timeRemaining =
                    (bookingStep.startTime * 1000 - _now) ~/ 60000;
                int _timeFromBooking = (_now - bookingStep.bookedTime) ~/ 60000;
                return Card(
                  margin: EdgeInsets.all(5.0),
                  child: Padding(
                    padding: ThemeConstants.mediumPadding,
                    child: Column(
                      children: [
                        Container(
                          height: 100,
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
                                        MainAxisAlignment.spaceBetween,
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
                                              fontSize: 25,
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
                                        'gebucht',
                                        style:
                                            Theme.of(context).textTheme.caption,
                                        maxLines: 2,
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
                                          getTimeFormat(bookingStep.startTime),
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                    ),
                                    Text(
                                      'von: ' +
                                          convertFormattedAddressToReadableAddress(
                                              bookingStep.startAddress),
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    Text(
                                      'nach: ' +
                                          convertFormattedAddressToReadableAddress(
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
                                onPressed: () {
                                  // _loadingFunction(index);
                                  BookingService().confirmBooking(
                                      providerId: bookingStep.provider.id,
                                      userId: booking.userId,
                                      isSublinEndStep: isEndStep,
                                      index: index);
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
                                onPressed: (_timeRemaining < 200)
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class _BookingFilterOption extends StatelessWidget {
  const _BookingFilterOption({
    Key key,
    @required this.title,
    @required this.bookings,
  }) : super(key: key);

  final String title;
  final List<dynamic> bookings;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Center(child: Text(bookings.length.toString())),
            ),
            AutoSizeText(
              title,
              style: Theme.of(context).textTheme.caption,
            ),
          ],
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
