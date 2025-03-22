class RoutePaths {
  // ベースパス（親パス、スラッシュで始まる）
  static const String tuningList = '/tuningList';
  static const String settings = '/settings';

  // ネストされたパス用の子パス名（スラッシュなし）
  static const String tuningRegisterSegment = 'tuningRegister';
  static const String codeFormListSegment = 'codeFormList';
  static const String codeFormRegisterSegment = 'codeFormRegister';
  static const String codeFormDetailSegment = 'codeFormDetail';
  static const String codeFormEditSegment = 'codeFormEdit';

  // 完全なパス（パス構築用）
  static const String tuningRegister = '$tuningList/$tuningRegisterSegment';
  static const String codeFormList = '$tuningList/$codeFormListSegment';
  static const String codeFormRegister =
      '$codeFormList/$codeFormRegisterSegment';
  static const String codeFormDetail = '$codeFormList/$codeFormDetailSegment';
  static const String codeFormEdit = '$codeFormDetail/$codeFormEditSegment';
}
