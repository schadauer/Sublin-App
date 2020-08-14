import 'dart:async';

import 'package:Sublin/models/auth.dart';
import 'package:Sublin/models/booking.dart';
import 'package:Sublin/models/booking_status.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user.dart';
import 'package:Sublin/services/booking_service.dart';
import 'package:Sublin/utils/get_time_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class ProviderHomeScreen extends StatefulWidget {
  static const routeName = './providerHomeScreen';
  @override
  _ProviderHomeScreenState createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  final _controller = ScrollController();
  double get maxHeight => 150 + MediaQuery.of(context).padding.top;
  double get minHeight => kToolbarHeight + MediaQuery.of(context).padding.top;
  bool isEmpty = false;
  StreamSubscription<List<Booking>> _confirmedBookingsSubscription;
  List<Booking> confirmedBookings;
  BookingStatus bookingStatus;

  @override
  void initState() {
    setState(() {
      bookingStatus = BookingStatus.open;
      super.initState();
    });
  }

  // @override
  // void dispose() {

  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    final openBookings = Provider.of<List<Booking>>(context);

    return Scaffold(
        body: SafeArea(
      child: StreamBuilder<List<Booking>>(
          initialData: [Booking()],
          stream: BookingService().streamConfirmedBookings(auth.uid),
          builder: (context, snapshot) {
            confirmedBookings = snapshot.data;
            return CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              controller: _controller,
              slivers: [
                SliverAppBar(
                  collapsedHeight: 100,
                  title: Text('Aufträge'),
                  pinned: true,
                  stretch: true,
                  flexibleSpace: Header(
                    setFilterFunction: setFilterFunction,
                    bookingStatus: bookingStatus,
                    maxHeight: maxHeight,
                    minHeight: minHeight,
                    openBookingsCount:
                        openBookings != null ? openBookings.length : 0,
                    confirmedBookingsCount: confirmedBookings != null
                        ? confirmedBookings.length
                        : 0,
                  ),
                  expandedHeight:
                      maxHeight - MediaQuery.of(context).padding.top,
                ),
                if (!isEmpty)
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildCard(index, openBookings,
                            confirmedBookings, bookingStatus);
                      },
                    ),
                  )
                else
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "List is empty",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
    ));
  }

  ListTile _buildCard(int index, List<Booking> openBookings,
      List<Booking> confirmedBookings, BookingStatus bookingstatus) {
    List<Booking> bookings;

    switch (bookingstatus) {
      case BookingStatus.confirmed:
        bookings = confirmedBookings;
        break;
      default:
        bookings = openBookings;
    }
    if (bookings != null && index < bookings.length) {
      Booking booking = bookings[index];
      bool isSublinEndStep = false;
      if (booking.sublinEndStep != null) isSublinEndStep = true;
      return ListTile(
        contentPadding: EdgeInsets.all(20),
        enabled: true,
        leading: isSublinEndStep ? Icon(Icons.train) : Icon(Icons.home),
        title: Text(
          booking.sublinEndStep.endAddress,
          style: Theme.of(context).textTheme.headline4,
        ),
        subtitle: Text(
            'Abholung um ' + getTimeFormat(booking.sublinEndStep.startTime)),
        trailing: InkWell(
          onTap: () {
            BookingService().confirmBooking(
                uid: booking.sublinEndStep.provider.id,
                documentId: isSublinEndStep
                    ? booking.sublinEndStep.id
                    : booking.sublinStartStep.id,
                isSublinEndStep: isSublinEndStep);
          },
          child: Column(
            children: [
              Icon(Icons.check_circle),
              SizedBox(
                height: 5,
              ),
              Text('Akzeptieren'),
            ],
          ),
        ),
      );

      // Card(
      //   margin: EdgeInsets.only(left: 12, right: 12, top: 12),
      //   child: Row(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       Container(
      //         margin: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
      //         child: Text(booking.sublinEndStep.provider.providerName),
      //       ),
      //       Container(child: ,)
      //     ],
      //   ),
      // );
    } else
      return null;
  }

  void setFilterFunction(BookingStatus status) {
    setState(() {
      bookingStatus = status;
    });
  }
}

class Header extends StatelessWidget {
  final Function setFilterFunction;
  final BookingStatus bookingStatus;
  final double maxHeight;
  final double minHeight;
  final int openBookingsCount;
  final int confirmedBookingsCount;

  const Header({
    Key key,
    this.setFilterFunction,
    this.bookingStatus,
    this.maxHeight,
    this.minHeight,
    this.openBookingsCount,
    this.confirmedBookingsCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final expandRatio = _calculateExpandRatio(constraints);
        final animation = AlwaysStoppedAnimation(expandRatio);

        return Stack(
          fit: StackFit.expand,
          children: [
            // _buildImage(),
            // _buildGradient(animation),
            _buildFilter(animation, constraints, setFilterFunction)
          ],
        );
      },
    );
  }

  double _calculateExpandRatio(BoxConstraints constraints) {
    var expandRatio =
        (constraints.maxHeight - minHeight) / (maxHeight - minHeight);
    if (expandRatio > 1.0) expandRatio = 1.0;
    if (expandRatio < 0.0) expandRatio = 0.0;
    return expandRatio;
  }

  ConstrainedBox _buildFilter(
    Animation<double> animation,
    BoxConstraints constraints,
    Function setFilterFunction,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: constraints.maxHeight,
        minHeight: constraints.minHeight,
      ),
      child: Row(
        children: [
          BookingFilterWidget(
            number: openBookingsCount,
            description: 'Offene',
            setFilterFunction: setFilterFunction,
            bookingStatus: BookingStatus.open,
          ),
          BookingFilterWidget(
            number: confirmedBookingsCount,
            description: 'Bestätigte',
            setFilterFunction: setFilterFunction,
            bookingStatus: BookingStatus.confirmed,
          ),
          BookingFilterWidget(
            number: 0,
            description: 'Durchgeführte',
            setFilterFunction: setFilterFunction,
            bookingStatus: BookingStatus.completed,
          ),
        ],
      ),
    );
  }

  // Container _buildGradient(Animation<double> animation) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       gradient: LinearGradient(
  //         colors: [
  //           Colors.transparent,
  //           ColorTween(begin: Colors.black87, end: Colors.black38)
  //               .evaluate(animation)
  //         ],
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //       ),
  //     ),
  //   );
  // }

  // Image _buildImage() {
  //   return Image.network(
  //     "https://www.rollingstone.com/wp-content/uploads/2020/02/TheWeeknd.jpg",
  //     fit: BoxFit.cover,
  //   );
  // }
}

class BookingFilterWidget extends StatelessWidget {
  final Function setFilterFunction;
  final BookingStatus bookingStatus;
  final int number;
  final String description;
  const BookingFilterWidget({
    this.setFilterFunction,
    this.bookingStatus,
    this.number = 0,
    this.description = '',
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: InkWell(
        onTap: () {
          setFilterFunction(bookingStatus);
        },
        child: Card(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    number.toString(),
                    style: TextStyle(fontSize: 60),
                  )),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Text(
                    description,
                  )),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}
