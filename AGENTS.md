# Repository Guidelines

## プロジェクト構成とモジュール
- `lib/src/pages/…`: 画面（tuning / chordForm / search / settings / splash）。
- `lib/src/db/…`: Driftのテーブル/DAOと `AppDatabase`。
- `lib/src/widgets/…`: 再利用UI（フレットボード、フォーム、ボタン等）。
- `lib/src/config/…`: テーマ、ルーティング、バリデーション定数。
- `lib/src/manager/…`: 初期化、環境設定、サンプルデータ投入。
- `lib/l10n`: ローカライズARBと生成物。
- `assets/`: 画像/アイコン（`lib/gen/assets.gen.dart`経由で参照）。
- `test/`: Flutterテスト。

## ビルド・テスト・開発コマンド
- `make setup`: クリンナップ＋依存取得。
- `make flutter_generate`: l10n生成、import整列、アイコン生成、build_runner実行。
- `flutter run`: デバイス/シミュレータで起動。
- `flutter build apk` | `make submit_android`: Android（APK/AAB）ビルド。
- `flutter build ios` | `make submit_ios`: iOSビルド／Xcodeワークスペースを開く。
- `flutter test`: テスト実行。`flutter analyze`: 静的解析。

## コーディングスタイルと命名
- Lint: `flutter_lints`（`analysis_options.yaml`）。インデントは2スペース。
- ファイル: `lower_snake_case.dart`。クラス: `UpperCamelCase`。変数/メソッド: `lowerCamelCase`。
- インポート: `dart run import_sorter:main`（または `make flutter_generate`）。
- コード生成: DB/l10n/アセット変更時は `make flutter_generate` を実行。
- アセット参照: 生パスではなく FlutterGen（例: `Assets.icons.appIcon`）。

## テスト方針
- フレームワーク: `flutter_test`。`test/` 配下、ファイル名は `*_test.dart`。
- UIはウィジェットテスト、ユーティリティ/Notifierはユニットテストを優先。
- `flutter test`（必要に応じて `--coverage`）。テストは決定的に保つ。

## コミット・PRガイドライン
- コミット: 可能な範囲でConventional Commits（`feat: …`/`fix: …`/`refactor: …`/`docs: …`/`test: …`）。件名は命令形で簡潔に。
- PR: 概要、関連Issue、UI変更はスクショ/GIFを添付。DBスキーマやl10n更新の有無を明記し、`make flutter_generate` 実行済みであること。
- チェック: `flutter analyze` と `flutter test` が通っていること。

## セキュリティと設定の注意
- 秘密情報はコミットしない。Firebase設定は `lib/firebase_options.dart` と各プラットフォーム設定で管理。
- SDK/依存（Dart `^3.7.0`）は `pubspec.yaml` に合わせる。変更後は `flutter pub get`。
