import 'dart:async';
import 'package:emart_user/consts/consts.dart';
import 'package:flutter/material.dart';

import '../../consts/firebase_consts.dart';

class CountdownTimer extends StatefulWidget {
  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  Duration timerDuration = const Duration();
  Timer? timer;

  @override
  void initState() {
    super.initState();
    timerRef.onValue.listen((event) {
      final data = event.snapshot.value as int?;
      if (data != null) {
        setState(() {
          timerDuration = Duration(seconds: data);
          startTimer();
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer?.cancel();
    if (timerDuration.inSeconds > 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          timerDuration -= const Duration(seconds: 1);
        });

        if (timerDuration.inSeconds <= 0) {
          timer?.cancel();
          timerRef.remove(); // Remove the timer value from Firebase
        }
      });
    }
  }

  String formatTime(Duration duration) {
    String hours = duration.inHours.toString().padLeft(2, '0');
    String minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(
            ' ${formatTime(timerDuration)}',
            style: const TextStyle(fontSize: 72, color: Vx.black),
          ),
        ),
      ),
    );
  }
}
