import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  Future<String> uploadFile(String userUid, File image) async {
    Reference storageReference =
        FirebaseStorage.instance.ref().child('sublin/profile/$userUid');
    UploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.asStream().first;
    print('File Uploaded');
    String fileURL = await storageReference.getDownloadURL();
    return fileURL;
  }
}
