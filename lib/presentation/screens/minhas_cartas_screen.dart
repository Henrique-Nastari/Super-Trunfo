import 'package:flutter/material.dart' hide Hero;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/my_cards_repository.dart';
// 1. IMPORTAR A NOVA TELA DE DETALHES
import 'package:super_trunfo/presentation/screens/minha_carta_detail_screen.dart';

class MinhasCartasScreen extends StatefulWidget {
  const MinhasCartasScreen({super.key});

  @override
  State<MinhasCartasScreen> createState() => _MinhasCartasScreenState();
}

class _MinhasCartasScreenState extends State<MinhasCartasScreen> {
  final MyCardsRepository _repository = MyCardsRepository();
  late Future<List<Hero>> _myCardsFuture;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  // 2. SEPARAMOS A LÓGICA DE CARREGAMENTO NESTE MÉTODO
  //    PARA PODERMOS CHAMÁ-LO NOVAMENTE QUANDO UMA CARTA FOR DELETADA
  void _loadCards() {
    setState(() {
      _myCardsFuture = _repository.getMyCards();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Cartas'),
      ),
      body: FutureBuilder<List<Hero>>(
        future: _myCardsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar suas cartas.'));
          }

          final myCards = snapshot.data;
          if (myCards == null || myCards.isEmpty) {
            return const Center(
              child: Text(
                'Você ainda não possui cartas.\nVá ao "Card Diário" para conseguir uma!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.7,
            ),
            itemCount: myCards.length,
            itemBuilder: (context, index) {
              final hero = myCards[index];
              return _buildHeroCard(hero);
            },
          );
        },
      ),
    );
  }

  Widget _buildHeroCard(Hero hero) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: InkWell(
        // 3. ATUALIZAÇÃO DA LÓGICA 'onTap'
        onTap: () async {
          // Navega para a tela de detalhes e ESPERA ELA FECHAR
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MinhaCartaDetailScreen(hero: hero),
            ),
          );

          // 4. SE A TELA VOLTOU COM 'true' (carta abandonada),
          //    ATUALIZAMOS A LISTA!
          if (result == true) {
            _loadCards();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: CachedNetworkImage(
                imageUrl: hero.images.md,
                fit: BoxFit.cover,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                hero.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}