import 'package:hive/hive.dart';
import 'package:super_trunfo/data/models/hero.dart';

class MyCardsRepository {
  final String _boxName = "myCardsBox";

  /// Adiciona um herói à caixa "Minhas Cartas".
  /// Retorna 'true' se foi adicionado com sucesso.
  /// Retorna 'false' se a caixa estiver cheia (limite de 15).
  Future<bool> addCard(Hero hero) async {
    try {
      final box = await Hive.openBox<Hero>(_boxName);

      // Verifica o limite de 15 cartas (requisito)
      if (box.length >= 15) {
        print("A caixa 'myCardsBox' está cheia. Limite de 15 atingido.");
        return false; // Falha (caixa cheia)
      }

      // Adiciona o herói usando o ID como chave (evita duplicados)
      await box.put(hero.id, hero);
      return true; // Sucesso

    } catch (e) {
      print("Erro ao adicionar carta ao 'myCardsBox': $e");
      return false;
    }
  }

  /// Retorna a contagem atual de cartas do utilizador.
  Future<int> getMyCardsCount() async {
    final box = await Hive.openBox<Hero>(_boxName);
    return box.length;
  }

  /// Retorna a lista de todos os heróis salvos na "myCardsBox".
  Future<List<Hero>> getMyCards() async {
    try {
      final box = await Hive.openBox<Hero>(_boxName);
      // box.values retorna todos os itens guardados, que convertemos para Lista
      return box.values.toList();
    } catch (e) {
      print("Erro ao ler 'myCardsBox': $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  /// Remove um herói específico da "myCardsBox" usando o ID.
  Future<void> removeCard(int heroId) async {
    try {
      final box = await Hive.openBox<Hero>(_boxName);
      // O metodo .delete() do Hive remove o item pela chave
      await box.delete(heroId);
    } catch (e) {
      print("Erro ao remover carta $heroId do 'myCardsBox': $e");
    }
  }
}