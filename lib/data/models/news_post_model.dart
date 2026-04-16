import 'package:untitled1/core/utils/html_utils.dart';

class NewsPostModel {
  const NewsPostModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.image,
    required this.description,
    required this.categoryName,
    required this.time,
  });

  final String id;
  final String categoryId;
  final String title;
  final String image;
  final String description;
  final String categoryName;
  final DateTime time;

  String get summary {
    final clean = HtmlUtils.stripHtml(description);
    if (clean.length <= 120) return clean;
    return '${clean.substring(0, 120)}...';
  }

  String get imageUrl {
    final normalizedImage = _normalizeUrl(image);
    if (normalizedImage != null) {
      return normalizedImage;
    }

    final extractedFromDescription = _extractFirstImageFromHtml(description);
    if (extractedFromDescription != null) {
      return extractedFromDescription;
    }

    return 'https://placehold.co/800x500/png?text=News+Image';
  }

  factory NewsPostModel.fromJson(
    Map<String, dynamic> json, {
    String? fallbackCategoryId,
  }) {
    final rawTime = json['time']?.toString();
    final parsedTime = DateTime.tryParse(rawTime ?? '');

    return NewsPostModel(
      id: json['id']?.toString() ?? '',
      categoryId: json['id_dm']?.toString() ?? fallbackCategoryId ?? '',
      title: json['title']?.toString() ?? 'Không tiêu đề',
      image: json['image']?.toString() ?? '',
      description: json['des']?.toString() ?? '',
      categoryName: json['ten_dm']?.toString() ?? 'Chưa phân loại',
      time: parsedTime ?? DateTime.now(),
    );
  }

  String? _normalizeUrl(String raw) {
    final normalized = raw.replaceAll('hyphenhyphen', '--').trim();
    if (normalized.startsWith('http://') || normalized.startsWith('https://')) {
      return normalized;
    }
    return null;
  }

  String? _extractFirstImageFromHtml(String html) {
    final regex = RegExp(r'<img[^>]*src="([^"]+)"', caseSensitive: false);
    final match = regex.firstMatch(html);
    if (match == null) return null;

    return _normalizeUrl(match.group(1) ?? '');
  }
}
