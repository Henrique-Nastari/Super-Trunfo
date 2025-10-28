import 'package:flutter/material.dart' hide Hero;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/my_cards_repository.dart';
import 'package:super_trunfo/services/daily_card_service.dart';

class CardDiarioScreen extends StatefulWidget {
  const CardDiarioScreen({super.key});

  @override
  State<CardDiarioScreen> createState() => _CardDiarioScreenState();
}

class _CardDiarioScreenState extends State<CardDiarioScreen> {
  // 1. Serviços e Repositórios
  final DailyCardService _service = DailyCardService();
  final MyCardsRepository _myCardsRepo = MyCardsRepository();

  // 2. Controladores de Estado
  late Future<DailyCardResult> _cardFuture;
  bool _isAdding = false; // Para o loading do botão
  String? _addMessage; // Mensagem de feedback ("Adicionado!" ou "Cheio!")

  @override
  void initState() {
    super.initState();
    // 3. Busca o card assim que a tela abre
    _cardFuture = _service.getDailyCard();
  }

  /// Chamado quando o botão "Adicionar" é pressionado
  Future<void> _onAddCard(Hero hero) async {
    setState(() { _isAdding = true; });

    final success = await _myCardsRepo.addCard(hero);

    setState(() {
      _isAdding = false;
      _addMessage = success
          ? "Adicionado à sua coleção!"
          : "Sua coleção está cheia (15/15)!";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Diário'),
      ),
      // 4. FutureBuilder para lidar com a lógica assíncrona
      body: FutureBuilder<DailyCardResult>(
        future: _cardFuture,
        builder: (context, snapshot) {
          // Estado: Carregando
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Estado: Erro (ex: cache vazio, falha no SharedPreferences)
          if (snapshot.hasError || !snapshot.hasData) {
            return Center(child: Text("Erro: ${snapshot.error ?? 'Falha ao carregar'}"));
          }

          // Estado: Sucesso
          final result = snapshot.data!;
          final hero = result.hero;

          // Se o serviço retornou uma mensagem de erro (ex: cache vazio)
          if (hero == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(result.message ?? "Herói não encontrado.", textAlign: TextAlign.center),
              ),
            );
          }

          // 5. Se temos um herói, construímos a tela
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Seu Card de Hoje:",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                // O CARD DO HERÓI
                _buildHeroCard(hero, context),

                const Spacer(), // Empurra o botão para baixo

                // O BOTÃO E AS MENSAGENS DE FEEDBACK
                _buildButtonArea(result),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Constroi a área do botão e mensagens
  Widget _buildButtonArea(DailyCardResult result) {
    // 1. Se a mensagem de feedback já apareceu ("Adicionado!" ou "Cheio!")
    if (_addMessage != null) {
      return Text(_addMessage!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.blue));
    }

    // 2. Se o utilizador já resgatou o card hoje
    if (result.status == DailyCardStatus.alreadyClaimed) {
      return const Text(
        "Você já resgatou seu card hoje. Volte amanhã!",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey),
      );
    }

    // 3. Se é um novo card e ainda não foi adicionado
    return FilledButton(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      // Desativa o botão enquanto estiver a adicionar
      onPressed: _isAdding ? null : () => _onAddCard(result.hero!),
      child: _isAdding
          ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
          : const Text('Adicionar à Biblioteca'),
    );
  }

  /// Constroi o Card do Super Trunfo (requisito)
  Widget _buildHeroCard(Hero hero, BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 4,
      clipBehavior: Clip.antiAlias, // Para a imagem não vazar das bordas
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. IMAGEM
          CachedNetworkImage(
            imageUrl: hero.images.md, // Imagem média
            height: 250,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
          ),

          // 2. NOME
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              hero.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),

          // 3. POWERSTATS
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
    );
  }

  /// Constroi uma linha de stat (Ex: "Força: 100")
  Widget _buildStatRow(String name, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
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