import 'package:flutter/material.dart';
import 'package:super_trunfo/presentation/screens/herois_screen.dart';
import 'package:super_trunfo/presentation/screens/card_diario_screen.dart';
import 'package:super_trunfo/presentation/screens/minhas_cartas_screen.dart';
import 'package:super_trunfo/presentation/screens/batalhar_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Puxa o tema de texto definido no seu M3 Theme
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Super Trunfo Heróis'),
        centerTitle: true,
      ),
      // Adiciona um padding para não colar nas bordas
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          // Centraliza os botões na tela
          mainAxisAlignment: MainAxisAlignment.center,
          // Faz os botões esticarem na largura máxima
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Botão 1: Heróis
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: textTheme.titleMedium, // Estilo do M3
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HeroisScreen()),
                );
              },
              child: const Text('Heróis'),
            ),
            const SizedBox(height: 20), // Espaçamento

            // Botão 2: Card Diário
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: textTheme.titleMedium,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CardDiarioScreen()),
                );
              },
              child: const Text('Card Diário'),
            ),
            const SizedBox(height: 20),

            // Botão 3: Minhas Cartas
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: textTheme.titleMedium,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MinhasCartasScreen()),
                );
              },
              child: const Text('Minhas Cartas'),
            ),
            const SizedBox(height: 20),

            // Botão 4: Batalhar
            FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: textTheme.titleMedium,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BatalharScreen()),
                );
              },
              child: const Text('Batalhar'),
            ),
          ],
        ),
      ),
    );
  }
}