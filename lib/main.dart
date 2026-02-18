import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: DigitalPetApp(),
  ));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  TextEditingController nameController = TextEditingController();

  String petName = "Your Pet";
  int happinessLevel = 50;
  int hungerLevel = 50;

  Timer? hungerTimer;
  Timer? winTimer;
  bool isWinning = false;
  int energyLevel = 80;


  @override
  void initState() {
    super.initState();

    hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) hungerLevel = 100;
        _checkLossCondition();
      });
    });
  }

  @override
  void dispose() {
    hungerTimer?.cancel();
    winTimer?.cancel();
    super.dispose();
  }

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _moodText() {
    if (happinessLevel > 70) {
      return "Happy 😊";
    } else if (happinessLevel >= 30) {
      return "Neutral 😐";
    } else {
      return "Sad 😢";
    }
  }

  void _playWithPet() {
    setState(() {
      happinessLevel += 10;
      energyLevel -= 10;
      if (energyLevel < 0) energyLevel = 0;
      _updateHunger();
      _checkWinCondition();
      _checkLossCondition();
    });
  }

  void _feedPet() {
    setState(() {
      hungerLevel -= 10;
      _updateHappiness();
      _checkWinCondition();
      _checkLossCondition();
    });
  }

  void _updateHappiness() {
    if (hungerLevel < 30) {
      happinessLevel -= 20;
    } else {
      happinessLevel += 10;
    }
  }

  void _updateHunger() {
    hungerLevel += 5;
    if (hungerLevel > 100) {
      hungerLevel = 100;
      happinessLevel -= 20;
    }
  }

  void _checkWinCondition() {
    if (happinessLevel > 80 && !isWinning) {
      isWinning = true;

      winTimer = Timer(Duration(minutes: 3), () {
        _showDialog("You Win!", "Your pet is extremely happy!");
      });
    }

    if (happinessLevel <= 80) {
      isWinning = false;
      winTimer?.cancel();
    }
  }

  void _checkLossCondition() {
    if (hungerLevel >= 100 && happinessLevel <= 10) {
      _showDialog("Game Over", "Your pet is starving and unhappy!");
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Digital Pet'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName', style: TextStyle(fontSize: 20.0)),

            SizedBox(height: 10),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter pet name",
                ),
              ),
            ),

            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  petName = nameController.text;
                });
              },
              child: Text("Set Pet Name"),
            ),

            SizedBox(height: 16.0),

            Text('Happiness Level: $happinessLevel',
                style: TextStyle(fontSize: 20.0)),

            SizedBox(height: 16.0),

            Text('Hunger Level: $hungerLevel',
                style: TextStyle(fontSize: 20.0)),
                SizedBox(height: 10),

            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20)),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: LinearProgressIndicator(
                value: energyLevel / 100,
                minHeight: 10,
              ),
            ),

            SizedBox(height: 32.0),

            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset(
                'assets/pet_image.png',
                width: 200,
                height: 200,
              ),
            ),

            SizedBox(height: 10),

            Text(
              "Mood: ${_moodText()}",
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: _playWithPet,
              child: Text('Play with Your Pet'),
            ),

            SizedBox(height: 16.0),

            ElevatedButton(
              onPressed: _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
