import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/core/theme/app_theme.dart';
import 'package:untitled1/data/repositories/news_repository.dart';
import 'package:untitled1/data/services/news_api_service.dart';
import 'package:untitled1/viewmodels/app_settings_view_model.dart';
import 'package:untitled1/viewmodels/news_view_model.dart';
import 'package:untitled1/views/welcome_screen.dart';

void main() {
  runApp(const NewsApp());
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NewsViewModel>(
          create: (_) => NewsViewModel(const NewsRepository(NewsApiService())),
        ),
        ChangeNotifierProvider<AppSettingsViewModel>(
          create: (_) => AppSettingsViewModel(),
        ),
      ],
      child: Consumer<AppSettingsViewModel>(
        builder: (context, settingsVm, child) {
          return MaterialApp(
            title: 'News App',
            debugShowCheckedModeBanner: false,
            themeMode: settingsVm.themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
