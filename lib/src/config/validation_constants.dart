// Flutter imports:
import 'package:flutter/material.dart';

class ValidationConstants {
  static const int maxTuningLength = 32;
  static const int maxTuningStringLength = 6;  // シャープを含めず6文字以内
  static const int maxTagLength = 32;
  
  static String? validateTuningString(String value) {
    final trimmed = value.trim();
    
    // 空文字列チェック
    if (trimmed.isEmpty) {
      return 'tuningStringRequired';
    }
    
    // 文字数制限チェック（シャープを含めず6文字以内）
    final lengthWithoutSharps = trimmed.replaceAll('#', '').length;
    if (lengthWithoutSharps > maxTuningStringLength) {
      return 'tuningStringTooLong';
    }
    
    // 基本的な#パターンのみをチェック（要求された問題のみ）
    if (_hasBasicInvalidSharpPattern(trimmed)) {
      return 'tuningStringInvalidSharp';
    }
    
    return null;
  }
  
  static bool _hasBasicInvalidSharpPattern(String value) {
    // #のみの文字列
    if (value == '#') {
      return true;
    }
    
    // ##などの連続した#
    if (value.contains('##')) {
      return true;
    }
    
    return false;
  }
  
  static String getErrorMessage(String? validationResult, dynamic l10n) {
    if (validationResult == null) return '';
    
    switch (validationResult) {
      case 'tuningStringRequired':
        return l10n.tuningStringRequired;
      case 'tuningStringTooLong':
        return l10n.tuningStringTooLong(maxTuningStringLength);
      case 'tuningStringInvalidSharp':
        return l10n.tuningStringInvalidSharp;
      case 'tuningStringInvalidNote':
        return l10n.tuningStringInvalidNote;
      default:
        return l10n.tuningStringRequired;
    }
  }
  
  static void showValidationError(dynamic context, dynamic theme, String? validationResult, dynamic l10n) {
    if (validationResult == null || !context.mounted) return;
    
    final errorMessage = getErrorMessage(validationResult, l10n);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: theme.colorScheme.error,
      ),
    );
  }
}

