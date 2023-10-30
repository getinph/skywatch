import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageClient {
  static Future<String> uploadOnePicture(Uint8List media) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String timestamp = DateTime.now().microsecondsSinceEpoch.toString();
    await FirebaseStorage.instance.ref('$userId-$timestamp').putData(media);
    return await FirebaseStorage.instance
        .ref('$userId-$timestamp')
        .getDownloadURL();
  }
}
