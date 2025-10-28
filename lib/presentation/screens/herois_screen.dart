import 'package:flutter/material.dart' hide Hero;
import 'package:super_trunfo/data/models/hero.dart';
import 'package:super_trunfo/data/repositories/hero_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:super_trunfo/presentation/screens/hero_detail_screen.dart';

class HeroisScreen extends StatefulWidget {
  const HeroisScreen({super.key});

  @override
  State<HeroisScreen> createState() => _HeroisScreenState();
}

class _HeroisScreenState extends State<HeroisScreen> {
  static const _pageSize = 20;
  final HeroRepository _repository = HeroRepository();

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
      body: PagedListView<int, Hero>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<Hero>(
          itemBuilder: (context, hero, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(hero.images.sm),
            ),
            title: Text(hero.name),
            subtitle: Text(
              '${hero.appearance.race} | Poder: ${hero.powerstats.power}',
            ),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HeroDetailScreen(hero: hero),
                ),
              );
            },
          ),

          // Widgets de feedback
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