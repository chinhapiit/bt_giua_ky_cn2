import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/viewmodels/app_settings_view_model.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsVm = context.watch<AppSettingsViewModel>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SwitchListTile(
                title: const Text('Chế độ tối'),
                subtitle: Text(
                  settingsVm.isDarkMode
                      ? 'Đang dùng giao diện tối'
                      : 'Đang dùng giao diện sáng',
                ),
                value: settingsVm.isDarkMode,
                onChanged: settingsVm.toggleDarkMode,
                secondary: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    settingsVm.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                    size: 18,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
