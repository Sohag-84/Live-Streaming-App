import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageToStorage(
      {required String childName,
      required Uint8List file,
      required String uid}) async {
    Reference ref = _storage.ref().child(childName).child(uid);
    UploadTask uploadTask = ref.putData(
      file,
      SettableMetadata(
        contentType: 'image/jpg',
      ),
    );
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
