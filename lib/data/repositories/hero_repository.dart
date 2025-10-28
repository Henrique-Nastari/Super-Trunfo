import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart';
import 'package:super_trunfo/data/models/hero.dart';

class HeroRepository {
  final String _baseUrl = "http://10.0.2.2:3000/heroes";
  final String _hiveBoxName = "heroesBox";

  Future<List<Hero>> getHeroesPage(int page, int limit) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?_page=$page&_limit=$limit'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Hero> heroes = jsonData.map((data) => Hero.fromJson(data)).toList();

        await _saveHeroesToCache(heroes);

        return heroes;
      } else {
        throw Exception('Falha ao carregar dados da API');
      }
    } catch (e) {
      print("Erro de rede/API: $e");

      if (page == 1) {
        print("Carregando do cache...");
        // 1. MUDANÇA AQUI (chamando o método público)
        return getHeroesFromCache();
      } else {
        throw Exception('Sem internet para carregar mais heróis.');
      }
    }
  }

  Future<void> _saveHeroesToCache(List<Hero> heroes) async {
    final box = await Hive.openBox<Hero>(_hiveBoxName);
    Map<dynamic, Hero> heroMap = { for (var hero in heroes) hero.id : hero };
    await box.putAll(heroMap);
  }

  // 2. MUDANÇA AQUI (método agora é público, sem '_')
  /// Lê TODOS os heróis salvos no Box do Hive
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
}