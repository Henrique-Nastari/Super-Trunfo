import 'package:flutter/material.dart';

class BatalharScreen extends StatelessWidget {
  const BatalharScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batalhar'),
      ),
      body: const Center(
        child: Text('Aqui é onde a batalha acontece!'),
      ),
    );
  }
}