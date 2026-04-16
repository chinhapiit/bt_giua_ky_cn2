import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/core/utils/html_utils.dart';
import 'package:untitled1/data/models/news_post_model.dart';
import 'package:untitled1/viewmodels/news_view_model.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.post});

  final NewsPostModel post;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NewsViewModel>();
    final isFavorite = vm.isFavorite(post);
    final date = DateFormat('dd/MM/yyyy HH:mm').format(post.time);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết tin tức')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              post.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
              errorBuilder: (_, error, stackTrace) => Container(
                width: double.infinity,
                height: 250,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.image_not_supported_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(post.categoryName),
                      const SizedBox(width: 14),
                      Icon(
                        Icons.schedule_outlined,
                        size: 16,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.55,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        date,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.65,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Text(
                    HtmlUtils.stripHtml(post.description),
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.65),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => vm.toggleFavorite(post),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                      ),
                      label: Text(isFavorite ? 'Bỏ yêu thích' : 'Yêu thích'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
