import 'package:flutter/material.dart';
import 'package:untitled1/data/models/category_model.dart';
import 'package:untitled1/data/models/news_post_model.dart';
import 'package:untitled1/data/repositories/news_repository.dart';

class NewsViewModel extends ChangeNotifier {
  NewsViewModel(this._repository);

  final NewsRepository _repository;

  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';
  String? _selectedCategoryId;

  List<CategoryModel> _categories = <CategoryModel>[];
  List<NewsPostModel> _posts = <NewsPostModel>[];
  final List<NewsPostModel> _favorites = <NewsPostModel>[];

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CategoryModel> get categories => _categories;
  List<NewsPostModel> get favorites =>
      List<NewsPostModel>.unmodifiable(_favorites);
  String? get selectedCategoryId => _selectedCategoryId;

  List<NewsPostModel> get filteredPosts {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return _posts;

    return _posts
        .where((post) => post.title.toLowerCase().contains(query))
        .toList();
  }

  Future<void> loadInitialData() async {
    _setLoading(true);
    _error = null;

    try {
      final categories = await _repository.getCategories();
      _categories = categories
          .where((item) => item.status.toLowerCase() != 'an')
          .toList();

      _posts = await _repository.getPosts();
    } catch (_) {
      _error = 'Khong the tai du lieu. Vui long kiem tra mang va thu lai.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshPosts() async {
    try {
      if (_selectedCategoryId == null) {
        _posts = await _repository.getPosts();
      } else {
        _posts = await _repository.getPostsByCategory(_selectedCategoryId!);
      }
      _error = null;
    } catch (_) {
      _error = 'Lam moi that bai. Vui long thu lai.';
    }
    notifyListeners();
  }

  Future<void> filterByCategory(String? categoryId) async {
    _selectedCategoryId = categoryId;
    _setLoading(true);

    try {
      if (categoryId == null) {
        _posts = await _repository.getPosts();
      } else {
        _posts = await _repository.getPostsByCategory(categoryId);
      }
      _error = null;
    } catch (_) {
      _error = 'Khong tai duoc bai viet theo danh muc.';
    } finally {
      _setLoading(false);
    }
  }

  void updateSearch(String value) {
    _searchQuery = value;
    notifyListeners();
  }

  bool isFavorite(NewsPostModel post) =>
      _favorites.any((item) => item.id == post.id);

  void toggleFavorite(NewsPostModel post) {
    final index = _favorites.indexWhere((item) => item.id == post.id);
    if (index >= 0) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(post);
    }
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
