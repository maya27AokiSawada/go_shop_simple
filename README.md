# Go Shop Simple - 買い物リストアプリ

シンプルな買い物リストアプリです。ローカルストレージを使用して、オフラインでも利用できます。

## 開発者情報
- **作成者**: XXX（あなたの名前） <!-- TODO: 実際の名前を設定 -->
- **GitHub**: https://github.com/maya27AokiSawada/go_shop_simple
- **連絡先**: XXX@example.com <!-- TODO: 実際のメールアドレスを設定 -->

## 機能
- 買い物アイテムの追加・編集・削除
- アイテムの完了チェック
- 進捗表示（完了数/総数）
- ローカルデータ永続化（Hive使用）

## 技術仕様
- **フレームワーク**: Flutter 3.35.6
- **状態管理**: Riverpod
- **データベース**: Hive (ローカル)
- **UIデザイン**: Material Design 3
- **データバージョン**: simple-v0.1

## セットアップ手順

### 前提条件
- Flutter SDK 3.9.2 以上
- Dart SDK

### インストール
1. リポジトリをクローン:
```bash
git clone https://github.com/maya27AokiSawada/go_shop_simple.git
cd go_shop_simple
```

2. 依存関係を取得:
```bash
flutter pub get
```

3. アプリを実行:
```bash
# Windows
flutter run -d windows

# Android（実機またはエミュレータ）
flutter run -d android

# その他のプラットフォーム
flutter run
```

## 対応プラットフォーム
- ✅ Windows (テスト済み)
- ✅ Android (テスト済み)
- ⚠️  iOS (未テスト)
- ⚠️  Web (未テスト)

## プロジェクト構成
```
lib/
├── main.dart                          # メインアプリケーション
├── services/
│   └── data_version_service.dart      # データバージョン管理
└── widgets/
    └── data_version_dialog.dart       # バージョン管理UI
```

## カスタマイズ

### アプリ名の変更
`pubspec.yaml` の `name` フィールドを変更してください。

### パッケージ名の変更（Android）
`android/app/build.gradle` の `applicationId` を変更してください:
```gradle
android {
    defaultConfig {
        applicationId "com.yourcompany.yourapp"  // TODO: 実際のパッケージ名を設定
    }
}
```

### アプリアイコンの設定
1. `assets/icons/` フォルダにアイコン画像を配置
2. flutter_launcher_icons パッケージを使用してアイコンを生成

## ライセンス
MIT License - 詳細は LICENSE ファイルを参照

## 貢献
バグ報告や機能要望は GitHub Issues にお願いします。

---
**注意**: このプロジェクトは学習・ポートフォリオ目的で作成されています。
