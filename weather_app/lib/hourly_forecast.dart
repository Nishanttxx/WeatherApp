import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temperature;
  const HourlyForecastItem({super.key,
  required this.time,
  required this.icon,
  required this.temperature
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
               maxLines: 1,
            overflow:TextOverflow.ellipsis,
              
            ),
           
            const SizedBox(height: 8),
            Icon(icon),
            Text(temperature),
          ],
        ),
      ),
    );
  }
}
