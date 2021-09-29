import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:xxxxxxx/model/search_result_item.dart';

class DbProvider {
  static Database _database;
  static final DbProvider db = DbProvider._();

  DbProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'item_list.db');

    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Items('
          'id INTEGER PRIMARY KEY,'
          'full_name TEXT,'
          'html_url TEXT,'
          'owner TEXT,'
          'stargazers_count INTEGER'
          ')');
    });
  }

  createItems(SearchResultItem searchResultItem) async {
    await deleteAllItems();
    final db = await database;
    final res = await db.insert('Items', searchResultItem.toJson());

    return res;
  }

  Future<int> deleteAllItems() async {
    final db = await database;
    final res = await db.rawDelete('DELETE FROM Items');

    return res;
  }

  Future<List<SearchResultItem>> getAllItems() async {
    final db = await database;
    final res = await db.rawQuery("SELECT * FROM Items");

    List<SearchResultItem> list = res.isNotEmpty
        ? res.map((c) => SearchResultItem.fromJson(c)).toList()
        : [];

    return list;
  }
}
