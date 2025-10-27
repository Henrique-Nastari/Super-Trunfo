import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:super_trunfo/data/models/hero.dart';

class HeroRepository {
  // ATENÇÃO: Use '10.0.2.2' para emulador Android
  // Use 'localhost' para web/desktop
  // Use o IP da sua máquina (ex: 192.168.1.5) para celular físico
  final String _baseUrl = "http://10.0.2.2:3000/heroes";
  final String _hiveBoxName = "heroesBox";

  /// Busca uma PÁGINA de heróis da API.
  /// Se a API falhar na primeira página, tenta carregar do cache.
  Future<List<Hero>> getHeroesPage(int page, int limit) async {
    try {
      // 1. Tenta buscar da API com paginação
      // json-server usa _page e _limit
      final response = await http.get(
        Uri.parse('$_baseUrl?_page=$page&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Hero> heroes = jsonData.map((data) => Hero.fromJson(data)).toList();

        // 2. Salva a página recém-buscada no cache
        await _saveHeroesToCache(heroes);

        return heroes;
      } else {
        // 3. Erro de API (404, 500...)
        throw Exception('Falha ao carregar dados da API');
      }
    } catch (e) {
      // 4. Erro de rede (sem internet)
      print("Erro de rede/API: $e");

      // Lógica de fallback para o cache (requisito do app)
      // Se for a primeira página e a rede falhar, carregamos do cache.
      if (page == 1) {
        print("Carregando do cache...");
        return _getHeroesFromCache();
      } else {
        // Se falhar em páginas seguintes (2, 3...), lançamos o erro
        // para o PagingController mostrar o erro na lista.
        throw Exception('Sem internet para carregar mais heróis.');
      }
    }
  }

  /// Salva uma lista de heróis no Box do Hive (sobrescrevendo os existentes)
  Future<void> _saveHeroesToCache(List<Hero> heroes) async {
    final box = await Hive.openBox<Hero>(_hiveBoxName);
    Map<dynamic, Hero> heroMap = { for (var hero in heroes) hero.id : hero };
    await box.putAll(heroMap);
  }

  /// Lê TODOS os heróis salvos no Box do Hive
  Future<List<Hero>> _getHeroesFromCache() async {
    final box = await Hive.openBox<Hero>(_hiveBoxName);
    return box.values.toList();
  }
}