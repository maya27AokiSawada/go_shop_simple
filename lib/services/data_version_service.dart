import 'package:hive/hive.dart';

class DataVersionService {
  static const String currentVersion = 'simple-v0.1';
  static const String versionKey = 'data_version';
  
  /// 現在のデータバージョンを取得
  static String getCurrentVersion() {
    final settingsBox = Hive.box('settings');
    return settingsBox.get(versionKey, defaultValue: '') as String;
  }
  
  /// データバージョンを設定
  static Future<void> setCurrentVersion(String version) async {
    final settingsBox = Hive.box('settings');
    await settingsBox.put(versionKey, version);
  }
  
  /// バージョンが異なるかチェック
  static bool isVersionMismatch() {
    final storedVersion = getCurrentVersion();
    return storedVersion.isNotEmpty && storedVersion != currentVersion;
  }
  
  /// 初回起動かチェック
  static bool isFirstLaunch() {
    final storedVersion = getCurrentVersion();
    return storedVersion.isEmpty;
  }
  
  /// すべてのHiveデータをクリア
  static Future<void> clearAllData() async {
    try {
      // Hiveボックスをクリア
      await Hive.deleteBoxFromDisk('purchase_groups');
      await Hive.deleteBoxFromDisk('shopping_items');
      await Hive.deleteBoxFromDisk('settings');
      
      print('データクリア完了: バージョン互換性のため');
    } catch (e) {
      print('データクリア中にエラー: $e');
    }
  }
  
  /// バージョン確認とデータクリア処理
  static Future<bool> checkVersionAndClearIfNeeded() async {
    if (isVersionMismatch()) {
      print('データバージョンが異なります。古いバージョン: ${getCurrentVersion()}, 新しいバージョン: $currentVersion');
      await clearAllData();
      return true; // データをクリアした
    } else if (isFirstLaunch()) {
      print('初回起動です。バージョン $currentVersion を設定します。');
      await setCurrentVersion(currentVersion);
      return false; // データクリアは不要
    }
    
    return false; // データクリアは不要
  }
}