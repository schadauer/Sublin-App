import 'package:flutter/material.dart';
import 'package:sublin/services/autocomplete_service.dart';

class AddressInputScreen extends StatefulWidget {
  final Function textInputFunction;
  final String address;
  final bool startAddress;
  final bool endAddress;

  AddressInputScreen(
      {this.textInputFunction,
      this.address,
      this.startAddress = false,
      this.endAddress = false});

  @override
  _AddressInputScreenState createState() => _AddressInputScreenState();
}

class _AddressInputScreenState extends State<AddressInputScreen> {
  Autocomplete _autocomplete = Autocomplete();
  FocusNode _focus = new FocusNode();
  TextEditingController _textFormFieldController = TextEditingController();
  List _autocompleteResults = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meine Zieladresse'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          children: <Widget>[
            Container(
                height: 75,
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  focusNode: _focus,
                  autofocus: true,
                  onChanged: (input) async {
                    var result =
                        await _autocomplete.getGoogleAddressAutocomplete(input);
                    setState(() {
                      _autocompleteResults = result;
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
                            return GestureDetector(
                              onTap: () {
                                widget.textInputFunction(
                                    _autocompleteResults[index]['name'],
                                    _autocompleteResults[index]['id'],
                                    widget.startAddress,
                                    widget.endAddress);
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
