import 'package:flutter/material.dart' hide Hero;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/my_cards_repository.dart';

// 1. (NOVO) Enum para sabermos qual botão foi pressionado
enum RoundResult { win, draw, loss }

class BatalharScreen extends StatefulWidget {
  const BatalharScreen({super.key});

  @override
  State<BatalharScreen> createState() => _BatalharScreenState();
}

class _BatalharScreenState extends State<BatalharScreen> {
  // Repositório e lógica de Deck (igual)
  final MyCardsRepository _repository = MyCardsRepository();
  late Future<List<Hero>> _deckFuture;
  List<Hero> _shuffledDeck = [];
  int _currentIndex = 0;
  bool _isGameOver = false;

  // 2. (NOVO) Variáveis de Placar
  int _playerWins = 0;
  int _playerDraws = 0;
  int _playerLosses = 0;

  @override
  void initState() {
    super.initState();
    _deckFuture = _loadAndShuffleDeck();
  }

  Future<List<Hero>> _loadAndShuffleDeck() async {
    final myCards = await _repository.getMyCards();
    myCards.shuffle();
    _shuffledDeck = myCards;
    return myCards;
  }

  // 3. (ATUALIZADO) Lógica que registra o resultado da rodada
  void _recordRound(RoundResult result) {
    setState(() {
      // 3a. Incrementa o placar
      switch (result) {
        case RoundResult.win:
          _playerWins++;
          break;
        case RoundResult.draw:
          _playerDraws++;
          break;
        case RoundResult.loss:
          _playerLosses++;
          break;
      }

      // 3b. Verifica se o jogo acabou
      if (_currentIndex < _shuffledDeck.length - 1) {
        _currentIndex++;
      } else {
        _isGameOver = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batalhar'),
      ),
      body: FutureBuilder<List<Hero>>(
        future: _deckFuture,
        builder: (context, snapshot) {
          // --- (Estados de Carregando e Erro - Iguais) ---
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar seu baralho.'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Você precisa de cartas na sua coleção para batalhar!\nAdicione no "Card Diário".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // 4. (ATUALIZADO) Tela de Fim de Jogo
          if (_isGameOver) {
            return _buildGameOverScreen(); // Chama o novo widget de Fim de Jogo
          }

          // --- Estado: Jogo em Andamento ---
          final hero = _shuffledDeck[_currentIndex];
          final totalRounds = _shuffledDeck.length;

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 5. (NOVO) Placar atual
                Text(
                  "Placar: V $_playerWins | E $_playerDraws | D $_playerLosses",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                // Contador de Rodada
                Text(
                  "Rodada ${_currentIndex + 1} de $totalRounds",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // O Card do Super Trunfo
                Expanded(
                  child: _buildHeroCard(hero, context),
                ),

                const SizedBox(height: 24),

                // 6. (ATUALIZADO) Botões de resultado
                _buildButtonRow(),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- Widgets Auxiliares ---

  /// 7. (NOVO) Constói a linha de botões
  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Botão Derrota
        ElevatedButton.icon(
          icon: const Icon(Icons.thumb_down),
          label: const Text('Derrota'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade100, foregroundColor: Colors.red.shade800),
          onPressed: () => _recordRound(RoundResult.loss),
        ),
        // Botão Empate
        ElevatedButton.icon(
          icon: const Icon(Icons.pause),
          label: const Text('Empate'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade300, foregroundColor: Colors.black54),
          onPressed: () => _recordRound(RoundResult.draw),
        ),
        // Botão Vitória
        ElevatedButton.icon(
          icon: const Icon(Icons.thumb_up),
          label: const Text('Vitória'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade100, foregroundColor: Colors.green.shade800),
          onPressed: () => _recordRound(RoundResult.win),
        ),
      ],
    );
  }

  /// 8. (NOVO) Constói a tela de Fim de Jogo
  Widget _buildGameOverScreen() {
    // Calcula o resultado final
    String title;
    String subtitle;
    Color color;
    IconData icon;

    if (_playerWins > _playerLosses) {
      title = "🎉 Você Venceu! 🎉";
      subtitle = "Parabéns, você é o campeão!";
      color = Colors.green.shade700;
      icon = Icons.emoji_events;
    } else if (_playerLosses > _playerWins) {
      title = "Você Perdeu...";
      subtitle = "Mais sorte na próxima vez!";
      color = Colors.red.shade700;
      icon = Icons.sentiment_dissatisfied;
    } else {
      title = "Jogo Empatado!";
      subtitle = "Uma batalha acirrada!";
      color = Colors.blueGrey.shade700;
      icon = Icons.handshake;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: color),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 10),
          Text(subtitle, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 30),
          Text(
            "Placar Final",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            "$_playerWins Vitórias | $_playerDraws Empates | $_playerLosses Derrotas",
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Volta ao Menu
            },
            child: const Text('Voltar ao Menu'),
          )
        ],
      ),
    );
  }

  /// Constroi o Card do Super Trunfo (Idêntico ao anterior)
  Widget _buildHeroCard(Hero hero, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CachedNetworkImage(
              imageUrl: hero.images.md,
              height: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                hero.name,
                textAlign: TextAlign.center,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildStatRow('Inteligência', hero.powerstats.intelligence),
                  _buildStatRow('Força', hero.powerstats.strength),
                  _buildStatRow('Velocidade', hero.powerstats.speed),
                  _buildStatRow('Resistência', hero.powerstats.durability),
                  _buildStatRow('Poder', hero.powerstats.power),
                  _buildStatRow('Combate', hero.powerstats.combat),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Constroi uma linha de stat (Idêntico ao anterior)
  Widget _buildStatRow(String name, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Text(value.toString(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}