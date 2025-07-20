import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Resonanceアプリのカスタムアイコンウィジェット
/// 
/// SVGデータを内蔵し、6つのギター弦を表現した波形アイコンを表示します。
/// サイズとカラーはカスタマイズ可能です。
class ResonanceIcon extends StatelessWidget {
  /// アイコンのサイズ（幅と高さ）
  final double size;
  
  /// プライマリカラー（波形の色に使用）
  final Color? color;
  
  /// 背景色（デフォルトは透明）
  final Color? backgroundColor;

  const ResonanceIcon({
    super.key,
    this.size = 80,
    this.color,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    // 固定のSVGデータ（オリジナルのResonanceカラーを使用）
    const svgData = '''
<?xml version="1.0" encoding="UTF-8"?>
<svg viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
  <!-- Sound waves with different frequencies representing guitar strings -->
  <!-- High E string (1st) - highest frequency -->
  <path d="M 15 25 Q 25 20 35 25 Q 45 30 55 25 Q 65 20 75 25" 
        stroke="#ff6b6b" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- B string (2nd) -->
  <path d="M 15 35 Q 20 30 25 35 Q 35 40 45 35 Q 55 30 65 35 Q 70 40 75 35" 
        stroke="#4ecdc4" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- G string (3rd) -->
  <path d="M 15 45 Q 30 40 45 45 Q 60 50 75 45" 
        stroke="#45b7d1" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- D string (4th) -->
  <path d="M 15 55 Q 25 50 35 55 Q 45 60 55 55 Q 65 50 75 55" 
        stroke="#96ceb4" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- A string (5th) -->
  <path d="M 15 62 Q 35 58 55 62 Q 75 66 75 62" 
        stroke="#f7dc6f" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- Low E string (6th) - lowest frequency -->
  <path d="M 15 68 Q 45 65 75 68" 
        stroke="#bb8fce" 
        stroke-width="2" 
        fill="none"
        stroke-linecap="round"/>
  
  <!-- Central tuning indicator -->
  <circle cx="40" cy="45" r="3" fill="#ffeaa7" opacity="0.8"/>
  <circle cx="40" cy="45" r="1.5" fill="#ffffff"/>
</svg>
''';

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

/// シンプルなResonanceアイコン（背景なし、波形のみ）
class SimpleResonanceIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const SimpleResonanceIcon({
    super.key,
    this.size = 80,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ResonanceIcon(
      size: size,
      color: color,
      backgroundColor: Colors.transparent,
    );
  }
}