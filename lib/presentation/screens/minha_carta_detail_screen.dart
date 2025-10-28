import 'package:flutter/material.dart' hide Hero;
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/my_cards_repository.dart'; // Nosso repositório
import 'package:cached_network_image/cached_network_image.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';
import 'package:awesome_dialog/awesome_dialog.dart'; // A nova biblioteca

class MinhaCartaDetailScreen extends StatelessWidget {
  final Hero hero;
  const MinhaCartaDetailScreen({super.key, required this.hero});

  // Método para mostrar o diálogo de confirmação (REQUISITO)
  void _showConfirmationDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Abandonar Herói',
      desc: 'Você tem certeza que quer remover ${hero.name} da sua coleção?',
      btnCancelOnPress: () {
        // Não faz nada, apenas fecha o diálogo
      },
      btnOkOnPress: () {
        // 1. Remove do banco de dados
        final myCardsRepo = MyCardsRepository();
        myCardsRepo.removeCard(hero.id);

        // 2. Fecha a tela de detalhes e "avisa" a tela anterior
        // que a remoção foi sucedida (passando 'true')
        Navigator.pop(context, true);
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(hero.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- A PARTIR DAQUI, É IDÊNTICO AO 'HeroDetailScreen' ---

            // Imagem em Alta Resolução
            CachedNetworkImage(
              imageUrl: hero.images.lg,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(
                height: 300,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                height: 300,
                child: Icon(Icons.error, size: 50),
              ),
            ),
            _buildSectionCard(
              title: 'Powerstats',
              content: _buildStatsList(hero.powerstats),
            ),
            _buildSectionCard(
              title: 'Biografia',
              content: Column(
                children: [
                  _buildDetailRow('Nome Completo', hero.biography.fullName),
                  _buildDetailRow('Apelidos', hero.biography.aliases.join(', ')),
                  _buildDetailRow('Alinhamento', hero.biography.alignment),
                  _buildDetailRow('Editora', hero.biography.publisher),
                  _buildDetailRow('1ª Aparição', hero.biography.firstAppearance),
                ],
              ),
            ),
            _buildSectionCard(
              title: 'Aparência',
              content: Column(
                children: [
                  _buildDetailRow('Gênero', hero.appearance.gender),
                  _buildDetailRow('Raça', hero.appearance.race),
                  _buildDetailRow('Altura', hero.appearance.height.join(' / ')),
                  _buildDetailRow('Peso', hero.appearance.weight.join(' / ')),
                  _buildDetailRow('Cor dos Olhos', hero.appearance.eyeColor),
                  _buildDetailRow('Cor do Cabelo', hero.appearance.hairColor),
                ],
              ),
            ),
            _buildSectionCard(
              title: 'Trabalho',
              content: Column(
                children: [
                  _buildDetailRow('Ocupação', hero.work.occupation),
                  _buildDetailRow('Base', hero.work.base),
                ],
              ),
            ),
            _buildSectionCard(
              title: 'Conexões',
              content: Column(
                children: [
                  _buildDetailRow('Afiliação', hero.connections.groupAffiliation),
                  _buildDetailRow('Parentes', hero.connections.relatives),
                ],
              ),
            ),

            // --- A SEÇÃO NOVA E DIFERENTE COMEÇA AQUI ---

            // Botão "Abandonar" (REQUISITO)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
              child: FilledButton.icon(
                icon: const Icon(Icons.delete_forever),
                label: const Text('Abandonar Carta'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _showConfirmationDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- O RESTO SÃO OS MÉTODOS AUXILIARES IDÊNTICOS ---

  Widget _buildSectionCard({required String title, required Widget content}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 20, thickness: 1),
              content,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsList(Powerstats stats) {
    return Column(
      children: [
        _buildStatRow('Inteligência', stats.intelligence),
        _buildStatRow('Força', stats.strength),
        _buildStatRow('Velocidade', stats.speed),
        _buildStatRow('Resistência', stats.durability),
        _buildStatRow('Poder', stats.power),
        _buildStatRow('Combate', stats.combat),
      ],
    );
  }

  Widget _buildStatRow(String name, int value) {
    final Color color;
    if (value < 40) {
      color = Colors.red;
    } else if (value < 70) {
      color = Colors.orange;
    } else {
      color = Colors.green;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$name ($value)', style: const TextStyle(fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          PrimerProgressBar(
            segments: [
              Segment(value: value, color: color),
              Segment(value: 100 - value, color: Colors.grey.shade300),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    if (value.isEmpty || value == 'N/A' || value.trim() == '-') return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }
}