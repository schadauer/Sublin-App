import 'package:flutter/material.dart';
import 'package:Sublin/utils/get_email_initials.dart';
import 'package:Sublin/utils/is_email_format.dart';

class EmailListScreen extends StatefulWidget {
  List<String> targetGroup;
  Function emailListScreenFunction;

  EmailListScreen({
    this.targetGroup,
    this.emailListScreenFunction,
  });
  static const routeName = '/emailListScreen';
  @override
  _EmailListScreenState createState() => _EmailListScreenState();
}

class _EmailListScreenState extends State<EmailListScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  TextEditingController _emailFieldController = TextEditingController();
  List<String> targetGroup = ['1', '2', '4', 'd', 'df'];
  bool _isEmail = false;
  String _email = '';

  @override
  Widget build(BuildContext context) {
    print(targetGroup);
    return Scaffold(
      appBar: AppBar(
        title: Text('E-Mails hinzufügen'),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height -
            AppBar().preferredSize.height -
            MediaQuery.of(context).viewInsets.bottom,
        child: Column(
          children: <Widget>[
            Container(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  child: SizedBox(
                    // height: 75,
                    child: TextFormField(
                      autofocus: true,
                      onChanged: (input) {
                        setState(() {
                          _isEmail = isEmailFormat(input);
                        });

                        // if (isEmailFormat(input) != _isEmail)
                        //   setState(() {
                        //     _isEmail = isEmailFormat(input);
                        //   });
                      },
                      controller: _emailFieldController,
                      decoration: InputDecoration(
                          fillColor: Colors.black12,
                          filled: true,
                          border: InputBorder.none,
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0)),
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: IconButton(
                              icon: Icon(
                                Icons.add_circle_outline,
                                size: 30,
                              ),
                              onPressed: !_isEmail
                                  ? () {
                                      _insertSingleItem(_emailFieldController
                                          .text
                                          .toLowerCase());
                                      _emailFieldController.text = '';
                                      setState(() {});
                                    }
                                  : null)),
                    ),
                  ),
                )),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    MediaQuery.of(context).viewInsets.bottom -
                    75,
                child: AnimatedList(
                  key: _listKey,
                  initialItemCount: targetGroup.length,
                  itemBuilder: (context, index, animation) {
                    return _buildItem(targetGroup[index], animation, index);
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _insertSingleItem(String email) {
    int insertIndex = 0;
    targetGroup.insert(insertIndex, email);
    _listKey.currentState.insertItem(insertIndex);
  }

  void _removeSingleItems(int index) {
    String removedItem = targetGroup.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      // A method to build the Card widget.
      return _buildItem(removedItem, animation, index);
    };

    _listKey.currentState.removeItem(index, builder);
  }

  Widget _buildItem(String item, Animation animation, int index) {
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20.0,
              child: Text(getEmailInitials(item)),
              // backgroundImage:
              //     NetworkImage("${snapshot.data.hitsList[index].previewUrl}"),
              backgroundColor: Colors.black54,
            ),
            title: Text(
              item,
              style: Theme.of(context).textTheme.headline3,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color: Theme.of(context).errorColor,
              ),
              onPressed: () {
                _removeSingleItems(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}
