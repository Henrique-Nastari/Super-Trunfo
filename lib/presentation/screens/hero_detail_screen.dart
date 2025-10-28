import 'package:flutter/material.dart' hide Hero;
import 'package:super_trunfo/data/models/hero.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:primer_progress_bar/primer_progress_bar.dart';

class HeroDetailScreen extends StatelessWidget {
  final Hero hero;
  const HeroDetailScreen({super.key, required this.hero});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(hero.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

            // Seção de Powerstats
            _buildSectionCard(
              title: 'Powerstats',
              content: _buildStatsList(hero.powerstats),
            ),

            // Seção de Biografia
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

            // Seção de Aparência
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

            // Seção de Trabalho
            _buildSectionCard(
              title: 'Trabalho',
              content: Column(
                children: [
                  _buildDetailRow('Ocupação', hero.work.occupation),
                  _buildDetailRow('Base', hero.work.base),
                ],
              ),
            ),

            // Seção de Conexões
            _buildSectionCard(
              title: 'Conexões',
              content: Column(
                children: [
                  _buildDetailRow('Afiliação', hero.connections.groupAffiliation),
                  _buildDetailRow('Parentes', hero.connections.relatives),
                ],
              ),
            ),

            const SizedBox(height: 20), // Espaço no final
          ],
        ),
      ),
    );
  }

  /// Widget auxiliar para criar um Card de seção
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

  /// Widget auxiliar para exibir os Powerstats com a barra de progresso
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

  /// Widget auxiliar para exibir uma barra de stat
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

  /// Widget auxiliar para exibir uma linha de detalhe
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