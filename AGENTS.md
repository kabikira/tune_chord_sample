# Repository Guidelines

本リポジトリは Flutter 製アプリです。以下のガイドに従って、開発・レビューを効率化してください。

## プロジェクト構成 & モジュール
- `lib/`: アプリ本体。`src/` 配下に `pages/`, `widgets/`, `config/`, `router/`, `db/`, `manager/`, `log/` を配置。
- `lib/l10n/`: 多言語リソース（ARB と生成物）。`l10n.yaml` 参照。
- `lib/gen/`: `flutter_gen` などの生成コード。手動編集しない。
- `assets/`: 画像・アイコン等。`pubspec.yaml` で登録。
- `test/`: テスト（`*_test.dart`）。
- 各プラットフォーム: `android/`, `ios/`, `web/`, `macos/`, `linux/`, `windows/`。

## ビルド・テスト・開発コマンド
- `make setup`: 初期化（`flutter clean` → `flutter pub get`）。
- `make flutter_generate`: l10n、import 並び替え、アイコン、`build_runner` を一括生成。
- `flutter run -d <device>`: ローカル実行（例: `-d chrome`）。
- `flutter test` / `flutter test --coverage`: テスト／カバレッジ取得。
- `flutter analyze`: 静的解析（`analysis_options.yaml` のルール適用）。
- `dart format .`: フォーマット。

## コーディング規約 & 命名
- フォーマット: 2 スペース。`dart format` を必須化。
- Lint: `flutter_lints` +（必要に応じて）`riverpod_lint`。警告ゼロを維持。
- 命名: ファイルは `snake_case.dart`、型は `UpperCamelCase`、メソッド/変数は `lowerCamelCase`。定数は `lowerCamelCase`。
- インポート順: `import_sorter` を使用（`make flutter_generate`）。
- 生成コードは直接編集しない（`lib/gen`, `lib/l10n`）。

## テスト指針
- フレームワーク: `flutter_test`。ウィジェットは `testWidgets` を基本。
- 配置/命名: `test/xxx/yyy_test.dart`、対象と同名 + `_test`。
- 目安: 変更箇所の新規コードはカバレッジ 80% 以上を目指す。

## コミット & PR
- コミット: 履歴に合わせて `feat:`, `fix:`, `refactor:`, `UI:`, `i18n:` などの接頭辞を推奨。小さく論理的に分割。
- PR 要件: 目的/背景、主な変更点、スクリーンショット（UI 変更時）、関連 Issue、動作確認手順（`flutter analyze`/`flutter test` 結果）。

## アーキテクチャ/設定メモ（抜粋）
- ルーティング: `go_router`。状態管理: `hooks_riverpod`。
- 永続化: `drift`（DB は `lib/src/db`）。
- Firebase: `lib/firebase_options.dart` を使用。機密情報はコミットしない（設定は各自 `flutterfire configure`）。

