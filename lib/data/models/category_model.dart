class CategoryModel {
  const CategoryModel({
    required this.id,
    required this.title,
    required this.status,
  });

  final String id;
  final String title;
  final String status;

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Không tên',
      status: json['status']?.toString() ?? '',
    );
  }
}
