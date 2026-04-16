import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewmodels/app_settings_view_model.dart';
import 'package:untitled1/viewmodels/news_view_model.dart';
import 'package:untitled1/views/detail_screen.dart';
import 'package:untitled1/views/favorites_screen.dart';
import 'package:untitled1/views/settings_screen.dart';
import 'package:untitled1/views/widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> _onMenuSelected(String value) async {
    if (value == 'favorites') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const FavoritesScreen()));
      return;
    }

    if (value == 'settings') {
      await Navigator.of(
        context,
      ).push(MaterialPageRoute(builder: (_) => const SettingsScreen()));
      return;
    }

    if (value == 'theme') {
      final settingsVm = context.read<AppSettingsViewModel>();
      settingsVm.toggleDarkMode(!settingsVm.isDarkMode);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsViewModel>().loadInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsViewModel>();
    final theme = Theme.of(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final error = vm.error;
      if (error != null && mounted) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(error)));
        vm.clearError();
      }
    });

    final settingsVm = context.watch<AppSettingsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý tin tức cá nhân'),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Menu',
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'favorites',
                child: ListTile(
                  leading: Icon(Icons.favorite_border),
                  title: Text('Yêu thích'),
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Cài đặt'),
                ),
              ),
              PopupMenuItem(
                value: 'theme',
                child: ListTile(
                  leading: Icon(
                    settingsVm.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  ),
                  title: Text(
                    settingsVm.isDarkMode
                        ? 'Chuyển sang sáng'
                        : 'Chuyển sang tối',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
            child: TextField(
              onChanged: vm.updateSearch,
              decoration: const InputDecoration(
                hintText: 'Tìm kiếm theo tiêu đề...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 52,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection: Axis.horizontal,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 8,
                  ),
                  child: ChoiceChip(
                    label: const Text('Tất cả'),
                    selected: vm.selectedCategoryId == null,
                    onSelected: (_) => vm.filterByCategory(null),
                    avatar: vm.selectedCategoryId == null
                        ? const Icon(Icons.check, size: 16)
                        : null,
                  ),
                ),
                ...vm.categories.map(
                  (category) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                    child: ChoiceChip(
                      label: Text(category.title),
                      selected: vm.selectedCategoryId == category.id,
                      onSelected: (_) => vm.filterByCategory(category.id),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: vm.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: vm.refreshPosts,
                    child: vm.filteredPosts.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 120),
                              Center(
                                child: Text(
                                  'Không có bài viết nào',
                                  style: theme.textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: Text(
                                  'Hãy thử danh mục khác hoặc kéo để tải lại.',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.65),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                            itemCount: vm.filteredPosts.length,
                            itemBuilder: (_, index) {
                              final post = vm.filteredPosts[index];
                              return NewsCard(
                                post: post,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => DetailScreen(post: post),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
          ),
        ],
      ),
    );
  }
}
