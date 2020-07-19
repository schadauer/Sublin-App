import 'package:flutter/material.dart';
import 'package:sublin/services/google_map_service.dart';

class AddressInputScreen extends StatefulWidget {
  final Function addressInputFunction;
  final String address;
  final bool isStartAddress;
  final bool isEndAddress;
  final String title;
  final String restrictions;

  AddressInputScreen({
    this.addressInputFunction,
    this.address = '',
    this.isStartAddress = false,
    this.isEndAddress = false,
    this.title = 'Addresse suchen',
    this.restrictions = '',
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Hero(
                  tag: 'addressField',
                  child: Material(
                    child: SizedBox(
                      height: 75,
                      child: TextFormField(
                        focusNode: _focus,
                        autofocus: true,
                        onChanged: (input) async {
                          var result =
                              await _autocomplete.getGoogleAddressAutocomplete(
                                  input, widget.restrictions);
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
                            if (_autocompleteResults[index]['name']
                                .toString()
                                .contains(widget.restrictions))
                              return GestureDetector(
                                onTap: () {
                                  widget.addressInputFunction(
                                      _autocompleteResults[index]['name'],
                                      _autocompleteResults[index]['id'],
                                      widget.isStartAddress,
                                      widget.isEndAddress);
                                  Navigator.of(context).pop();
                                },
                                child: ListTile(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 20),
                                    leading: Icon(Icons.home),
                                    title: Text(
                                        _autocompleteResults[index]['name'])),
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
