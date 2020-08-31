import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/booking.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Sublin/models/step.dart' as step;

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = './providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
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
    // defines a timer
    // _timer = Timer.periodic(Duration(seconds: 30), (Timer t) {
    //   setState(() {
    //     _now = DateTime.now().millisecondsSinceEpoch;
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final openBookings = Provider.of<List<Booking>>(context);
    List<Booking> confirmedBookings;

    return Scaffold(
      appBar: AppbarWidget(title: 'Meine Aufträge'),
      endDrawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (() {
              switch (_selectedIndex) {
                case 0:
                  return Expanded(
                    child: _bookingList(openBookings),
                  );
                  break;
                case 1:
                  return Expanded(
                      child: StreamBuilder<List<Booking>>(
                          initialData: null,
                          stream: BookingService()
                              .streamConfirmedBookings(auth.uid),
                          builder: (context, snapshot) {
                            confirmedBookings = snapshot.data;
                            return _bookingList(confirmedBookings);
                          }));
                  break;
                case 2:
                  return Text('asdfsadf');
                  break;
              }
            }()),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_late),
            title: Text('Aufträge'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            title: Text('Bestätigte'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            title: Text('Vergangene'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
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

  ListView _bookingList(List<Booking> bookings) {
    return ListView.builder(
        itemCount: bookings?.length,
        itemBuilder: (BuildContext context, int index) {
          if (bookings != null) {
            Booking booking = bookings[index];
            step.Step bookingStep = step.Step(
                bookedTime: booking.sublinEndStep?.bookedTime ??
                    booking.sublinStartStep?.bookedTime,
                confirmed: booking.sublinEndStep?.confirmed ??
                    booking.sublinStartStep?.confirmed,
                startAddress: booking.sublinEndStep?.startAddress ??
                    booking.sublinStartStep?.startAddress,
                endAddress: booking.sublinEndStep?.endAddress ??
                    booking.sublinStartStep?.endAddress,
                startTime: booking.sublinEndStep?.startTime ??
                    booking.sublinStartStep?.startTime,
                endTime: booking.sublinEndStep?.endTime ??
                    booking.sublinStartStep?.endTime,
                provider: _getProviderUser(booking));
            int _timeRemaining = (bookingStep.startTime * 1000 - _now) ~/ 60000;
            int _timeFromBooking = (_now - bookingStep.bookedTime) ~/ 60000;
            return Card(
              margin: EdgeInsets.all(5.0),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Container(
                      height: 100,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (bookingStep?.confirmed == true)
                            SizedBox(
                              width: 70,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    'noch',
                                    style: Theme.of(context).textTheme.caption,
                                    maxLines: 2,
                                  ),
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).backgroundColor,
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
                                    style: Theme.of(context).textTheme.caption,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AutoSizeText(
                                    'vor',
                                    style: Theme.of(context).textTheme.caption,
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
                                    style: Theme.of(context).textTheme.caption,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Abholung um ' +
                                      getTimeFormat(bookingStep.startTime),
                                  style: Theme.of(context).textTheme.headline1,
                                ),
                                Text(
                                  'von: ' +
                                      convertFormattedAddressToReadableAddress(
                                          bookingStep.startAddress),
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                Text(
                                  'nach: ' +
                                      convertFormattedAddressToReadableAddress(
                                          bookingStep.endAddress),
                                  style: Theme.of(context).textTheme.bodyText1,
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
                              print(bookingStep.provider.id);
                              BookingService().confirmBooking(
                                  providerId: bookingStep.provider.id,
                                  userId: booking.userId,
                                  isSublinEndStep: true,
                                  index: index);
                            },
                            child: Text('Bestätigen'),
                          ),
                        ],
                      ),
                    if (bookingStep?.confirmed == true)
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
                                        isSublinEndStep: true,
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
                                        isSublinEndStep: true,
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
