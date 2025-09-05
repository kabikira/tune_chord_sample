// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:chord_fracture/l10n/app_localizations.dart';

class ErrorHandler {
  static void showSafeError(
    BuildContext context, {
    Object? error,
    String? customMessage,
  }) {
    if (!context.mounted) return;
    
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    
    String errorMessage;
    if (customMessage != null) {
      errorMessage = customMessage;
    } else {
      errorMessage = l10n?.generalError ?? 'An error occurred';
    }
    
    if (kDebugMode && error != null) {
      debugPrint('Error details: $error');
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
  
  static String getSafeErrorMessage(AppLocalizations l10n, {Object? error}) {
    if (kDebugMode && error != null) {
      debugPrint('Error details: $error');
    }
    return l10n.generalError;
  }
  
  static Widget buildSafeErrorWidget(AppLocalizations l10n, {Object? error}) {
    if (kDebugMode && error != null) {
      debugPrint('Error details: $error');
    }
    return Center(child: Text(l10n.generalError));
  }
}
