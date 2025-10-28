import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/hero_repository.dart';

// 1. Enum para sabermos o que a UI deve fazer
enum DailyCardStatus {
  /// Um novo herói foi sorteado hoje.
  newCard,
  /// O utilizador já resgatou o herói de hoje.
  alreadyClaimed,
}

// 2. Classe de Resultado para enviar para a UI
class DailyCardResult {
  final DailyCardStatus status;
  final Hero? hero;
  final String? message; // Para casos de erro

  DailyCardResult({required this.status, this.hero, this.message});
}

class DailyCardService {
  final HeroRepository _heroRepository = HeroRepository();
  static const _dateKey = 'dailyCardDate';
  static const _heroIdKey = 'dailyCardHeroId';

  /// Retorna o card diário.
  /// Verifica se já foi resgatado hoje e retorna o card (novo ou antigo).
  Future<DailyCardResult> getDailyCard() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final String today = _getTodayDateString();
      final String? lastDrawDate = prefs.getString(_dateKey);

      if (lastDrawDate == today) {
        // JÁ RESGATOU HOJE
        print("Já resgatou o card de hoje. Buscando do cache...");
        final int? heroId = prefs.getInt(_heroIdKey);

        if (heroId == null) {
          // Isto é um estado de erro (data guardada mas ID não), vamos sortear de novo
          return _drawNewHero(prefs, today);
        }

        final hero = await _heroRepository.getHeroByIdFromCache(heroId);

        if (hero == null) {
          // Outro estado de erro (herói não encontrado no cache), sortear de novo
          return _drawNewHero(prefs, today);
        }

        return DailyCardResult(status: DailyCardStatus.alreadyClaimed, hero: hero);

      } else {
        // NOVO DIA. SORTEAR NOVO HERÓI
        print("Novo dia. Sorteando novo herói...");
        return _drawNewHero(prefs, today);
      }
    } catch (e) {
      return DailyCardResult(
        status: DailyCardStatus.alreadyClaimed,
        message: "Erro: $e. Tente novamente mais tarde.",
      );
    }
  }

  /// sortear um novo herói
  Future<DailyCardResult> _drawNewHero(SharedPreferences prefs, String today) async {
    // 1. Buscar todos os heróis do cache
    final List<Hero> allHeroes = await _heroRepository.getHeroesFromCache();

    if (allHeroes.isEmpty) {
      return DailyCardResult(
        status: DailyCardStatus.alreadyClaimed,
        message: "Erro: A sua cache de heróis está vazia. Por favor, visite a tela 'Heróis' primeiro para carregar os dados.",
      );
    }

    // 2. Sortear um herói
    final random = Random();
    final Hero randomHero = allHeroes[random.nextInt(allHeroes.length)];

    // 3. Guardar o resultado
    await prefs.setString(_dateKey, today);
    await prefs.setInt(_heroIdKey, randomHero.id);

    return DailyCardResult(status: DailyCardStatus.newCard, hero: randomHero);
  }

  /// Retorna a data de hoje no formato YYYY-MM-DD
  String _getTodayDateString() {
    return DateTime.now().toIso8601String().substring(0, 10);
  }
}