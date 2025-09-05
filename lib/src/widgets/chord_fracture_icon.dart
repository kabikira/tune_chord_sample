// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_svg/flutter_svg.dart';

/// ChordFractureアプリのカスタムアイコンウィジェット
///
/// SVGデータを内蔵し、6つのギター弦を表現した波形アイコンを表示します。
/// サイズとカラーはカスタマイズ可能です。
class ChordFractureIcon extends StatelessWidget {
  /// アイコンのサイズ（幅と高さ）
  final double size;

  /// プライマリカラー（波形の色に使用）
  final Color? color;

  /// 背景色（デフォルトは透明）
  final Color? backgroundColor;

  const ChordFractureIcon({
    super.key,
    this.size = 80,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // 固定のSVGデータ（オリジナルのChordFractureカラーを使用）
    const svgData = '''
<?xml version="1.0" encoding="UTF-8"?>
<svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- App icon background -->
  <rect width="80" height="80" rx="16" fill="#1a202c"/>
  
  <!-- Sound waves with different frequencies representing guitar strings -->
  <!-- High E string (1st) - highest frequency -->
  <path d="M 12 25 Q 22 20 32 25 Q 42 30 52 25 Q 62 20 68 25" 
        stroke="#ff6b6b" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- B string (2nd) -->
  <path d="M 12 33 Q 17 28 22 33 Q 32 38 42 33 Q 52 28 62 33 Q 67 38 68 33" 
        stroke="#4ecdc4" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- G string (3rd) -->
  <path d="M 12 41 Q 27 36 42 41 Q 57 46 68 41" 
        stroke="#45b7d1" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- D string (4th) -->
  <path d="M 12 49 Q 22 44 32 49 Q 42 54 52 49 Q 62 44 68 49" 
        stroke="#96ceb4" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- A string (5th) -->
  <path d="M 12 57 Q 32 53 52 57 Q 68 61 68 57" 
        stroke="#f7dc6f" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- Low E string (6th) - lowest frequency -->
  <path d="M 12 63 Q 42 60 68 63" 
        stroke="#bb8fce" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- Central tuning indicator -->
  <circle cx="40" cy="40" r="3" fill="#ffeaa7" opacity="0.8"/>
  <circle cx="40" cy="40" r="1.5" fill="#ffffff"/>
</svg>''';

    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.string(
        svgData,
        width: size,
        height: size,
        fit: BoxFit.contain,
      ),
    );
  }
}

/// シンプルなChordFractureアイコン（背景なし、波形のみ）
class SimpleChordFractureIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const SimpleChordFractureIcon({super.key, this.size = 80, this.color});

  @override
  Widget build(BuildContext context) {
    return ChordFractureIcon(
      size: size,
      color: color,
      backgroundColor: Colors.transparent,
    );
  }
}
