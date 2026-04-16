import 'package:untitled1/data/models/category_model.dart';
import 'package:untitled1/data/models/news_post_model.dart';
import 'package:untitled1/data/services/news_api_service.dart';

class NewsRepository {
  const NewsRepository(this._apiService);

  final NewsApiService _apiService;

  Future<List<CategoryModel>> getCategories() => _apiService.fetchCategories();

  Future<List<NewsPostModel>> getPosts() => _apiService.fetchPosts();

  Future<List<NewsPostModel>> getPostsByCategory(String categoryId) =>
      _apiService.fetchPostsByCategory(categoryId);
}
