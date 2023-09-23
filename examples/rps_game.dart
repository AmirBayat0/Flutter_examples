// ignore_for_file: library_private_types_in_public_api

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

//
// Created by CodeWithFlexZ
// Tutorials on my YouTube
//
//! Instagram
//! @CodeWithFlexZ
//
//? GitHub
//? AmirBayat0
//
//* YouTube
//* Programming with FlexZ
//

void main() => runApp(const RockPaperScissorsApp());

class RockPaperScissorsApp extends StatelessWidget {
  const RockPaperScissorsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RockPaperScissorsPage(),
    );
  }
}

class RockPaperScissorsPage extends StatefulWidget {
  const RockPaperScissorsPage({super.key});

  @override
  _RockPaperScissorsPageState createState() => _RockPaperScissorsPageState();
}

class _RockPaperScissorsPageState extends State<RockPaperScissorsPage> {
  final List<String> choices = ['Rock', 'Paper', 'Scissors'];
  late String playerChoice;
  late String computerChoice;
  late String result;

  @override
  void initState() {
    super.initState();
    playerChoice = '';
    computerChoice = '';
    result = '';
  }

  void playGame(String playerChoice) {
    setState(() {
      this.playerChoice = playerChoice;
      final random = Random();
      computerChoice = choices[random.nextInt(choices.length)];
      result = calculateResult(playerChoice, computerChoice);
    });
  }

  String calculateResult(String playerChoice, String computerChoice) {
    if (playerChoice == computerChoice) {
      return 'It\'s a tie!';
    } else if ((playerChoice == 'Rock' && computerChoice == 'Scissors') ||
        (playerChoice == 'Paper' && computerChoice == 'Rock') ||
        (playerChoice == 'Scissors' && computerChoice == 'Paper')) {
      return 'You win!';
    } else {
      return 'You lose!';
    }
  }

  Color getColor() {
    Color color = Colors.white;
    switch (result) {
      case 'It\'s a tie!':
        color = Colors.white;
      case 'You win!':
        color = Colors.greenAccent;
      case 'You lose!':
        color = Colors.redAccent;
    }
    return color;
  }

  String getLottie() {
    String lottie =
        "https://lottie.host/dfb5a983-7f5e-4391-a841-61d158ec23ae/qDyFZPSO5b.json";
    switch (result) {
      case 'It\'s a tie!':
        lottie =
            "https://lottie.host/dfb5a983-7f5e-4391-a841-61d158ec23ae/qDyFZPSO5b.json";
      case 'You win!':
        lottie =
            "https://lottie.host/d152602e-1e59-4a0a-9d8b-1f8cd5d8393f/OoVpaCw30W.json";
      case 'You lose!':
        lottie =
            "https://lottie.host/dadf9839-3627-4071-b145-60c68caf0fcd/gBlGbhynHn.json";
    }
    return lottie;
  }

  var buttonStyles = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.indigoAccent,
        title: const Text('Rock Paper Scissors'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 56),
            const Text(
              'PLEASE CHOOSE YOUR WEAPON:',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => playGame('Rock'),
                  style: buttonStyles,
                  child: Text(choices[0]),
                ),
                ElevatedButton(
                  onPressed: () => playGame('Paper'),
                  style: buttonStyles,
                  child: Text(choices[1]),
                ),
                ElevatedButton(
                  onPressed: () => playGame('Scissors'),
                  style: buttonStyles,
                  child: Text(choices[2]),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Text(
              'Player: $playerChoice',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 3),
            Text(
              'Computer: $computerChoice',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(height: 26),
            Text(
              'Result:\n$result',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30, color: getColor()),
            ),
            const SizedBox(height: 80),
            Expanded(
              child: Lottie.network(getLottie(), fit: BoxFit.cover),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
