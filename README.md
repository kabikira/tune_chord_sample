# Resonance (tune_chord_sample)

変則チューニングのためのギター用コードフォーム管理アプリです。チューニングごとに押さえ方（コードフォーム）を記録・閲覧・検索できます。Flutter + Drift（SQLite）を用いたローカル保存と、Firebase Crashlytics/Analytics による運用計測を備えています。

## 概要
- 目的: 変則チューニング環境でのコードフォーム管理を簡単・安全に。
- 初回起動: SharedPreferences を用いて初回判定し、サンプルのチューニング/コードフォームを自動投入。
- 多言語: 日本語/英語のローカライズ対応（`lib/l10n`）。

## 主な機能
- チューニング管理
  - 一覧/追加/編集/削除、登録日・更新日表示、タグ付与（DB対応）。
- コードフォーム管理
  - チューニング単位で一覧・詳細・登録・編集・削除。
  - 表示切替（リスト/詳細）。
- フレットボード UI（6弦→1弦）
  - タップで押弦、0フレット長押しでミュート（X）。
  - スクロールで開始フレットの移動、ヘルプダイアログあり。
- 検索
  - キーワードでチューニング/コードフォーム/タグを横断検索。
  - 並び順（新しい順/古い順/ID昇順/ID降順）切替。
- 設定
  - テーマ（ライト/ダーク）切替、アプリ情報表示。
  - デバッグ: Crashlytics テスト送信、ウィジェットギャラリー。

## 画面構成
- スプラッシュ → ボトムナビ（`/tuningList`・`/search`・`/settings`）
  - ルーティングは `go_router` + `StatefulShellRoute`（IndexedStack）で実装。

## データモデル（Drift/SQLite）
- `Tunings`: `id`, `name`, `strings`（例: `EADGBE`, `CGDGCD`）, `memo`, `isFavorite`, 時刻列。
- `ChordForms`: `id`, `tuningId`, `fretPositions`（例: `x,0,2,2,2,0` ／6弦→1弦）, `label`, `memo`, `isFavorite`, 時刻列。
- `Tags` + 中間: `TuningTags`, `ChordFormTags` によりタグ付けを表現。

## 技術スタック
- UI/状態: Flutter, hooks_riverpod / riverpod_annotation, flutter_hooks, go_router
- データ: drift, sqlite3_flutter_libs, shared_preferences
- 運用: Firebase Core, Crashlytics, Analytics, logger
- 表示/その他: flutter_localizations, intl, flutter_svg, package_info_plus

## セットアップ
1) 依存関係の取得
```bash
flutter pub get
```

2) 実行（デバイス/シミュレータ）
```bash
flutter run
```

3) ビルド（例: iOS/Android）
```bash
flutter build ios
flutter build apk
```

Firebase は `lib/firebase_options.dart` でプラットフォームごとの設定が読み込まれます。Crashlytics テストは 設定 > Crashlyticsテスト から送信できます（デバッグ時）。

## ディレクトリ
- `lib/src/pages/…` 画面（チューニング/コードフォーム/検索/設定/スプラッシュ）
- `lib/src/widgets/…` 共通 UI（フレットボード等）
- `lib/src/db/…` Drift 定義と DB アクセス
- `lib/src/manager/…` 初期化・サンプルデータ・設定管理
- `lib/src/config/…` テーマ/ルート/バリデーション
- `lib/l10n` ローカライズ資産

## 開発メモ
- コードフォームのフレット表記は 6弦→1弦 順でカンマ区切り（`x` はミュート、`0` は開放）。
- 初回起動時、サンプルデータが自動投入されます（`SampleDataManager`）。
- ルーター監視は `RouterObserver` で実装。

---
必要に応じてスクリーンショットや英語版 README を追加できます。
