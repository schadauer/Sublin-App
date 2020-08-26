import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/booking.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:Sublin/widgets/loading_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  int _loadingIndex;
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
      body: Column(
        children: [
          (() {
            switch (_selectedIndex) {
              case 0:
                return Expanded(child: _bookingList(openBookings));
                break;
              case 1:
                return Expanded(
                    child: StreamBuilder<List<Booking>>(
                        initialData: null,
                        stream:
                            BookingService().streamConfirmedBookings(auth.uid),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_late),
            title: Text('Offene'),
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

  ListView _bookingList(List<Booking> bookings) {
    int now = DateTime.now().millisecondsSinceEpoch;
    print(now);

    return ListView.builder(
        itemCount: bookings?.length,
        itemBuilder: (BuildContext context, int index) {
          if (bookings != null) {
            Booking booking = bookings[index];
            step.Step bookingStep = step.Step(
                startAddress: booking.sublinEndStep?.startAddress ??
                    booking.sublinStartStep?.startAddress,
                endAddress: booking.sublinEndStep?.endAddress ??
                    booking.sublinStartStep?.endAddress,
                startTime: booking.sublinEndStep?.startTime ??
                    booking.sublinStartStep?.startTime,
                endTime: booking.sublinEndStep?.endTime ??
                    booking.sublinStartStep?.endTime,
                provider: ProviderUser(
                      id: booking.sublinEndStep.provider?.id,
                    ) ??
                    ProviderUser(
                      id: booking.sublinStartStep.provider?.id,
                    ));

            return Card(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          'Abholung in',
                          style: Theme.of(context).textTheme.caption,
                        ),
                        Text('')
                      ],
                    ),
                  )
                ],
              ),
            );

            // ListTile(
            //   contentPadding: EdgeInsets.all(20),
            //   enabled: true,
            //   // leading: isSublinEndStep ? Icon(Icons.train) : Icon(Icons.home),
            //   title: Text(
            //     bookingStep.startAddress,
            //     style: Theme.of(context).textTheme.headline4,
            //   ),
            //   subtitle:
            //       Text('Abholung um ' + getTimeFormat(bookingStep.startTime)),
            //   trailing: InkWell(
            //     onTap: () {
            //       _loadingFunction(index);
            //       BookingService().confirmBooking(
            //           providerId: bookingStep.provider.id,
            //           userId: booking.userId,
            //           isSublinEndStep: true,
            //           index: index);
            //     },
            //     child: _loadingIndex != _selectedIndex
            //         ? Column(
            //             children: [
            //               Icon(Icons.check_circle),
            //               SizedBox(
            //                 height: 5,
            //               ),
            //               Text('Akzeptieren'),
            //             ],
            //           )
            //         : CircularProgressIndicator(),
            //   ),
            // );
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
