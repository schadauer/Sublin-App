import 'package:Sublin/services/auth_service.dart';
import 'package:Sublin/utils/convert_formatted_address_to_readable_address.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/drawer_side_navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:Sublin/services/google_map_service.dart';

class AddressInputScreen extends StatefulWidget {
  final Function addressInputFunction;
  final String address;
  final bool isStartAddress;
  final bool isEndAddress;
  final String title;
  final String restrictions;
  final bool cityOnly;
  final bool isStation;

  AddressInputScreen({
    this.addressInputFunction,
    this.address = '',
    this.isStartAddress = false,
    this.isEndAddress = false,
    this.title = 'Addresse suchen',
    this.restrictions = '',
    this.cityOnly = false,
    this.isStation = false,
  });

  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  GoogleMapService _autocomplete = GoogleMapService();
  FocusNode _focus = new FocusNode();
  TextEditingController _textFormFieldController = TextEditingController();
  List _autocompleteResults = [];

  // @override
  // void initState() {
  //   // if (widget.restrictions != '') {
  //   //   _textFormFieldController.text = widget.restrictions + ' ';
  //   // }
  //   // TODO: implement initState
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarWidget(title: widget.title),
      endDrawer: DrawerSideNavigationWidget(
        authService: AuthService(),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(15.0),
                child: Material(
                  child: SizedBox(
                    height: 50,
                    child: TextFormField(
                      focusNode: _focus,
                      autofocus: true,
                      onChanged: (input) async {
                        var result =
                            await _autocomplete.getGoogleAddressAutocomplete(
                                input: input,
                                restrictions: widget.restrictions,
                                cityOnly: widget.cityOnly,
                                isStation: widget.isStation);
                        setState(() {
                          _autocompleteResults = result ?? [];
                        });
                      },
                      controller: _textFormFieldController,
                      decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(Icons.home),
                          suffixIcon: IconButton(
                              icon: Icon(Icons.highlight_off),
                              onPressed: () {
                                setState(() {
                                  _autocompleteResults = [];
                                  _textFormFieldController.text = '';
                                });
                              })),
                    ),
                  ),
                )),
            (_autocompleteResults.isNotEmpty)
                ? Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).viewInsets.bottom -
                          75,
                      child: ListView.builder(
                          itemCount: _autocompleteResults.length,
                          itemBuilder: (_, index) {
                            // if (_autocompleteResults[index]['name']
                            //     .toString()
                            //     .contains(widget.restrictions))
                            return GestureDetector(
                              onTap: () {
                                widget.addressInputFunction(
                                    input: _autocompleteResults[index]['name'],
                                    id: _autocompleteResults[index]['id'],
                                    isCompany: _autocompleteResults[index]
                                        ['isCompany'],
                                    terms: _autocompleteResults[index]['terms'],
                                    isStartAddress: widget.isStartAddress,
                                    isEndAddress: widget.isEndAddress);
                                Navigator.of(context).pop();
                              },
                              child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 25),
                                  leading: Icon(_autocompleteResults[index]
                                          ['isCompany']
                                      ? Icons.business
                                      : Icons.home),
                                  title: Text(
                                      convertFormattedAddressToReadableAddress(
                                          _autocompleteResults[index]
                                              ['name']))),
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
}
