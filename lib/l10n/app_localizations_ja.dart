// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get helloWorld => 'こんにちは世界！';

  @override
  String get tuningManagement => 'チューニング管理';

  @override
  String errorMessage(String error) {
    return 'エラー: $error';
  }

  @override
  String get noTuningsRegistered => '登録されたチューニングがありません';

  @override
  String get registrationDate => '登録日';

  @override
  String get updateDate => '更新日';

  @override
  String get registerTuning => 'チューニングを登録';

  @override
  String get stringTuning => '弦のチューニング';

  @override
  String get tuningExample => '例: CGDGCD';

  @override
  String get tuningInputDescription => '低音から高音の順に入力してください';

  @override
  String get cancel => 'キャンセル';

  @override
  String get complete => '完了';

  @override
  String get deleteConfirmation => '削除確認';

  @override
  String deleteConfirmationMessage(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get deleteWarningMessage => 'この操作は取り消せません。チューニングに関連するコードフォームもすべて削除されます。';

  @override
  String get delete => '削除';

  @override
  String get editTuning => 'チューニングを編集';

  @override
  String get tuningName => 'チューニング名';

  @override
  String get tuningNameExample => '例: オープンC';

  @override
  String get update => '更新';

  @override
  String get tags => 'タグ';

  @override
  String get newTag => '新規タグ';

  @override
  String get deleteTag => 'タグの削除';

  @override
  String deleteTagConfirmation(String tagName) {
    return '$tagNameを削除してもよろしいですか？';
  }

  @override
  String get navTuning => 'チューニング';

  @override
  String get navSearch => '検索';

  @override
  String get navSettings => '設定';

  @override
  String get chordFormRegistration => 'コードフォーム登録';

  @override
  String get chordFormEdit => 'コードフォーム編集';

  @override
  String get chordFormDetail => 'コードフォーム詳細';

  @override
  String get chordFormList => 'コードフォーム一覧';

  @override
  String get register => '登録する';

  @override
  String get edit => '編集';

  @override
  String get memo => 'メモ';

  @override
  String get memoOptional => 'メモ（任意）';

  @override
  String get memoPlaceholder => 'コードに関するメモを入力...';

  @override
  String get chordName => 'コード名';

  @override
  String get chordNameExample => 'Em, C, G7など';

  @override
  String get fretPosition => 'フレットポジション';

  @override
  String fretNumber(int number) {
    return 'フレット $number';
  }

  @override
  String get previousFret => '前のフレット';

  @override
  String get nextFret => '次のフレット';

  @override
  String get reset => 'リセット';

  @override
  String get tuningInfo => 'チューニング情報';

  @override
  String get chordInfo => 'コード情報';

  @override
  String get fretboardHelp => 'フレットボードの使い方';

  @override
  String get fretboardHelpTapString => '弦をタップして押さえる位置を指定';

  @override
  String get fretboardHelpOpenString => 'フレット 0 はオープン弦を表します';

  @override
  String get fretboardHelpMuteString => 'フレット 0 での長押しで弦をミュート（X）します';

  @override
  String get fretboardHelpTapAgain => '同じ位置を再度タップすると解除されます';

  @override
  String get fretboardHelpArrowKeys => '左右の矢印でフレット位置を移動できます';

  @override
  String get close => '閉じる';

  @override
  String get chordFormNotFound => 'コードフォームが見つかりません';

  @override
  String get muteStringLongPress => '弦をミュート (長押し)';

  @override
  String get currentComposition => '現在の構成:';

  @override
  String get help => 'ヘルプ';

  @override
  String get deleteChordForm => 'コードフォームの削除';

  @override
  String get deleteChordFormConfirmation => 'このコードフォームを削除してもよろしいですか？';

  @override
  String get cannotBeUndone => 'この操作は取り消せません。';

  @override
  String get confirm => '確認';

  @override
  String errorOccurred(String error) {
    return 'エラー: $error';
  }

  @override
  String get tuningNotFound => 'チューニングが見つかりません';

  @override
  String get displayMode => '表示モード';

  @override
  String get cardMode => 'カード';

  @override
  String get listMode => 'リスト';

  @override
  String get toggleFavorite => 'お気に入り切り替え';

  @override
  String get noChordFormsFound => 'コードフォームが見つかりません';

  @override
  String get registerFirst => 'まず登録してください';

  @override
  String get registerChordForm => 'コードフォーム登録';

  @override
  String get openString => '開放';

  @override
  String get muteString => 'ミュート';

  @override
  String chordFretPosition(String position) {
    return 'フレットポジション: $position';
  }

  @override
  String chordMemo(String memo) {
    return 'メモ: $memo';
  }

  @override
  String get search => '検索';

  @override
  String get searchKeywordPlaceholder => '検索キーワードを入力';

  @override
  String get searchOptions => '検索オプション';

  @override
  String get searchTarget => '検索対象';

  @override
  String get sortOrder => '並び順';

  @override
  String get searchTargetAll => 'すべて';

  @override
  String get searchTargetTuning => 'チューニングのみ';

  @override
  String get searchTargetChordForm => 'コードフォームのみ';

  @override
  String get searchTargetTag => 'タグのみ';

  @override
  String get sortOrderNewest => '新しい順';

  @override
  String get sortOrderOldest => '古い順';

  @override
  String get sortOrderIdAsc => 'ID昇順';

  @override
  String get sortOrderIdDesc => 'ID降順';

  @override
  String get searchEnterKeyword => '検索キーワードを入力してください';

  @override
  String get searchNoResults => '検索結果がありません';

  @override
  String tuningLabel(String tuning) {
    return 'チューニング: $tuning';
  }

  @override
  String fretPositionLabel(String position) {
    return 'フレットポジション: $position';
  }

  @override
  String get noName => '名称なし';

  @override
  String searchError(String error) {
    return '検索中にエラーが発生しました: $error';
  }

  @override
  String get settings => '設定';

  @override
  String get appInfo => 'アプリ情報';

  @override
  String get aboutApp => 'アプリについて';

  @override
  String get version => 'バージョン';

  @override
  String get appearanceSettings => '外観設定';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get developerOptions => '開発者向け';

  @override
  String get widgetGallery => 'ウィジェット一覧';

  @override
  String get dataManagement => 'データ管理';

  @override
  String get backupData => 'データのバックアップ';

  @override
  String get restoreData => 'データの復元';

  @override
  String get deleteAllData => 'すべてのデータを削除';

  @override
  String get aboutAppTitle => 'アプリについて';

  @override
  String get appName => 'コードフォーム管理アプリ';

  @override
  String get appDescription => '変則チューニングのためのギターコードフォーム管理アプリです。様々なチューニングでのコードフォームを記録・管理できます。';

  @override
  String versionLabel(String version) {
    return 'バージョン: $version';
  }

  @override
  String get deleteData => 'データを削除';

  @override
  String get deleteDataWarning => 'すべてのチューニングとコードフォームデータを削除します';

  @override
  String get deleteDataDescription => 'この操作は取り消せません。すべてのデータが完全に削除されます。';

  @override
  String get tuningStringRequired => '弦のチューニングを入力してください';

  @override
  String tuningStringTooLong(int maxLength) {
    return '弦のチューニングが長すぎます（最大$maxLength文字）';
  }

  @override
  String tuningNameTooLong(int maxLength) {
    return 'チューニング名が長すぎます（最大$maxLength文字）';
  }

  @override
  String get tuningStringInvalidSharp => '無効な#（シャープ）パターンが検出されました';

  @override
  String get tuningStringInvalidNote => '無効な音名パターンが検出されました';
}
