import 'package:Sublin/models/address_info_class.dart';
import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/theme/theme.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/services/google_map_service.dart';
import 'package:Sublin/models/request_class.dart';
import 'package:Sublin/services/geolocation_service.dart';
import 'package:Sublin/utils/get_readable_address_from_formatted_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';

class AddressInputScreen extends StatefulWidget {
  final String userUid;
  final User user;
  final Function addressInputCallback;
  final String address;
  final bool isStartAddress;
  final bool isEndAddress;
  final bool showGeolocationOption;
  final String title;
  final String message;
  final String restrictions;
  final String addressTypes;
  final bool cityOnly;
  final bool isStation;
  final ProviderUser providerUser;
  final String station;
  final List<AddressInfo> addressInfoList;

  AddressInputScreen({
    this.userUid = '',
    this.user,
    this.addressInputCallback,
    this.address = '',
    this.isStartAddress = false,
    this.isEndAddress = false,
    this.showGeolocationOption = false,
    this.title = 'Addresse suchen',
    this.message = '',
    this.restrictions = '',
    this.addressTypes = '',
    this.cityOnly = false,
    this.isStation = false,
    this.providerUser,
    this.station,
    this.addressInfoList,
  });

  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  GoogleMapService _autocomplete = GoogleMapService();
  TextEditingController _textFormFieldController = TextEditingController();
  List<AddressInfo> _combinedAddressInfoList = <AddressInfo>[];
  FocusNode _focus;

  @override
  void initState() {
    if (widget.addressInfoList != null)
      _combinedAddressInfoList = widget.addressInfoList;
    if (widget.showGeolocationOption == true)
      _getStartAddressFromGeolocastion();
    _focus = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(milliseconds: 500), () {
        _focus.requestFocus();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: widget.title),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(15.0),
                child: Material(
                  child: Column(
                    children: [
                      if (widget.message != '')
                        Card(
                          color: Theme.of(context).primaryColor,
                          child: SizedBox(
                            height: 90,
                            child: Padding(
                              padding: ThemeConstants.mediumPadding,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Icon(
                                        Icons.error,
                                        size: 40,
                                      )),
                                  Expanded(
                                    flex: 5,
                                    child: AutoSizeText(
                                      widget.message,
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 50,
                        child: TextFormField(
                          focusNode: _focus,
                          onChanged: (input) async {
                            var result = await _autocomplete
                                .getGoogleAddressAutocomplete(
                                    input: input,
                                    restrictions: widget.restrictions,
                                    cityOnly: widget.cityOnly,
                                    isStation: widget.isStation,
                                    addressTypes: widget.addressTypes);
                            List<AddressInfo> toAddressList;
                            if (result != null || result?.length == 0)
                              toAddressList = result.map((item) {
                                return AddressInfo(
                                    formattedAddress: item['name']);
                              }).toList();

                            if (this.mounted) {
                              setState(() {
                                _combinedAddressInfoList =
                                    toAddressList ?? <AddressInfo>[];
                              });
                            }
                          },
                          controller: _textFormFieldController,
                          decoration: InputDecoration(
                              fillColor: Colors.black12,
                              filled: true,
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.home),
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.highlight_off),
                                  onPressed: () {
                                    setState(() {
                                      _combinedAddressInfoList = [];
                                      _textFormFieldController.text = '';
                                    });
                                  })),
                        ),
                      ),
                    ],
                  ),
                )),
            (_combinedAddressInfoList.isNotEmpty)
                ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).viewInsets.bottom -
                          75,
                      child: ListView.builder(
                          itemCount: _combinedAddressInfoList.length,
                          itemBuilder: (_, index) {
                            return GestureDetector(
                              onTap: () {
                                widget.addressInputCallback(
                                  userUid: widget.userUid,
                                  input: _combinedAddressInfoList[index]
                                      .formattedAddress,
                                  addressInfo: _combinedAddressInfoList[index],
                                  user:
                                      widget.user != null ? widget.user : null,
                                  isStartAddress: widget.isStartAddress,
                                  isEndAddress: widget.isEndAddress,
                                  providerUser: widget.providerUser,
                                  station: widget.station,
                                );
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 25),
                                  title: Text(
                                      getReadableAddressFromFormattedAddress(
                                          _combinedAddressInfoList[index]
                                              .formattedAddress))),
                            );
                          }),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }

  Future<void> _getStartAddressFromGeolocastion() async {
    try {
      Request _geolocation = await GeolocationService().getCurrentCoordinates();
      if (_geolocation != null && this.mounted) {
        setState(() {
          // _combinedAddressInfoList = [
          //   {
          //     'name': _geolocation.startAddress,
          //     'id': _geolocation.startId,
          //     'terms': null,
          //     'isCompany': false,
          //     'isStartAddress': true,
          //     'isEndAddress': false,
          //   }
          // ];
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
