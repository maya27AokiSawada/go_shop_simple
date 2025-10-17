# Go Shop Simple - 設定ガイド

このファイルでは、アプリをカスタマイズするために変更すべき設定項目を説明します。

## 必須設定項目

### 1. アプリ基本情報（pubspec.yaml）
```yaml
name: go_shop_simple  # TODO: あなたのアプリ名を設定
description: "シンプルな買い物リストアプリ"  # TODO: アプリの説明を設定
```

### 2. 開発者情報（README.md）
```markdown
- **作成者**: XXX（あなたの名前） <!-- TODO: 実際の名前を設定 -->
- **GitHub**: https://github.com/XXX/go_shop_simple <!-- TODO: 実際のGitHubリポジトリを設定 -->
- **連絡先**: XXX@example.com <!-- TODO: 実際のメールアドレスを設定 -->
```

### 3. Androidパッケージ名（android/app/build.gradle）
```gradle
android {
    namespace "com.yourcompany.goshopsimple"  // TODO: 実際のパッケージ名を設定
    defaultConfig {
        applicationId "com.yourcompany.goshopsimple"  // TODO: 実際のパッケージ名を設定
    }
}
```

**注意**: パッケージ名は以下の形式にしてください:
- `com.yourcompany.appname` 形式
- 英数字とドット（.）のみ使用
- 例: `com.johndoe.goshopsimple`

### 4. GitHubリポジトリ設定
1. GitHubで新しいリポジトリを作成
2. README.mdのリポジトリURLを更新
3. `git remote` を設定

## オプション設定項目

### アプリアイコン
1. `flutter_launcher_icons` パッケージを追加:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1
```

2. `pubspec.yaml` にアイコン設定を追加:
```yaml
flutter_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/icon/app_icon.png"
```

### アプリ名（表示名）
Androidの場合、`android/app/src/main/AndroidManifest.xml` で設定:
```xml
<application
    android:label="Go Shop Simple"  <!-- TODO: 表示したいアプリ名 -->
    ...>
```

### バージョン情報
`pubspec.yaml` でバージョンを管理:
```yaml
version: 1.0.0+1  # メジャー.マイナー.パッチ+ビルド番号
```

## セキュリティ重要事項

### 🚨 絶対に公開してはいけない情報
- Firebase API キー
- Google Services設定ファイル（google-services.json）
- 暗号化キー
- データベース接続情報
- 個人の連絡先情報（メールアドレス、電話番号等）

### 📝 TODOマーカーの置き換え
このプロジェクトでは、置き換えが必要な箇所を`TODO:`コメントで示しています。
すべての`TODO:`コメントを確認し、適切な値に置き換えてください。

### 🔍 置き換え確認コマンド
`ash
# TODO コメントがあるファイルを検索
grep -r "TODO:" .
`

## ライセンス設定
MITライセンスファイルを追加してください:
```
Copyright (c) 2025 Kanagae Shinya Fatima

Permission is hereby granted, free of charge, to any person obtaining a copy...
```

---
**重要**: 公開前に必ずすべてのTODOコメントを確認し、個人情報が適切に設定されていることを確認してください。
