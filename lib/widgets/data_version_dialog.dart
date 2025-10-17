import 'package:flutter/material.dart';

class DataVersionDialog {
  /// バージョン不一致時のダイアログを表示
  static Future<bool> showVersionMismatchDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, // ダイアログ外をタップしても閉じない
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('データ構造の更新'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'アプリのデータ構造が更新されました。',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('互換性を保つため、既存のデータをクリアする必要があります。'),
              SizedBox(height: 8),
              Text(
                '• 買い物リスト\n• グループ情報\n• 設定情報',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                'データをクリアしてアプリを続行しますか？',
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('データをクリア'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  /// データクリア完了ダイアログ
  static Future<void> showDataClearCompleteDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('データクリア完了'),
            ],
          ),
          content: const Text(
            'データのクリアが完了しました。\n新しいデータ構造でアプリをお使いいただけます。',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  /// 初回起動ウェルカムダイアログ
  static Future<void> showWelcomeDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.shopping_cart, color: Colors.blue),
              SizedBox(width: 8),
              Text('Go Shopへようこそ！'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'この買い物リストアプリをお選びいただき、ありがとうございます。',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 12),
              Text('主な機能:'),
              SizedBox(height: 8),
              Text(
                '• 買い物アイテムの管理\n• QRコードでのグループ招待\n• 家族・友人との共有',
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(height: 12),
              Text(
                'データバージョン: simple-v0.1',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('始める'),
            ),
          ],
        );
      },
    );
  }
}