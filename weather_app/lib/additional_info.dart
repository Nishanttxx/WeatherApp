import 'package:flutter/material.dart';

class AdditionalWidgetItem extends StatelessWidget {
  final IconData icon;//we have introduced a constructor so that we can make diffrent widgets from the same codeblock
  final String label;
  final String value;
  const AdditionalWidgetItem({super.key,
  required this.icon,//it is use so tha when ever icon is used it is mandatory to provide its value
  required this.label,
  required this.value
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Icon(icon, size: 32),

       const SizedBox(height: 8),
        Text(label),
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
