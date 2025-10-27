import 'package:flutter/material.dart';

class MinhasCartasScreen extends StatelessWidget {
  const MinhasCartasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Cartas'),
      ),
      body: const Center(
        child: Text('Aqui ficará a sua coleção de cartas!'),
      ),
    );
  }
}