import 'package:flutter/material.dart';
import 'countdown_timer.dart';

class CountdownDisplayPage extends StatefulWidget {
  final String name;
  final String dob;
  final String gender;

  CountdownDisplayPage({
    required this.name,
    required this.dob,
    required this.gender,
  });

  @override
  _CountdownDisplayPageState createState() => _CountdownDisplayPageState();
}

class _CountdownDisplayPageState extends State<CountdownDisplayPage> {
  late DateTime dob;
  late Duration timeUntilNextBirthday;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilNextBirthday();
  }

  void _calculateTimeUntilNextBirthday() {
    DateTime now = DateTime.now();

    try {
      List<String> dateParts = widget.dob.split('-');
      if (dateParts.length == 3) {
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);

        dob = DateTime(year, month, day);

        DateTime nextBirthday = DateTime(now.year, month, day);
        if (nextBirthday.isBefore(now) || nextBirthday.isAtSameMomentAs(now)) {
          nextBirthday = DateTime(now.year + 1, month, day);
        }

        timeUntilNextBirthday = nextBirthday.difference(now);
      } else {
        print('Invalid date format: ${widget.dob}');
        timeUntilNextBirthday = Duration.zero;
      }
    } catch (e) {
      print('Error parsing date: $e');
      timeUntilNextBirthday = Duration.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Countdown Timer Display'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hello, ${widget.name}!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Date of Birth: ${widget.dob}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            Text(
              'Gender: ${widget.gender}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 32),
            Text("${timeUntilNextBirthday.inDays} Days"),
            // CountdownTimerWidget(timeUntilDob: timeUntilNextBirthday),
            SizedBox(height: 16),
            Text(
              'Next Birthday Age: ${_calculateNextBirthdayAge()}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateNextBirthdayAge() {
    DateTime now = DateTime.now();
    int age = now.year - dob.year;

    DateTime nextBirthday = DateTime(now.year, dob.month, dob.day);
    if (nextBirthday.isBefore(now) || nextBirthday.isAtSameMomentAs(now)) {
      nextBirthday = DateTime(now.year + 1, dob.month, dob.day);
    }

    return '$age';
  }
}
