import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:untitled1/core/constants/api_constants.dart';
import 'package:untitled1/data/models/category_model.dart';
import 'package:untitled1/data/models/news_post_model.dart';

class NewsApiService {
  const NewsApiService();

  Future<List<CategoryModel>> fetchCategories() async {
    final response = await http.get(Uri.parse(ApiConstants.categoriesUrl()));
    final data = _decodeResponse(response);
    final categories = (data['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(CategoryModel.fromJson)
        .toList();

    return categories;
  }

  Future<List<NewsPostModel>> fetchPosts() async {
    final response = await http.get(Uri.parse(ApiConstants.postsUrl()));
    final data = _decodeResponse(response);
    final posts = (data['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(NewsPostModel.fromJson)
        .toList();

    return posts;
  }

  Future<List<NewsPostModel>> fetchPostsByCategory(String categoryId) async {
    final response = await http.get(
      Uri.parse(ApiConstants.postsByCategoryUrl(categoryId)),
    );
    final data = _decodeResponse(response);
    final posts = (data['data'] as List<dynamic>? ?? <dynamic>[])
        .cast<Map<String, dynamic>>()
        .map(
          (json) =>
              NewsPostModel.fromJson(json, fallbackCategoryId: categoryId),
        )
        .toList();

    return posts;
  }

  Map<String, dynamic> _decodeResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Loi API: ${response.statusCode}');
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    if (decoded['success'] != true) {
      throw Exception('API tra ve that bai');
    }

    return decoded;
  }
}
