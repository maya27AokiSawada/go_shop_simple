import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'widgets/data_version_dialog.dart';
import 'services/data_version_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Hive初期化
  await Hive.initFlutter();
  
  // 最初に設定ボックスを開く（バージョン確認のため）
  await Hive.openBox('settings');
  
  // データバージョン管理
  bool showVersionDialog = false;
  if (DataVersionService.isVersionMismatch()) {
    print('データバージョンが異なります。古いバージョン: ${DataVersionService.getCurrentVersion()}, 新しいバージョン: ${DataVersionService.currentVersion}');
    await DataVersionService.clearAllData();
    print('データクリア完了: バージョン互換性のため');
    showVersionDialog = true;
  }
  
  // 買い物アイテム用のボックスを開く
  await Hive.openBox('shopping_items');
  
  runApp(ProviderScope(child: MyApp(showVersionDialog: showVersionDialog)));
}

class MyApp extends StatelessWidget {
  final bool showVersionDialog;
  
  const MyApp({super.key, this.showVersionDialog = false});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Go Shop - 買い物リスト',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: ShoppingListPage(showVersionDialog: showVersionDialog),
    );
  }
}

class ShoppingListPage extends ConsumerStatefulWidget {
  final bool showVersionDialog;
  
  const ShoppingListPage({super.key, this.showVersionDialog = false});

  @override
  ConsumerState<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends ConsumerState<ShoppingListPage> {
  final TextEditingController _controller = TextEditingController();
  final Box _box = Hive.box('shopping_items');
  
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
    
    // バージョンダイアログの表示
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showVersionDialogIfNeeded();
    });
  }
  
  // バージョンダイアログ表示
  Future<void> _showVersionDialogIfNeeded() async {
    if (widget.showVersionDialog) {
      await DataVersionDialog.showDataClearCompleteDialog(context);
    } else if (DataVersionService.isFirstLaunch()) {
      await DataVersionDialog.showWelcomeDialog(context);
      await DataVersionService.setCurrentVersion(DataVersionService.currentVersion);
    }
  }

  void _loadItems() {
    final data = _box.get('items', defaultValue: <Map<String, dynamic>>[]);
    setState(() {
      if (data is List) {
        _items = data.map((item) {
          if (item is Map) {
            return Map<String, dynamic>.from(item);
          }
          return <String, dynamic>{};
        }).toList();
      } else {
        _items = <Map<String, dynamic>>[];
      }
    });
  }

  void _saveItems() {
    _box.put('items', _items);
  }

  void _addItem(String title) {
    if (title.trim().isEmpty) return;
    
    setState(() {
      _items.add({
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': title.trim(),
        'completed': false,
        'createdAt': DateTime.now().toIso8601String(),
      });
    });
    _saveItems();
    _controller.clear();
  }

  void _toggleItem(int index) {
    setState(() {
      _items[index]['completed'] = !_items[index]['completed'];
    });
    _saveItems();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _saveItems();
  }

  void _editItem(int index, String newTitle) {
    if (newTitle.trim().isEmpty) return;
    
    setState(() {
      _items[index]['title'] = newTitle.trim();
    });
    _saveItems();
  }

  void _showAddItemDialog() {
    _controller.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新しいアイテム'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'アイテム名を入力',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            _addItem(value);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              _addItem(_controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('追加'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(int index) {
    _controller.text = _items[index]['title'] ?? '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('アイテムの編集'),
        content: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            _editItem(index, value);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () {
              _editItem(index, _controller.text);
              Navigator.of(context).pop();
            },
            child: const Text('更新'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _items.where((item) => item['completed']).length;
    final totalCount = _items.length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Go Shop - 買い物リスト'),
        actions: [
          if (_items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '$completedCount/$totalCount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    '買い物リストが空です',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '+ボタンで新しいアイテムを追加しましょう',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isCompleted = item['completed'] ?? false;
                
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Checkbox(
                      value: isCompleted,
                      onChanged: (value) => _toggleItem(index),
                    ),
                    title: Text(
                      item['title'] ?? '',
                      style: TextStyle(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.grey : null,
                      ),
                    ),
                    subtitle: item['createdAt'] != null
                        ? Text(
                            DateTime.parse(item['createdAt']).toString().substring(0, 16),
                            style: const TextStyle(fontSize: 12),
                          )
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 20),
                          onPressed: () => _showEditItemDialog(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, size: 20),
                          onPressed: () => _removeItem(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddItemDialog,
        tooltip: '新しいアイテムを追加',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}