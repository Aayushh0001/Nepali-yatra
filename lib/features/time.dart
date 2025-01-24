import 'package:flutter/material.dart';
import 'dart:async';
import 'national_details_page.dart';

class HeaderWidget extends StatefulWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  String _currentTime = '';
  String _currentDate = '';

  @override
  void initState() {
    super.initState();
    _updateTimeAndDate();
  }

  void _updateTimeAndDate() {
    _currentTime = _getCurrentTime();
    _currentDate = _getCurrentDate();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _currentTime = _getCurrentTime();
          _currentDate = _getCurrentDate();
        });
      }
    });
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = _getNepaliPeriod(now.hour);

    return '${_convertToNepaliNumber(hour.toString())}:${_convertToNepaliNumber(
        minute)} $period';
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    final day = _convertToNepaliNumber(now.day.toString());
    final month = _getNepaliMonth(now.month);
    final year = _convertToNepaliNumber(now.year.toString());

    return '$day $month, $year';
  }

  String _getNepaliPeriod(int hour) {
    if (hour >= 4 && hour < 12) {
      return 'बिहानी'; // Morning
    } else if (hour >= 12 && hour < 16) {
      return 'दिउँसो'; // Afternoon
    } else if (hour >= 16 && hour < 19) {
      return 'साँझ'; // Evening
    } else {
      return 'बेलुकी'; // Night
    }
  }

  String _getNepaliMonth(int month) {
    const nepaliMonths = [
      'जनवरी',
      'फेब्रुअरी',
      'मार्च',
      'अप्रिल',
      'मे',
      'जुन',
      'जुलाई',
      'अगस्त',
      'सेप्टेम्बर',
      'अक्टोबर',
      'नोभेम्बर',
      'डिसेम्बर',
    ];
    return nepaliMonths[month - 1];
  }

  String _convertToNepaliNumber(String englishNumber) {
    const englishToNepaliDigits = {
      '0': '०',
      '1': '१',
      '2': '२',
      '3': '३',
      '4': '४',
      '5': '५',
      '6': '६',
      '7': '७',
      '8': '८',
      '9': '९',
    };

    return englishNumber.split('').map((char) {
      return englishToNepaliDigits[char] ?? char;
    }).join();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NationalDetailsPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/nepali_flag.jpg',
              width: 50,
              height: 50,
              fit: BoxFit.contain,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // English Time
                Text(
                  _getCurrentEnglishTime(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _currentTime,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _currentDate,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  String _getCurrentEnglishTime() {
    final now = DateTime.now();
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour >= 12 ? 'PM' : 'AM';

    return '$hour:$minute $period';
  }
}
