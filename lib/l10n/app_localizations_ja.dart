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
  String get codeFormRegistration => 'コードフォーム登録';

  @override
  String get codeFormEdit => 'コードフォーム編集';

  @override
  String get codeFormDetail => 'コードフォーム詳細';

  @override
  String get codeFormList => 'コードフォーム一覧';

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
  String get codeFormNotFound => 'コードフォームが見つかりません';
}
