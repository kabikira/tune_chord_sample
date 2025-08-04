/// フレット位置をパースするためのユーティリティ関数
class FretPositionUtils {
  /// フレット位置文字列をint型のリストに変換
  /// 'x' は -1 として扱い、ミュートされた弦を表す
  static List<int> parseFretPositions(String fretPositionsString) {
    if (fretPositionsString.isEmpty) {
      return [0, 0, 0, 0, 0, 0]; // デフォルト値
    }

    return fretPositionsString
        .split(',')
        .map((position) => position.trim())
        .map((position) {
          if (position.toLowerCase() == 'x') {
            return -1; // ミュートされた弦
          }
          return int.tryParse(position) ?? 0;
        })
        .toList();
  }

  /// int型のリストをフレット位置文字列に変換
  /// -1 は 'x' として扱う
  static String formatFretPositions(List<int> fretPositions) {
    return fretPositions
        .map((position) => position == -1 ? 'x' : position.toString())
        .join(',');
  }

  /// フレット位置が有効かどうかをチェック
  static bool isValidFretPosition(String position) {
    if (position.toLowerCase() == 'x') {
      return true;
    }
    final parsed = int.tryParse(position);
    return parsed != null && parsed >= 0;
  }
}