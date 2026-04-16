class ApiConstants {
  static const String baseUrl = 'http://chi-tieu.chinhapi.com/api.php';

  static String categoriesUrl() => '$baseUrl?action=categories';

  static String postsUrl() => '$baseUrl?action=posts';

  static String postsByCategoryUrl(String categoryId) =>
      '$baseUrl?action=posts_by_dm&id_dm=$categoryId';
}
