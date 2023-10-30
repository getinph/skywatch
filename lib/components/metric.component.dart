import 'package:flutter/material.dart';

class Metric extends StatelessWidget {
  const Metric(
      {super.key,
      required this.iconData,
      required this.value,
      required this.unit});

  final IconData iconData;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Icon(iconData),
      const SizedBox(height: 5),
      Text(value, style: Theme.of(context).textTheme.labelLarge),
      Text('($unit)', style: Theme.of(context).textTheme.bodySmall)
    ]);
  }
}
