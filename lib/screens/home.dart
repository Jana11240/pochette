import 'package:bank_card_app/screens/card.dart';
import 'package:bank_card_app/screens/start.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  Widget? screenWidget;

  @override
  void initState() {
    _showStartScreen();
    super.initState();
  }

  void _showStartScreen() {
    setState(() {
      screenWidget = StartScreen(start: _showCardScreen);
    });
  }

  void _showCardScreen() {
    setState(() {
      screenWidget = CardScreen(back: _showStartScreen);
    });
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: screenWidget,
    );
  }
}
