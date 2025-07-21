// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:resonance/l10n/app_localizations.dart';
import 'package:resonance/src/config/theme_provider.dart';
import 'package:resonance/src/pages/settings/widget_gallery.dart';

class Settings extends ConsumerWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final themeModeAsync = ref.watch(themeModeNotifierProvider);
    final themeModeNotifier = ref.read(themeModeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
      appBar: AppBar(
        title: Text(l10n.settings),
        elevation: 0,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // アプリ情報セクション
            _buildSectionHeader(context, l10n.appInfo),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context,
              children: [
                _buildSettingsItem(
                  context,
                  icon: Icons.info_outline,
                  title: l10n.aboutApp,
                  onTap: () {
                    // アプリ情報ダイアログを表示
                    _showAboutDialog(context);
                  },
                ),
                _buildDivider(),
                _buildSettingsItem(
                  context,
                  icon: Icons.update,
                  title: l10n.version,
                  trailing: Text(
                    '1.0.0',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 外観設定セクション
            _buildSectionHeader(context, l10n.appearanceSettings),
            const SizedBox(height: 8),
            _buildSettingsCard(
              context,
              children: [
                _buildSettingsItem(
                  context,
                  icon: Icons.dark_mode,
                  title: l10n.darkMode,
                  trailing: themeModeAsync.when(
                    loading: () => const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    error: (_, __) => const Icon(Icons.error_outline),
                    data: (themeMode) => Switch.adaptive(
                      value: themeMode == ThemeMode.dark || 
                             (themeMode == ThemeMode.system && 
                              MediaQuery.of(context).platformBrightness == Brightness.dark),
                      onChanged: (value) {
                        themeModeNotifier.toggleDarkMode();
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 開発者セクション（デバッグ時のみ表示）
            if (kDebugMode) ...[
              _buildSectionHeader(context, l10n.developerOptions),
              const SizedBox(height: 8),
              _buildSettingsCard(
                context,
                children: [
                  _buildSettingsItem(
                    context,
                    icon: Icons.widgets,
                    title: l10n.widgetGallery,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const WidgetGallery(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // データ管理セクション
            // _buildSectionHeader(context, l10n.dataManagement),
            // const SizedBox(height: 8),
            // _buildSettingsCard(
            //   context,
            //   children: [
            //     _buildSettingsItem(
            //       context,
            //       icon: Icons.backup,
            //       title: l10n.backupData,
            //       onTap: () {
            //         // バックアップ処理
            //       },
            //     ),
            //     _buildDivider(),
            //     _buildSettingsItem(
            //       context,
            //       icon: Icons.restore,
            //       title: l10n.restoreData,
            //       onTap: () {
            //         // 復元処理
            //       },
            //     ),
            //     _buildDivider(),
            //     _buildSettingsItem(
            //       context,
            //       icon: Icons.delete_forever,
            //       title: l10n.deleteAllData,
            //       titleColor: theme.colorScheme.error,
            //       onTap: () {
            //         // 削除確認ダイアログ
            //         _showDeleteConfirmDialog(context);
            //       },
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  // セクションヘッダーを構築
  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }

  // 設定カードを構築
  Widget _buildSettingsCard(
    BuildContext context, {
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(children: children),
    );
  }

  // 設定項目を構築
  Widget _buildSettingsItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: titleColor ?? theme.colorScheme.primary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyLarge?.copyWith(color: titleColor),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  // 区切り線を構築
  Widget _buildDivider() {
    return const Divider(height: 1, indent: 56);
  }

  // アプリ情報ダイアログを表示
  void _showAboutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Row(
              children: [
                Icon(Icons.music_note, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.aboutAppTitle),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.appName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.appDescription,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.versionLabel('1.0.0'),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  l10n.close,
                  style: TextStyle(color: theme.colorScheme.primary),
                ),
              ),
            ],
          ),
    );
  }

  // データ削除確認ダイアログを表示
  // void _showDeleteConfirmDialog(BuildContext context) {
  //   final theme = Theme.of(context);
  //   final l10n = AppLocalizations.of(context)!;

  //   showDialog(
  //     context: context,
  //     builder:
  //         (context) => AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(16),
  //           ),
  //           title: Text(l10n.deleteData),
  //           content: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Container(
  //                 padding: const EdgeInsets.all(16),
  //                 decoration: BoxDecoration(
  //                   color: theme.colorScheme.error.withValues(alpha: 0.05),
  //                   borderRadius: BorderRadius.circular(16),
  //                   border: Border.all(
  //                     color: theme.colorScheme.error.withValues(alpha: 0.2),
  //                     width: 1,
  //                   ),
  //                 ),
  //                 child: Row(
  //                   children: [
  //                     Icon(
  //                       Icons.warning_amber_rounded,
  //                       color: theme.colorScheme.error,
  //                       size: 24,
  //                     ),
  //                     const SizedBox(width: 12),
  //                     Expanded(
  //                       child: Text(
  //                         l10n.deleteDataWarning,
  //                         style: theme.textTheme.bodyMedium?.copyWith(
  //                           fontWeight: FontWeight.w500,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 16),
  //               Text(
  //                 l10n.deleteDataDescription,
  //                 style: theme.textTheme.bodySmall?.copyWith(
  //                   color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
  //                 ),
  //               ),
  //             ],
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.of(context).pop(),
  //               child: Text(
  //                 l10n.cancel,
  //                 style: TextStyle(color: theme.colorScheme.onSurface),
  //               ),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 // データ削除処理
  //                 Navigator.of(context).pop();
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: theme.colorScheme.error,
  //                 foregroundColor: theme.colorScheme.onError,
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //               ),
  //               child: Text(l10n.delete),
  //             ),
  //           ],
  //           actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
  //         ),
  //   );
  // }
}
