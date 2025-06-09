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
}
