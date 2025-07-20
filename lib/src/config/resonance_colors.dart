import 'package:flutter/material.dart';

/// Resonanceアイコンのカラーパレットに基づいたアプリケーション全体のカラー定義
/// 
/// このクラスは、Resonanceアイコンで使用されている6色の波形カラーを
/// アプリ全体で統一的に管理するためのカラーパレットを提供します。
class ResonanceColors {
  ResonanceColors._();

  // === Core Colors ===
  /// 背景色（ダークネイビー）
  static const Color background = Color(0xFF1A202C);
  
  /// プライマリカラー（スカイブルー - G弦）
  static const Color primary = Color(0xFF45B7D1);
  
  /// セカンダリカラー（ターコイズ - B弦）
  static const Color secondary = Color(0xFF4ECDC4);

  // === Guitar String Colors ===
  /// High E弦（1弦）- コーラルレッド
  static const Color highE = Color(0xFFFF6B6B);
  
  /// B弦（2弦）- ターコイズ
  static const Color b = Color(0xFF4ECDC4);
  
  /// G弦（3弦）- スカイブルー
  static const Color g = Color(0xFF45B7D1);
  
  /// D弦（4弦）- ミントグリーン
  static const Color d = Color(0xFF96CEB4);
  
  /// A弦（5弦）- イエロー
  static const Color a = Color(0xFFF7DC6F);
  
  /// Low E弦（6弦）- パープル
  static const Color lowE = Color(0xFFBB8FCE);

  // === Semantic Colors ===
  /// エラー表示用（High E弦カラーを使用）
  static const Color error = highE;
  
  /// 成功表示用（D弦カラーを使用）
  static const Color success = d;
  
  /// 警告表示用（A弦カラーを使用）
  static const Color warning = a;
  
  /// 情報表示用（G弦カラーを使用）
  static const Color info = g;
  
  /// アクセントカラー（B弦カラーを使用）
  static const Color accent = b;
  
  /// 特別要素用（Low E弦カラーを使用）
  static const Color special = lowE;

  // === Helper Methods ===
  /// ギター弦のインデックス（0-5）に対応するカラーを取得
  /// 0: High E, 1: B, 2: G, 3: D, 4: A, 5: Low E
  static Color getStringColor(int stringIndex) {
    switch (stringIndex) {
      case 0: return highE;
      case 1: return b;
      case 2: return g;
      case 3: return d;
      case 4: return a;
      case 5: return lowE;
      default: return primary;
    }
  }

  /// すべての弦カラーのリストを取得（High E から Low E の順）
  static List<Color> get allStringColors => [
    highE, b, g, d, a, lowE
  ];

  /// カラーパレット全体のリスト（開発・デバッグ用）
  static List<Color> get allColors => [
    background, primary, secondary, ...allStringColors
  ];

  /// カラー名のマッピング（開発・デバッグ用）
  static Map<String, Color> get colorMap => {
    'background': background,
    'primary': primary,
    'secondary': secondary,
    'highE': highE,
    'b': b,
    'g': g,
    'd': d,
    'a': a,
    'lowE': lowE,
    'error': error,
    'success': success,
    'warning': warning,
    'info': info,
    'accent': accent,
    'special': special,
  };
}