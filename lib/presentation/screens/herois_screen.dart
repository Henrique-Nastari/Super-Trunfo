import 'package:flutter/material.dart' hide Hero;
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/hero_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HeroisScreen extends StatefulWidget {
  const HeroisScreen({super.key});

  @override
  State<HeroisScreen> createState() => _HeroisScreenState();
}

class _HeroisScreenState extends State<HeroisScreen> {
  static const _pageSize = 20;
  final HeroRepository _repository = HeroRepository();

  // Agora 'Hero' refere-se unambiguously ao seu modelo
  final PagingController<int, Hero> _pagingController =
  PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // 'newItems' será 'List<Hero>' (do seu modelo)
      final newItems = await _repository.getHeroesPage(pageKey, _pageSize);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heróis'),
      ),
      // 'Hero' aqui também é o seu modelo
      body: PagedListView<int, Hero>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Hero>(
          itemBuilder: (context, hero, index) => ListTile(
            leading: CircleAvatar(
              // hero.images.sm (agora funciona)
              backgroundImage: CachedNetworkImageProvider(hero.images.sm),
            ),
            // hero.name (agora funciona)
            title: Text(hero.name),
            subtitle: Text(
              // hero.appearance.race (agora funciona)
              // (Removi o '?? N/A' porque seu modelo define 'race' como não-nulo)
              '${hero.appearance.race} | Poder: ${hero.powerstats.power}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // TODO: Navegar para a tela de Detalhes do Herói
              // hero.name (agora funciona)
              print('Selecionou ${hero.name}');
            },
          ),

          firstPageProgressIndicatorBuilder: (context) =>
          const Center(child: CircularProgressIndicator()),

          newPageProgressIndicatorBuilder: (context) => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(strokeWidth: 2),
              )),

          firstPageErrorIndicatorBuilder: (context) => Center(
            child: Text('Erro ao carregar heróis: ${_pagingController.error}'),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}