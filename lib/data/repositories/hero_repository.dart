import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:super_trunfo/data/models/hero.dart';
// 1. (NOVO) Precisamos do SharedPreferences para saber se já baixamos tudo
import 'package:shared_preferences/shared_preferences.dart';

class HeroRepository {
  // ATENÇÃO: Verifique o IP (10.0.2.2 ou o IP do seu PC)
  final String _baseUrl = "http://10.0.2.2:3000/heroes";
  final String _hiveBoxName = "heroesBox";
  // (NOVO) Chave para o SharedPreferences
  static const String _syncFlagKey = 'hasFullHeroCache';

  /// 2. (NOVO) MÉTODO PRINCIPAL
  /// Garante que o cache do Hive esteja cheio com TODOS os heróis.
  /// Só roda o download da API uma vez.
  Future<void> _syncAllHeroesToCache() async {
    final prefs = await SharedPreferences.getInstance();
    final bool hasFullCache = prefs.getBool(_syncFlagKey) ?? false;

    // Se já temos o cache completo, não faz mais nada.
    if (hasFullCache) {
      print("Cache completo já existe. Ignorando sync da API.");
      return;
    }

    print("Cache completo não encontrado. Baixando TODOS os heróis da API...");
    try {
      // 3. (NOVO) Chamamos a API SEM paginação
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        // O servidor quebrado nos envia a Página 1.
        // Se a Página 1 contiver o array [[...]], corrigimos aqui.
        // Se a Página 1 contiver o array [...], isto funciona.

        dynamic jsonData = jsonDecode(response.body);

        // 4. (NOVO) SUPER CORREÇÃO: Verificamos se o JSON veio como [ [...] ]
        if (jsonData is List && jsonData.isNotEmpty && jsonData[0] is List) {
          print("Detectado 'array dentro de array'. Corrigindo...");
          jsonData = jsonData[0]; // Extraímos o array interno
        }

        if (jsonData is! List) {
          throw Exception("Os dados da API não são uma lista.");
        }

        final List<Hero> heroes = jsonData.map((data) => Hero.fromJson(data)).toList();

        // 5. (NOVO) Salvamos TODOS os 700+ heróis no cache
        await _saveHeroesToCache(heroes);

        // 6. (NOVO) Marcamos no SharedPreferences que o download foi feito
        await prefs.setBool(_syncFlagKey, true);
        print("Sync de ${heroes.length} heróis concluído.");

      } else {
        throw Exception('Falha ao baixar todos os heróis');
      }
    } catch (e) {
      print("Erro em _syncAllHeroesToCache: $e");
      // Se falhar, tentamos ler o que quer que esteja no cache
      // E *não* marcamos como 'sincronizado'
      await prefs.setBool(_syncFlagKey, false);
      throw Exception('Falha ao sincronizar: $e');
    }
  }

  /// 7. (ATUALIZADO) getHeroesPage agora é o "chefe"
  /// Ele garante que o sync aconteceu e DEPOIS pagina do cache.
  Future<List<Hero>> getHeroesPage(int page, int limit) async {
    try {
      // 8. (NOVO) Na primeira página, garantimos que o cache está cheio
      if (page == 1) {
        await _syncAllHeroesToCache();
      }

      // 9. (NOVO) Agora, lemos do cache de forma paginada
      return _getHeroesFromCachePaginated(page, limit);

    } catch (e) {
      print("Erro em getHeroesPage: $e. Tentando ler do cache...");
      // Se o sync falhar, pelo menos tentamos ler o que está no cache
      return _getHeroesFromCachePaginated(page, limit);
    }
  }

  /// 10. (NOVO) Este método pagina os dados do CACHE
  Future<List<Hero>> _getHeroesFromCachePaginated(int page, int limit) async {
    final box = await Hive.openBox<Hero>(_hiveBoxName);
    final allHeroes = box.values.toList();

    final startIndex = (page - 1) * limit;

    // Verifica se o índice inicial está fora dos limites
    if (startIndex >= allHeroes.length) {
      return []; // Não há mais itens
    }

    final endIndex = (startIndex + limit > allHeroes.length)
        ? allHeroes.length // Se for a última página
        : startIndex + limit; // Senão, o fim da página

    return allHeroes.sublist(startIndex, endIndex);
  }

  // --- MÉTODOS ANTIGOS QUE AINDA USAMOS ---

  /// Salva uma lista de heróis no Box do Hive (sobrescreve)
  Future<void> _saveHeroesToCache(List<Hero> heroes) async {
    final box = await Hive.openBox<Hero>(_hiveBoxName);
    // Limpamos a caixa antes de um sync total
    await box.clear();
    Map<dynamic, Hero> heroMap = { for (var hero in heroes) hero.id : hero };
    await box.putAll(heroMap);
  }

  /// Lê TODOS os heróis salvos no Box do Hive (para CPU e Card Diário)
  Future<List<Hero>> getHeroesFromCache() async {
    final box = await Hive.openBox<Hero>(_hiveBoxName);
    return box.values.toList();
  }

  /// Busca um ÚNICO herói do cache do Hive usando o seu ID.
  Future<Hero?> getHeroByIdFromCache(int id) async {
    try {
      final box = await Hive.openBox<Hero>(_hiveBoxName);
      return box.get(id);
    } catch (e) {
      print("Erro ao buscar herói $id do cache: $e");
      return null;
    }
  }

  /// Busca 15 cartas aleatórias do cache para ser o baralho da CPU.
  Future<List<Hero>> getCpuDeck(int deckSize) async {
    try {
      final allHeroes = await getHeroesFromCache();
      if (allHeroes.length < deckSize) {
        throw Exception("Cache de heróis insuficiente para a CPU.");
      }
      allHeroes.shuffle(Random());
      return allHeroes.sublist(0, deckSize);
    } catch (e) {
      print("Erro ao criar baralho da CPU: $e");
      return [];
    }
  }
}