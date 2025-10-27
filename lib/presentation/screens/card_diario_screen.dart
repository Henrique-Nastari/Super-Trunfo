import 'package:flutter/material.dart';

class CardDiarioScreen extends StatelessWidget {
  const CardDiarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Diário'),
      ),
      body: const Center(
        child: Text('Aqui você receberá seu card diário!'),
      ),
    );
  }
}