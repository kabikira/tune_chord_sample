# CLAUDE.md

このファイルは、このリポジトリでコードを作業する際のClaude Code (claude.ai/code) へのガイダンスを提供します。

## カスタム指示

Please think thoughts in English. 出力は日本語で出力してください。

あなたは高度な問題解決能力を持つAIアシスタントです。以下の指示に従って、効率的かつ正確にタスクを遂行してください。

まず、ユーザーから受け取った指示を確認します：

<指示>
{{instructions}}
</指示>

この指示を元に、以下のプロセスに従って作業を進めてください。なお、すべての提案と実装は、記載された技術スタックの制約内で行ってください：

### 1. 指示の分析と計画

<タスク分析>
- 主要なタスクを簡潔に要約してください。
- 記載された技術スタックを確認し、その制約内での実装方法を検討してください。
- 重要な要件と制約を特定してください。
- 潜在的な課題をリストアップしてください。
- タスク実行のための具体的なステップを詳細に列挙してください。
- それらのステップの最適な実行順序を決定してください。
- 必要となる可能性のあるツールやリソースを考慮してください。

このセクションは、後続のプロセス全体を導くものなので、時間をかけてでも、十分に詳細かつ包括的な分析を行ってください。
</タスク分析>

### 2. タスクの実行
- 特定したステップを一つずつ実行してください。
- 各ステップの完了後、簡潔に進捗を報告してください。
- 実行中に問題や疑問が生じた場合は、即座に報告し、対応策を提案してください。

### 3. 品質管理
- 各タスクの実行結果を迅速に検証してください。
- エラーや不整合を発見した場合は、直ちに修正アクションを実施してください。
- コマンドを実行する場合は、必ず標準出力を確認し、結果を報告してください。

### 4. 最終確認
- すべてのタスクが完了したら、成果物全体を評価してください。
- 当初の指示内容との整合性を確認し、必要に応じて調整を行ってください。

### 重要な注意事項：
- 不明点がある場合は、作業開始前に必ず確認を取ってください。
- 重要な判断が必要な場合は、その都度報告し、承認を得てください。
- 予期せぬ問題が発生した場合は、即座に報告し、対応策を提案してください。

このプロセスに従って、効率的かつ正確にタスクを遂行してください。

---

## プロジェクト概要

これは「tune_chord_sample」と呼ばれる**ギターコード管理Flutterアプリケーション**で、ユーザーがカスタムギターチューニングを管理し、コード運指（CodeFormsと呼ばれる）を保存できます。アプリは二か国語対応（英語/日本語）で、モダンなFlutterアーキテクチャパターンを使用しています。

## 開発コマンド

### セットアップと依存関係
```bash
make setup                    # クリーンと依存関係の取得
flutter pub get              # 依存関係の取得のみ
```

### コード生成
```bash
make flutter_generate        # 完全なコード生成パイプライン（推奨）
# または個別のステップ：
flutter gen-l10n             # ローカライゼーションの生成
dart run import_sorter:main  # インポートの並び替え
dart run flutter_launcher_icons # アプリアイコンの生成
dart run build_runner build --delete-conflicting-outputs # データベースコードの生成
```

### ビルド
```bash
flutter run                  # デバッグモードで実行
flutter build apk           # Android APKのビルド
make submit_android         # Android App Bundleのビルド
make submit_ios            # iOSビルドの準備
```

### テストと品質管理
```bash
flutter test               # テストの実行
flutter analyze           # 静的解析
```

## アーキテクチャ概要

### 状態管理
- **プライマリ**: `hooks_riverpod` と `flutter_hooks`
- **パターン**: StateNotifier（AsyncNotifierへ移行中）
- **データベース**: `appDatabaseProvider`を通じてアクセス

### データベース層（Drift ORM）
- **メインデータベース**: `lib/src/db/app_database.dart`の`AppDatabase`
- **コアテーブル**: 
  - `Tunings`: ギターチューニング設定
  - `CodeForms`: チューニングにリンクされたコード運指
  - `Tags`: カテゴリ化システム
  - 多対多関係のためのジャンクションテーブル
- **コード生成**: スキーマ変更後に`build_runner`を通じて必要

### ナビゲーション
- **ルーター**: 宣言的ルーティングを持つ`go_router`
- **構造**: 3つのタブ（チューニング、検索、設定）を持つボトムナビゲーション
- **設定**: `lib/src/router/app_router.dart`

### 主要ドメインモデル

**Tuningエンティティ**:
- ギターチューニング（例：「CGDGCD」）を表現
- 多くのCodeFormsを持つ
- プロパティ: name, strings, memo, isFavorite, timestamps

**CodeFormエンティティ**:
- 特定のチューニングに対する個別のコード運指
- 1つのTuningに属する
- プロパティ: tuningId (FK), fretPositions, label, memo, isFavorite

## プロジェクト構造

```
lib/src/
├── db/              # Driftデータベース定義とDAO
├── pages/           # 機能別に整理されたUIスクリーン
│   ├── codeForm/    # コードフォームCRUDスクリーン
│   ├── tuning/      # チューニング管理スクリーン
│   ├── search/      # 検索機能
│   └── settings/    # アプリ設定
├── widgets/         # 再利用可能なUIコンポーネント
│   ├── カスタムフォームコンポーネント (CustomTextField, SectionHeader)
│   ├── ギター専用ウィジェット (GuitarFretboardWidget, ChordDiagramWidget)
│   ├── CodeFormコンポーネント (CodeFormWidget, TuningInfoCard, FretControlWidget)
│   └── アクションコンポーネント (DialogActionButtons, CodeFormActionButtons)
├── router/          # Go routerの設定
└── config/          # アプリの定数と検証ルール
```

