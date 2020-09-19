import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class ImageService {
  Future<String> uploadFile(String userUid, File image) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('sublin/profile/$userUid');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String fileURL = await storageReference.getDownloadURL();
    return fileURL;
  }
}
