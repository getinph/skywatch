import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skywatch/clients/firestorage.client.dart';
import 'package:skywatch/clients/video.client.dart';
import 'package:skywatch/components/media_source_button.component.dart';
import 'package:skywatch/global.dart';
import 'package:skywatch/shared.dart';

class ShareStoryButton extends StatefulWidget {
  const ShareStoryButton({super.key});

  @override
  State<ShareStoryButton> createState() => _ShareStoryButtonState();
}

class _ShareStoryButtonState extends State<ShareStoryButton> {
  static ValueNotifier<bool> isUploading = ValueNotifier<bool>(false);

  shareVideo() async {
    ImageSource? imageSource = await askSourceType(context);
    if (imageSource != null) {
      XFile? video = await ImagePicker().pickVideo(
          source: imageSource, maxDuration: const Duration(seconds: 5));
      if (video != null) {
        isUploading.value = true;
        int sizeInBytes = await video.length();
        if (sizeInBytes / 1000000 < 20) {
          Uint8List videoBytes = await video.readAsBytes();
          await saveVideo(videoBytes);
          if (mounted) await launchSnackBar(context, 'Video uploaded');
        } else {
          if (mounted) {
            await launchSnackBar(context, 'Video too heavy, lower the quality');
          }
        }
        isUploading.value = false;
      }
    }
  }

  askSourceType(BuildContext context) async {
    return await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () =>
                              Navigator.pop(context, ImageSource.camera),
                          child: const MediaSourceButton(
                              iconData: Icons.camera_alt,
                              imageSourceText: 'Camera')),
                      TextButton(
                          onPressed: () =>
                              Navigator.pop(context, ImageSource.gallery),
                          child: const MediaSourceButton(
                              iconData: Icons.image, imageSourceText: 'Galery'))
                    ],
                  )
                ],
              ),
            ));
  }

  saveVideo(Uint8List videoBytes) async {
    String? videoUrl = await FirebaseStorageClient.uploadOnePicture(videoBytes);
    DbVideo video = DbVideo(
        creationTime: DateTime.now().millisecondsSinceEpoch,
        videoUrl: videoUrl,
        location:
            GeoPoint(Global.location!.latitude, Global.location!.longitude));
    await VideoClient.saveVideo(video);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isUploading,
      builder: (context, isUploading, child) {
        if (isUploading == false) {
          return ElevatedButton(
              onPressed: () => shareVideo(),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_a_photo),
                  SizedBox(width: 10),
                  Text("Add weather story")
                ],
              ));
        } else {
          return Column(
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 15),
              Text("Video uploading",
                  style: Theme.of(context).textTheme.labelLarge)
            ],
          );
        }
      },
    );
  }
}