## コンポーネントアーキテクチャ

### ウィジェット整理戦略
- **グローバルウィジェット** (`/lib/src/widgets/`): アプリ全体で再利用可能なコンポーネント
- **機能専用ウィジェット** (`/lib/src/pages/{feature}/widgets/`): 特定機能専用のコンポーネント

### CodeFormコンポーネントシステム
CodeForm機能は最大限の再利用性を実現するため、コンポーネント化されたアーキテクチャを使用：

**コアコンポーネント**:
- `CodeFormWidget`: 登録と編集で共有されるロジックを持つメインフォームコンテナ
- `TuningInfoCard`: 一貫したカード形式でチューニング情報を表示
- `FretControlWidget`: 前/次/リセット制御を持つフレット位置ナビゲーション
- `CodeFormActionButtons`: 送信操作用の設定可能なアクションボタン

**使用パターン**:
```dart
// 登録画面
CodeFormWidget(
  tuningId: tuningId,
  submitButtonText: '登録する',
  onSubmit: ({required String fretPositions, String? label, String? memo}) async {
    await ref.read(codeFormNotifierProvider.notifier).addCodeForm(/*...*/);
  },
)

// 編集画面  
CodeFormWidget(
  tuningId: tuningId,
  submitButtonText: '更新する',
  initialLabel: existingCodeForm.label,
  initialMemo: existingCodeForm.memo,
  initialFretPositions: existingFretPositions,
  onSubmit: ({required String fretPositions, String? label, String? memo}) async {
    await ref.read(codeFormNotifierProvider.notifier).updateCodeForm(/*...*/);
  },
)
```

## 開発パターン

### 状態管理パターン
```dart
// 典型的なnotifier構造
@riverpod
class TuningNotifier extends _$TuningNotifier {
  @override
  Future<List<Tuning>> build() async {
    return ref.read(appDatabaseProvider).getAllTunings();
  }
}
```

### データベースアクセスパターン
```dart
// プロバイダーを通じてデータベースにアクセス
final database = ref.read(appDatabaseProvider);
final tunings = await database.getAllTunings();
```

### ナビゲーションパターン
```dart
// ナビゲーションにはcontext.goを使用
context.go('/tuning/${tuning.id}/codeForm/create');
```

### コンポーネント合成パターン
```dart
// 小さな再利用可能なコンポーネントから複雑な画面を構成
class CodeFormRegister extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('コードフォーム登録')),
      body: SafeArea(
        child: CodeFormWidget(
          tuningId: tuningId,
          submitButtonText: '登録する',
          onSubmit: (data) => _handleRegistration(ref, data),
        ),
      ),
    );
  }
}
```

### ウィジェット再利用パターン
```dart
// 異なる用途に対応するよう設定を受け入れるコンポーネント設計
class CodeFormActionButtons extends StatelessWidget {
  final String submitButtonText;
  final bool isEnabled;
  final VoidCallback onSubmit;

  // 単一コンポーネントで登録と編集の両方のシナリオを処理
  const CodeFormActionButtons({
    required this.submitButtonText,  // '登録する' または '更新する'
    required this.onSubmit,
    this.isEnabled = true,
  });
}
```

## 重要な実装ノート

### コード生成要件
- 以下の後に `make flutter_generate` または `dart run build_runner build --delete-conflicting-outputs` を実行：
  - データベーススキーマの変更
  - 新しいローカライゼーション文字列の追加
  - ジェネレーターを持つRiverpodプロバイダーの変更

### カラーテーマ
- 現在 `withOpacity` から `withAlpha`/`withValues(alpha:)` への移行中
- 新しい色の透明度実装には `withValues(alpha: value)` を使用

### アーキテクチャ移行
- StateNotifier → AsyncNotifier の移行（TODOコメントを確認）
- 状態管理コードで作業する際にこの移行を完了させる

### ローカライゼーション
- 英語と日本語をサポート
- ローカライゼーションファイルは `lib/l10n/` にあり
- 文字列変更後は `flutter gen-l10n` で生成

### ウィジェット整理原則
- **グローバルコンポーネント** (`/lib/src/widgets/`): 複数の機能で再利用されるウィジェットを配置
- **機能専用コンポーネント**: その機能に真に特化している場合のみ機能ディレクトリに保持
- **コンポーネント合成**: 小さく焦点を絞ったコンポーネントを組み合わせて複雑な画面を構築
- **重複より設定**: 別々のウィジェットを作成するより、props/パラメータを使用してバリエーションを処理
- **ウィジェットギャラリー**: すべてのグローバルウィジェットは開発とテストのため `/lib/src/pages/settings/widget_gallery.dart` で展示すべき

## テストに関する注記

- テストカバレッジは最小限（デフォルトのウィジェットテストのみ存在）
- テストを追加する際は、Flutterテストパターンに従う
- データベーステストはインメモリデータベースインスタンスを使用すべき