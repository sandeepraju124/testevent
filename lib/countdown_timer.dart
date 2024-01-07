import 'package:flutter/material.dart';

class CountdownTimerWidget extends StatelessWidget {
  final Duration timeUntilDob;

  CountdownTimerWidget({required this.timeUntilDob});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Event Timer',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        if (timeUntilDob.inMilliseconds > 0)
          CircularProgressIndicator(
            value:
                1.0 - timeUntilDob.inMilliseconds / timeUntilDob.inMilliseconds,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 10,
          ),
        SizedBox(height: 16),
        Text(
          'Time remaining:',
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 8),
        if (timeUntilDob.inMilliseconds > 0)
          Text(
            '${timeUntilDob.inDays} days, ${timeUntilDob.inHours % 24} hours, ${timeUntilDob.inMinutes % 60} minutes',
            style: TextStyle(fontSize: 16),
          )
        else
          Text(
            'Congratulations! It\'s time to celebrate!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
      ],
    );
  }
}
