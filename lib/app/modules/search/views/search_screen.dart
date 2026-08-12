import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gameder/constants/app_colors.dart';
import 'package:gameder/app/data/models/category_model.dart';
import 'package:gameder/app/routing/topic_navigator.dart';
import 'package:gameder/widgets/responsive_category_grid.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final results = query.isEmpty
        ? const <GameCategory>[]
        : allTopics
            .where(
              (topic) => topic.displayTitle.toLowerCase().contains(query),
            )
            .toList();

    return Scaffold(
      backgroundColor: kAppBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _controller,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: 'search_hint'.tr,
            hintStyle: const TextStyle(color: Colors.white54),
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
      ),
      body: SafeArea(
        child: query.isEmpty
            ? const _SearchHint()
            : results.isEmpty
                ? const _NoResults()
                : ResponsiveCategoryGrid(categories: results, onCardTap: openTopic),
      ),
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'search_promptHint'.tr,
        style: const TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  const _NoResults();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'search_noResults'.tr,
        style: const TextStyle(color: Colors.white54, fontSize: 16),
      ),
    );
  }
}
