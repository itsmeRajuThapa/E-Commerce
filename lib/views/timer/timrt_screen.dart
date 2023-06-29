import 'package:emart_user/consts/colors.dart';
import 'package:flutter/material.dart';
import '../../consts/firebase_consts.dart';

class TimerControlScreen extends StatefulWidget {
  const TimerControlScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TimerControlScreenState createState() => _TimerControlScreenState();
}

class _TimerControlScreenState extends State<TimerControlScreen> {
  TextEditingController _controller = TextEditingController();

  void setTimer() {
    int seconds = int.tryParse(_controller.text) ?? 0;
    timerRef.set(seconds); // Set the timer value in Firebase
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: redColor,
      appBar: AppBar(
        title: Text('Timer Control'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Set Timer (seconds)',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: setTimer,
              child: Text('Set Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
