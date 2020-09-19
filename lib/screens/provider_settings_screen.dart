import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;

import 'package:Sublin/models/provider_user.dart';
import 'package:Sublin/models/user_class.dart';
import 'package:Sublin/models/user_type_enum.dart';
import 'package:Sublin/widgets/appbar_widget.dart';
import 'package:Sublin/widgets/navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProviderSettingsScreen extends StatefulWidget {
  static const routeName = './providerScopeScreenState';
  @override
  _ProviderSettingsScreenState createState() => _ProviderSettingsScreenState();
}

class _ProviderSettingsScreenState extends State<ProviderSettingsScreen> {
  File _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final ProviderUser providerUser = Provider.of<ProviderUser>(context);
    final User user = Provider.of<User>(context);

    print(_image);

    return Scaffold(
      bottomNavigationBar: NavigationBarWidget(
        isProvider: user.userType != UserType.user,
        setNavigationIndex: 1,
        providerUser: providerUser,
      ),
      appBar: AppbarWidget(title: 'Mein Service', showProfileIcon: false),
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              onPressed: getImage,
              child: Text('Bild hochladen'),
            ),
            Center(
              child: _image == null
                  ? Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.face,
                        color: Theme.of(context).primaryColor,
                        size: 80,
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Image.file(_image),
                    ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              user.firstName,
              style: Theme.of(context).textTheme.headline1,
            ),
          ],
        ),
      ),
    );
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      _image = File(pickedFile?.path);
    });
  }
}
