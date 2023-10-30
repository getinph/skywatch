import 'package:flutter/material.dart';

class MediaSourceButton extends StatelessWidget {
  const MediaSourceButton(
      {super.key, required this.iconData, required this.imageSourceText});

  final IconData iconData;
  final String imageSourceText;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(iconData, size: 60),
      const SizedBox(
        height: 10,
      ),
      Text(imageSourceText)
    ]);
  }
}
